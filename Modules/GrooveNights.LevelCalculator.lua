-- GrooveNights level calculator
-- By Jayce Newton for OpenITG. Rewritten for SM5 by JoseVarela.
return function( player )
    -- Current EXP from the player
    local gnTotalPlayer = 0
    local PlayerLevel = 1
    local ExpMultiplier = 1
    -- First let's define neccesary elements.
    -- Based on the difficulty, we'll reward with a multiplier.
    -- This multiplier can multiply based on the level that you are.
    local Difs = {"Beginner","Easy","Medium","Hard","Challenge","Edit"}
    -- Tier multipliers. The higher tier (01, 02), the better the multiplier.
    local TierMult = { 10,8,7.5,7,6.5,6,5.5,5,4.5,4,3.5,3,2.5,2,1.5,1,1 }

    -- Time to calculate!
    local TierSum = {}
    for i,v in pairs( Difs ) do
        for Ti=1,17 do
            TierSum["Grade_Tier"..string.format("%02i",Ti)] = PROFILEMAN:GetProfile(player):GetTotalStepsWithTopGrade("StepsType_Dance_Single",v,"Grade_Tier"..string.format("%02i",Ti))
            gnTotalPlayer = gnTotalPlayer + i * TierMult[Ti] * TierSum["Grade_Tier"..string.format("%02i",Ti)]
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
    local AchievementStats = {
        SongCount = 0,
        ExpCount = 0,
        DeadCount = 0,
        StarCount = 0,
    }
    -- Song Count Calculation
    for _,var in pairs( Achievements[1] ) do
        if PROFILEMAN:GetProfile(player):GetNumTotalSongsPlayed() > var then AchievementStats.SongCount = _ end
    end
    -- Star Count Calculation
    local totalStars = 0
    for i=1,4 do totalStars = totalStars + TierSum["Grade_Tier"..string.format("%02i",i)] end
    for _,var in pairs( Achievements[4] ) do if totalStars > var then AchievementStats.StarCount = _ end end

    ExpMultiplier = ExpMultiplier + ( AchievementStats.SongCount/10 ) + ( AchievementStats.StarCount/10 )

    -- Done main calculation, now multiply based on the EXP Mult!
    gnTotalPlayer = gnTotalPlayer * ExpMultiplier

    -- Time to return our current level.
    local GNExperience = 0
    local gnExpCurve = 75
    local GNPercentage = 0
    local curlevcurve = 0
    for i= 1, 999 do
        -- Calculate each level before we check.
        local NewCurve = GNExperience
        GNExperience = GNExperience + ( gnExpCurve * math.pow( 1.5, i ))

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
    
    -- Now with everything complete, let's return 4 results. One is a progress bar, the other is the raw
    -- points of the current level, next is the current level and last one is the achievements.
    return {
        GNPercentage,
        gnTotalPlayer,
        PlayerLevel,
        curlevcurve,
        Achievements={ AchievementStats.SongCount, 0, 0, AchievementStats.StarCount }
    }
end