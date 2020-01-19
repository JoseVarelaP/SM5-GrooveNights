return function( pn , useRealScore )
	local GPSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
	local PDir = (PROFILEMAN:GetProfile(pn):GetDisplayName() ~= "" and MEMCARDMAN:GetCardState(pn) == 'MemoryCardState_none') and PROFILEMAN:GetProfileDir(string.sub(pn,-1)-1).."GrooveNightsPrefs.ini" or "Save/TEMP"..pn
    local isRealProf = LoadModule("Profile.IsMachine.lua")(pn)
	local config = isRealProf and LoadModule("Config.Load.lua")("ScoringFormat", PDir ) or GAMESTATE:Env()["ScoringFormatMachinetemp"..pn]
	local res
	local ScoreToCalculate = GPSS:GetActualDancePoints()/GPSS:GetPossibleDancePoints()
	local scoreModes = {
		-- Method 1: Normal Scoring
		function()
			res = ScoreToCalculate > 0 and FormatPercentScore( ScoreToCalculate ) or " 0.00%"
		end,
		-- Method 2: Reverse Scoring
		function()
			local reverseScore = GPSS:GetCurrentPossibleDancePoints() - GPSS:GetActualDancePoints()
			reverseScore = (( GPSS:GetPossibleDancePoints() - reverseScore ) / GPSS:GetPossibleDancePoints())
			res = ScoreToCalculate > 0 and FormatPercentScore( reverseScore ) or "100.00%"
		end,
		-- Method 3: Real Time Scoring
		function()
			local realTimeScore = GPSS:GetActualDancePoints() / GPSS:GetCurrentPossibleDancePoints()
			res = realTimeScore > 0 and FormatPercentScore(realTimeScore) or " 0.00%" 
		end,
		-- Method 4: Flat Scoring
		function()
			local totalNotes = LoadModule("Pane.RadarValue.lua")(pn,6)
			local notesHit = 0
			for i=1,5 do
				notesHit = notesHit + GPSS:GetTapNoteScores( "TapNoteScore_W"..i )
			end
			res = notesHit > 0 and FormatPercentScore( notesHit / totalNotes ) or " 0.00%"
		end,
	}
	if scoreModes[config+1] then
		scoreModes[config+1]( GPSS )
	else
		scoreModes[1]( GPSS )
	end
	if useRealScore then
		scoreModes[1]( GPSS )
	end
	return res
end