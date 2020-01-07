return function( name, pn )
	local ToGet = {
	["Steps"] = GAMESTATE:GetCurrentSteps(pn),
	["Trail"] = GAMESTATE:GetCurrentTrail(pn),
	}

	if ToGet[name] then
		local Shorten = ToEnumShortString( ToGet[name]:GetDifficulty() )
		return name == "Trail" and THEME:GetString("CourseDifficulty", Shorten) or THEME:GetString("Difficulty", Shorten)
	end
end