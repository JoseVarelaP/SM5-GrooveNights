local t = {
	Config = 0,
	FixedVal = nil,
	Player = nil,
	ScoreToCalculate = nil,
	TotalNotesInChart = 0,
	ScoreModes = {
		function( this )
			return FormatPercentScore( this.ScoreToCalculate:GetPercentDancePoints() )
		end,
		-- Method 2: Reverse Scoring
		function( this )
			local reverseScore = this.ScoreToCalculate:GetCurrentPossibleDancePoints() - this.ScoreToCalculate:GetActualDancePoints()
			reverseScore = (( this.ScoreToCalculate:GetPossibleDancePoints() - reverseScore ) / this.ScoreToCalculate:GetPossibleDancePoints())
			return this.ScoreToCalculate:GetPossibleDancePoints() > 0 and FormatPercentScore( reverseScore ) or "100.00%"
		end,
		-- Method 3: Real Time Scoring
		function( this )
			local realTimeScore = this.ScoreToCalculate:GetActualDancePoints() / this.ScoreToCalculate:GetCurrentPossibleDancePoints()
			return realTimeScore > 0 and FormatPercentScore(realTimeScore) or " 0.00%" 
		end,
		-- Method 4: Flat Scoring
		function( this )
			local notesHit = 0
			for i=1,5 do
				notesHit = notesHit + this.ScoreToCalculate:GetTapNoteScores( "TapNoteScore_W"..i )
			end
			return notesHit > 0 and FormatPercentScore( notesHit / this.TotalNotesInChart ) or " 0.00%"
		end,
	},
	__call = function( this, pn, fixedvalue )
		this.Player = pn
		local PDir = (PROFILEMAN:GetProfile(this.Player):GetDisplayName() ~= "" and MEMCARDMAN:GetCardState(this.Player) == 'MemoryCardState_none') and PROFILEMAN:GetProfileDir(string.sub(this.Player,-1)-1).."GrooveNightsPrefs.ini" or "Save/TEMP"..this.Player

		this.Config = LoadModule("Config.gnLoad.lua")(this.Player, "ScoringFormat")[1] or 0
		if GAMESTATE:IsDemonstration() then this.Config = 0 end

		this.TotalNotesInChart = LoadModule("Pane.RadarValue.lua")(this.Player,6)
		return this
	end,
	__shl = function( this, Forced )
		this.ScoreToCalculate = STATSMAN:GetCurStageStats():GetPlayerStageStats(this.Player)
		return Forced and this.ScoreModes[Forced+1]( this ) or ( this.ScoreModes[this.Config+1] and this.ScoreModes[this.Config+1]( this ) or this.ScoreModes[1]( this ) )
	end,
}

return setmetatable(t, t)