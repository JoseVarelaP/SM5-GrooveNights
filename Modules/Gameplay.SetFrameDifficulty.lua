return function( pn, ResultsScreen )
	local data = {
		difficulties = {"Beginner","Easy","Medium","Hard","Challenge","Edit"},
		result = {nil,nil},
		types = {GAMESTATE:GetCurrentSteps(pn),GAMESTATE:GetCurrentTrail(pn)}
	}
	for a,t in ipairs(data.types) do
		for i,v in ipairs(data.difficulties) do
			if t then if t:GetDifficulty() == "Difficulty_"..v then data.result[a] = i-1 end end
		end
	end
	return ResultsScreen and data.result[2] or (data.result and data.result[1] or 0)
end