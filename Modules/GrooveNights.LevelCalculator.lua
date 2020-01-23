-- GrooveNights level calculator
-- By Jayce Newton for OpenITG. Rewritten for SM5 by JoseVarela.
return function( player )
    if not PROFILEMAN:GetProfile(player) then return end
    -- Current EXP from the player
    local gnTotalPlayer = 0
    -- Current Level for player (will be calculated later.)
    local PlayerLevel = 1
    -- Experience multiplier.
    local ExpMultiplier = 1
    -- First let's define neccesary elements.
    -- Based on the difficulty, we'll reward with a multiplier.
    -- This multiplier can multiply based on the level that you are.
    local Difs = {"Beginner","Easy","Medium","Hard","Challenge","Edit"}
    local StepTypes = {"StepsType_Dance_Single","StepsType_Dance_Double"}
    -- Tier multipliers. The higher tier (01, 02), the better the multiplier.
    local TierMult = { 10,8,7.5,7,6.5,6,5.5,5,4.5,4,3.5,3,2.5,2,1.5,1,1 }

    -- Time to calculate!
    -- This will get all achieved scores on each tier (01 to 17)
    -- and combine then into a table.
    local TierSum = {}
    for st in ivalues(StepTypes) do
        for i,v in pairs( Difs ) do
            for Ti=1,17 do
                if not TierSum["Grade_Tier"..string.format("%02i",Ti)] then
                    TierSum["Grade_Tier"..string.format("%02i",Ti)] = 0
                end
                TierSum["Grade_Tier"..string.format("%02i",Ti)] = TierSum["Grade_Tier"..string.format("%02i",Ti)] + PROFILEMAN:GetProfile(player):GetTotalStepsWithTopGrade(
                    st,v,"Grade_Tier"..string.format("%02i",Ti))
                gnTotalPlayer = gnTotalPlayer + i * TierMult[Ti] * PROFILEMAN:GetProfile(player):GetTotalStepsWithTopGrade(
                        st,v,"Grade_Tier"..string.format("%02i",Ti))
            end
        end
    end

    -- While we're at it, let's calculate the badges.
    local Achievements = {
        {100,500,1000}, -- SongCount
        {25,50,100}, -- ExpCount
        {25,50,100}, -- DeadCount
        {100,500,1000}, -- StarCount
    }

    -- We just need a profile check.
    -- [Cur Level - Ammount]
    local AchievementStats = {
        SongCount = {0,0},
        ExpCount = {0,0},
        DeadCount = {0,0},
        StarCount = {0,0},
    }
    -- Song Count Calculation
    for _,var in pairs( Achievements[1] ) do
        if PROFILEMAN:GetProfile(player):GetNumTotalSongsPlayed() >= var then AchievementStats.SongCount[1] = _ end
    end
    -- Star Count Calculation
    -- Had to do the Tier calculation again because the data gets lost before
    -- it reaches here.
    for st in ivalues(StepTypes) do
        for i,v in pairs( Difs ) do
            for Ti=1,4 do
                AchievementStats.StarCount[2] = AchievementStats.StarCount[2] + ( PROFILEMAN:GetProfile(player):GetTotalStepsWithTopGrade(
                    st,v,"Grade_Tier"..string.format("%02i",Ti)) * (5-Ti) )
            end
        end
    end
    for _,var in pairs( Achievements[4] ) do if AchievementStats.StarCount[2] >= var then AchievementStats.StarCount[1] = _ end end

    -- Lose Count Calculation
    -- Same with Star Calculation, the data gets lost on the way here, so
    -- we need to recalculate the tier.
    for st in ivalues(StepTypes) do
        for i,v in pairs( Difs ) do
            AchievementStats.DeadCount[2] = AchievementStats.DeadCount[2] + PROFILEMAN:GetProfile(player):GetTotalStepsWithTopGrade(
                st,v,"Grade_Failed")
            AchievementStats.DeadCount[2] = AchievementStats.DeadCount[2] + PROFILEMAN:GetProfile(player):GetTotalStepsWithTopGrade(
                st,v,"Grade_Tier17")
        end
    end
    for _,var in pairs( Achievements[3] ) do if AchievementStats.DeadCount[2] >= var then AchievementStats.DeadCount[1] = _ end end

    ExpMultiplier = ExpMultiplier + ( AchievementStats.SongCount[1]/10 ) + ( AchievementStats.StarCount[1]/10 ) + ( AchievementStats.ExpCount[1]/10 )

    -- Done main calculation, now multiply based on the EXP Mult!
    gnTotalPlayer = gnTotalPlayer * ExpMultiplier

    -- Time to return our current level.
    local GNExperience = 0
    local GNPercentage = 0
    local curlevcurve = 0
    for i= 1, 100 do -- MaxLevel on modern GrooveNights is 100.
        -- Calculate each level before we check.
        local NewCurve = GNExperience
        GNExperience = GNExperience + ( 75 * math.pow( 1.2, i ))

        if GNExperience <= gnTotalPlayer then
            -- yoy did gud, have another level
            PlayerLevel = PlayerLevel + 1
        else
            -- If we didn't get a new level, then calculate the threshold for the current level
            -- and then stop, we don't need to do all.
            gnTotalPlayer = gnTotalPlayer - NewCurve;
            NewCurve = GNExperience - NewCurve;
            curlevcurve = NewCurve
			GNPercentage = (gnTotalPlayer/NewCurve)*93
			break
        end
    end

    -- EXP Achievement check
    for _,var in pairs( Achievements[2] ) do if PlayerLevel >= var then AchievementStats.ExpCount = _ end end
    
    -- Now with everything complete, let's return the results.
    return {
        GNPercentage,       -- Current Level percentage
        gnTotalPlayer,      -- Total EXP obtain by the player so far
        PlayerLevel,        -- Current Player Level
        curlevcurve,        -- Current threshold to achieve for advancing to the next level
        TierSum,            -- Sum of each tier's scores
        Achievements={
            AchievementStats.SongCount[1], -- Song count level
            AchievementStats.ExpCount[1],  -- Experience count level
            AchievementStats.DeadCount[1], -- Dead count level
            AchievementStats.StarCount[1]  -- Star count level
        }
    }
end