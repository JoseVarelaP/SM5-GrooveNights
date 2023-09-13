GameColor.PlayerColors.PLAYER_1 = color("#FBBE03")
GameColor.PlayerColors.PLAYER_2 = color("#56FF48")

function DifficultyColor( dc )
	local coloring = {
		["Difficulty_Beginner"] = color("#7300C0"),
		["Difficulty_Easy"] =  color("#007300"),
		["Difficulty_Medium"] = color("#C0C000"),
		["Difficulty_Hard"] =  color("#C01D1D"),
		["Difficulty_Challenge"] = color("#1868C0"),
		["Difficulty_Edit"] =  color("#797979"),
	}
	return coloring[dc] or Color.White
end

Branch.AfterTitleMenu = function()
	if PROFILEMAN:GetNumLocalProfiles() > 1 then
		return "ScreenSelectProfile"
	end
	return "ScreenProfileLoad"
end

Branch.AfterProfileLoad = function()
	return Branch.AfterSelectProfile()
end

Branch.AfterSelectProfile = function()
	return "ScreenSelectStyle2"
end

function OptionNameString(str)
	return THEME:GetString('OptionNames',str)
end

LoadModule("Row.Prefs.lua")(LoadModule("Options.Prefs.lua"))

function ScreenPlayerOptions_Choices()
	local Main = "SPM,SPV,2,3A,3B,4,5,6,R1,R2,7,8,9,10,11,12,13,14,16,17"
	local gnOptions = "DefaultJudgmentSize,DefaultJudgmentOpacity,ToggleJudgmentBounce,DefaultComboSize,ToggleComboSizeIncrease,ToggleComboBounce,FlashComboColor,ToggleComboExplosion,ScoringFormat,gnGlobalOffset"
	return (GAMESTATE:Env()["gnNextScreen"] ~= "gnPlayerSettings" and Main or gnOptions) .. ",NextScreenOption"
end

function GNSettings_Choices()
    local settings = {
		["Judgment"] = "DefaultJudgmentSize,DefaultJudgmentOpacity,ToggleJudgmentBounce,TournamentCrownEnabled,DefaultComboSize,ToggleComboSizeIncrease,ToggleComboBounce,ToggleComboExplosion",
		["Menu"] = "ToggleEXPCounter,ToggleTotalPlayTime,ToggleSystemClock,OPERATORGlobalOffset,UsePauseMenu,AutoOffsetChangeOnBoot",
	}
    if settings[GAMESTATE:Env()["GNSetting"]] then
        return settings[GAMESTATE:Env()["GNSetting"]]
    end
    return "DefaultJudgmentSize,DefaultJudgmentOpacity,ToggleJudgmentBounce"
end

function gnPlayerOptionNextScreen()
	return GAMESTATE:Env()["gnNextScreen"] ~= "gnPlayerSettings" and GAMESTATE:Env()["gnNextScreen"] or "ScreenPlayerOptions"
end

function TextBannerAfterSet(self,param) 
	local Title=self:GetChild("Title") 
	local Subtitle=self:GetChild("Subtitle") 

	if Subtitle:GetText() == "" then 
		Title:y(-5):zoom(0.75)
		Subtitle:visible(false)
	else
		Title:y(-8):zoom(0.75)
		-- subtitle below title
		Subtitle:visible(true):y(4):zoom(0.55)
    end
end