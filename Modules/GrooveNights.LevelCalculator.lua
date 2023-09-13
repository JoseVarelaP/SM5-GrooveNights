-- GrooveNights level calculator
-- By Jayce Newton for OpenITG. Rewritten for SM5 by JoseVarela.

-- First let's define neccesary elements.
-- Based on the difficulty, we'll reward with a multiplier.
-- This multiplier can multiply based on the level that you are.
local Difs = {"Beginner","Easy","Medium","Hard","Challenge","Edit"}
local StepTypes = {"StepsType_Dance_Single","StepsType_Dance_Double"}

-- While we're at it, let's calculate the badges.
local Achievements = {
	{100,500,1000}, -- SongCount
	{25,50,100}, -- ExpCount
	{25,50,100}, -- DeadCount
	{100,500,1000}, -- StarCount
}

local TierMult = { 10,8,7.5,7,6.5,6,5.5,5,4.5,4,3.5,3,2.5,2,1.5,1,1 }

return setmetatable({
	-- Current EXP from the player
	gnTotalPlayer = 0,
	-- Current Level for player (will be calculated later.)
	PlayerLevel = 1,
	-- Experience multiplier.
	ExpMultiplier = 1,

	NeedsNewData = true,

	Profile = nil,
	TierSum = {},
	-- We just need a profile check.
	-- [Cur Level - Ammount]
	AchievementStats = {
		SongCount = {0,0},
		ExpCount = {0,0},
		DeadCount = {0,0},
		StarCount = {0,0},
	},

	EXPToNextLevel = 0,
	EXPLevelTrunc = 0,

	CanDoScoresWithGrade = function(this)
		return this.Profile.GetTotalScoresWithGrade ~= nil
	end,

	FormatGradeTier = function(this, grade)
		return "Grade_Tier"..string.format("%02i",grade)
	end,

	CalculateTierSums = function(this)
		if not this.NeedsNewData then return this end
		this.gnTotalPlayer = 0
		--[[
		if this:CanDoScoresWithGrade() then
			for Ti=1,17 do
				local curTier = "Grade_Tier"..string.format("%02i",Ti)
				this.TierSum[curTier] = this.Profile:GetTotalScoresWithGrade( Ti-1 )
				this.gnTotalPlayer = this.gnTotalPlayer + (TierMult[Ti] * this.TierSum[curTier])
			end
		else
			for _,st in pairs(StepTypes) do
				for i,v in pairs( Difs ) do
					for Ti=1,17 do
						local curTier = "Grade_Tier"..string.format("%02i",Ti)
						if not this.TierSum[curTier] then
							this.TierSum[curTier] = 0
						end

						local stepsWithGrade = this.Profile:GetTotalStepsWithTopGrade(st,v,curTier)
						this.TierSum[curTier] = this.TierSum[curTier] + stepsWithGrade
						this.gnTotalPlayer = this.gnTotalPlayer + (i * TierMult[Ti] * stepsWithGrade)
					end
				end
			end
		end
		]]
		for Ti=1,17 do
			this.TierSum[this:FormatGradeTier(Ti)] = 0
		end
		for STIndex,st in pairs(StepTypes) do
			for i,v in pairs( Difs ) do
				for Ti=1,17 do
					local curTier = this:FormatGradeTier(Ti)

					local stepsWithGrade = this.Profile:GetTotalStepsWithTopGrade(st,v,curTier)
					this.TierSum[curTier] = this.TierSum[curTier] + stepsWithGrade
					local calculation = (i * STIndex * TierMult[Ti] * stepsWithGrade)
					this.gnTotalPlayer = this.gnTotalPlayer + calculation
				end
			end
		end
		return this
	end,
	CalculateSongCount = function(this)
		if not this.NeedsNewData then return this end
		for _,var in pairs( Achievements[1] ) do
			if this.Profile:GetNumTotalSongsPlayed() >= var then this.AchievementStats.SongCount[1] = _ end
		end
		return this
	end,
	CalculateStarCount = function(this)
		if not this.NeedsNewData then return this end
		-- Had to do the Tier calculation again because the data gets lost before
		-- it reaches here.
		this.AchievementStats.StarCount[2] = 0
		if this:CanDoScoresWithGrade() then
			for Ti=1,4 do
				this.AchievementStats.StarCount[2] = this.AchievementStats.StarCount[2] + this.Profile:GetTotalScoresWithGrade( Ti-1 )
			end
		else
			for _,st in pairs(StepTypes) do
				for i,v in pairs( Difs ) do
					for Ti=1,4 do
						this.AchievementStats.StarCount[2] = this.AchievementStats.StarCount[2] + ( this.Profile:GetTotalStepsWithTopGrade(st,v,
						this:FormatGradeTier(Ti)) * (5-Ti) )
					end
				end
			end
		end

		for _,var in pairs( Achievements[4] ) do if this.AchievementStats.StarCount[2] >= var then this.AchievementStats.StarCount[1] = _ end end
		return this
	end,
	CalculateLostCount = function(this)
		if not this.NeedsNewData then return this end
		-- Same with Star Calculation, the data gets lost on the way here, so
		-- we need to recalculate the tier.
		this.AchievementStats.DeadCount[2] = 0
		if this:CanDoScoresWithGrade() then
			for i,v in pairs( Difs ) do
				this.AchievementStats.DeadCount[2] = this.AchievementStats.DeadCount[2] + this.Profile:GetTotalScoresWithGrade( "Grade_Failed" )
				this.AchievementStats.DeadCount[2] = this.AchievementStats.DeadCount[2] + this.Profile:GetTotalScoresWithGrade( "Grade_Tier17" )
			end
		else
			for _,st in pairs(StepTypes) do
				for i,v in pairs( Difs ) do
					this.AchievementStats.DeadCount[2] = this.AchievementStats.DeadCount[2] + this.Profile:GetTotalStepsWithTopGrade(st,v,"Grade_Failed")
					this.AchievementStats.DeadCount[2] = this.AchievementStats.DeadCount[2] + this.Profile:GetTotalStepsWithTopGrade(st,v,"Grade_Tier17")
				end
			end
		end
		for _,var in pairs( Achievements[3] ) do if this.AchievementStats.DeadCount[2] >= var then this.AchievementStats.DeadCount[1] = _ end end
		return this
	end,

	GenerateNewLevelFromCalculations = function(this)
		this.ExpMultiplier = 1 + ( this.AchievementStats.SongCount[1]/10 ) + ( this.AchievementStats.StarCount[1]/10 ) + ( this.AchievementStats.ExpCount[1]/10 )

		-- Done main calculation, now multiply based on the EXP Mult!
		local multipliedPlayerExp = this.gnTotalPlayer * this.ExpMultiplier
		lua.ReportScriptError(multipliedPlayerExp)
		-- this.gnTotalPlayer = this.gnTotalPlayer * this.ExpMultiplier

		-- Time to return our current level.
		local GNExperience = 0
		local GNPercentage = 0
		local lastLevelXPMargin = 0
		local curlevcurve = 0
		for i= 1, 99 do -- MaxLevel on modern GrooveNights is 100.
			-- Calculate each level before we check.
			local NewCurve = GNExperience
			GNExperience = GNExperience + ( 75 * math.pow( 1.2, i ))

			if GNExperience <= multipliedPlayerExp then
				-- yoy did gud, have another level
				this.PlayerLevel = i+1
			else
				-- If we didn't get a new level, then calculate the threshold for the current level
				-- and then stop, we don't need to do all.
				multipliedPlayerExp = multipliedPlayerExp - NewCurve;
				NewCurve = GNExperience - NewCurve;
				curlevcurve = NewCurve
				GNPercentage = multipliedPlayerExp/NewCurve
				break
			end
		end

		this.EXPCurrentLevel = multipliedPlayerExp
		this.EXPToNextLevel = curlevcurve
		this.EXPLevelTrunc = GNPercentage

		-- EXP Achievement check
		for _,var in pairs( Achievements[2] ) do if this.PlayerLevel >= var then this.AchievementStats.ExpCount[1] = _ end end
		return this
	end,

	GenerateFullData = function(this)
		if not this.NeedsNewData then return this end

		this:CalculateTierSums()
		this:CalculateSongCount()
		this:CalculateStarCount()
		this:CalculateLostCount()
		this:GenerateNewLevelFromCalculations()

		this.NeedsNewData = false
		return this
	end,

	PromiseNewData = function(this) this.NeedsNewData = true end,

	AchievedMaxLevel = function(this)
		return this.PlayerLevel >= 100
	end,

	GetAchievementStats = function(this)
		return {
			this.AchievementStats.SongCount[1], -- Song count level
			this.AchievementStats.ExpCount[1],  -- Experience count level
			this.AchievementStats.DeadCount[1], -- Dead count level
			this.AchievementStats.StarCount[1]  -- Star count level
		}
	end
}, {
	__call = function( this, player )
		if not PROFILEMAN:GetProfile(player) then return nil end
		this.Profile = PROFILEMAN:GetProfile(player)
		return this
	end
})