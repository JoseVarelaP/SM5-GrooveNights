return function( name, pn )
	local ToGet = {
		["Steps"] = GAMESTATE:GetCurrentSteps(pn),
		["Trail"] = GAMESTATE:GetCurrentTrail(pn),
	}

	local Diffs = {
		-- SteveReen, Taro, Grandpa, Default
		Profiles = {
			{"REEN","SteveReen"},
			{"TARO","TaroNuke"}
		},
        ["Beginner"] = {"Based","no","expert"},
        ["Easy"] = {"Based","haha","hard"},
        ["Medium"] = {"Based","banana","medium"},
        ["Hard"] = {"Based","yes","easy"},
        ["Challenge"] = {"Based","WinDEU","novice"},
    }

	if ToGet[name] then
		local Shorten = ToEnumShortString( ToGet[name]:GetDifficulty() )
		local finished
		finished = name == "Trail" and THEME:GetString("CourseDifficulty", Shorten) or THEME:GetString("Difficulty", Shorten)
		for _,v in pairs(Diffs.Profiles) do
			for i,a in pairs(v) do
				if PROFILEMAN:GetProfile(pn):GetDisplayName() == a then
					finished = Diffs[Shorten][_]
				end
			end
		end
		if GAMESTATE:Env()["AngryGrandpa"] then
			finished = Diffs[Shorten][3]
		end
		return finished
	end
end