GameColor.PlayerColors.PLAYER_1 = color("#FBBE03")
GameColor.PlayerColors.PLAYER_2 = color("#56FF48")

function DifficultyColor( dc )
	if dc == "Difficulty_Beginner"	then return color("#7300C0") end
	if dc == "Difficulty_Easy"		then return color("#007300") end
	if dc == "Difficulty_Medium"	then return color("#C0C000") end
	if dc == "Difficulty_Hard"		then return color("#C01D1D") end
	if dc == "Difficulty_Challenge"	then return color("#1868C0") end
	if dc == "Difficulty_Edit"		then return color("#797979") end
	return Color.White
end

function OptionNameString(str)
	return THEME:GetString('OptionNames',str)
end

LoadModule("Row.Prefs.lua")(LoadModule("Options.Prefs.lua"))

function ScreenPlayerOptions_Choices()
	local Main = "1,8"
	return Main
end

function GNSettings_Choices()
    local settings = {
		["Judgment"] = "DefaultJudgmentSize,DefaultJudgmentOpacity,ToggleJudgmentBounce,TournamentCrownEnabled,DefaultComboSize,ToggleComboSizeIncrease,ToggleComboBounce,ToggleComboExplosion",
		["Menu"] = "ToggleEXPCounter,ToggleTotalPlayTime"
	}
    if settings[GAMESTATE:Env()["GNSetting"]] then
        return settings[GAMESTATE:Env()["GNSetting"]]
    end
    return "DefaultJudgmentSize,DefaultJudgmentOpacity,ToggleJudgmentBounce"
end

function TextBannerAfterSet(self,param) 
	local Title=self:GetChild("Title") 
	local Subtitle=self:GetChild("Subtitle") 

	if Subtitle:GetText() == "" then 
		Title:y(2)
		Title:zoom(0.75)

		Subtitle:visible(false)
	else
		Title:y(-4)
		Title:zoom(1)
		Title:zoom(0.75)

		-- subtitle below title
		Subtitle:visible(true)
		Subtitle:y(8)
		Subtitle:zoom(0.55)
    end
end