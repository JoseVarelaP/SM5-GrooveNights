return function(pn)
	if GAMESTATE:IsPlayerEnabled(pn) then
                local GPSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
                local ScoreToCalculate = GPSS:GetActualDancePoints()/GPSS:GetPossibleDancePoints()
                return ScoreToCalculate
        end
        return 0
end