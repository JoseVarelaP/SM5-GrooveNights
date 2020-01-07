return function( pn )
	if GAMESTATE:IsPlayerEnabled( pn ) then
		local GPSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
		local ScoreToCalculate = GPSS:GetActualDancePoints()/GPSS:GetPossibleDancePoints()
		return ScoreToCalculate > 0 and FormatPercentScore( ScoreToCalculate ) or " 0.00%"
	end
	return " "
end