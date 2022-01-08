local function fnrformat(s,e,it,format)
	local num = {}
	for i = s,e,it or 1 do
		num[#num+1] = format and string.format( format, i ) or i
	end
	return num
end
return {
	DefaultJudgmentSize =
	{
		Default = 1,
		UserPref = true,
		Choices = fornumrange(0.1,1.5,0.1),
		Values = fornumrange(0.1,1.5,0.1),
	},
	DefaultJudgmentOpacity =
	{
		Default = 1,
		UserPref = true,
		Choices = fornumrange(0,1,0.1),
		Values = fornumrange(0,1,0.1),
	},
	FlashComboColor =
	{
		Default = true,
		UserPref = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ToggleJudgmentBounce =
	{
		Default = true,
		UserPref = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	TournamentCrownEnabled =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	DefaultComboSize =
	{
		Default = 1,
		UserPref = true,
		Choices = fornumrange(0.1,1.5,0.1),
		Values = fornumrange(0.1,1.5,0.1),
	},
	ToggleComboSizeIncrease =
	{
		Default = true,
		UserPref = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ToggleComboBounce =
	{
		Default = true,
		UserPref = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ToggleComboExplosion =
	{
		Default = true,
		UserPref = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ToggleEXPCounter = 
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ToggleTotalPlayTime = 
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	NextScreenOption = 
	{
		Default = "Gameplay",
		Choices = { OptionNameString("MusicSelection"),OptionNameString("Gameplay"),OptionNameString("GrooveNightsSettings"),OptionNameString("PlayerOptions") },
		Values = { "ScreenSelectMusic","ScreenStageInformation", "gnPlayerSettings", "ScreenPlayerOptions" },
		LoadFunc = function(self,list)
			list[2] = true return
		end,
		SaveFunc = function(self,list,player)
			for i,_ in ipairs(self.Values) do
				if list[i] == true then
					GAMESTATE:Env()["gnNextScreen"] = self.Values[i]
				end
			end
		end,
	},
	gnGlobalOffset =
	{
		Default = 0,
		Choices = fnrformat(-0.1,0.102,0.002,PREFSMAN:GetPreference("ThreeKeyNavigation") and tostring("%.3f") or ""),
		Values = fornumrange(-0.1,0.102,0.002),
		LoadFunc = function(self,list)
			if not GAMESTATE:Env()["NewOffset"] then GAMESTATE:Env()["NewOffset"] = string.format( "%.3f", PREFSMAN:GetPreference( "GlobalOffsetSeconds" ) ) end
			local envset = string.format("%.3f",GAMESTATE:Env()["NewOffset"])
			local set = string.format( "%.3f", PREFSMAN:GetPreference( "GlobalOffsetSeconds" ) )
			for i,_ in ipairs(self.Values) do
				if string.format("%.3f",_) == envset then
					list[i] = true
					MESSAGEMAN:Broadcast("gnGlobalOffsetChange",{choice=i})
					return
				end
			end
			list[16] = true
		end,
		SaveFunc = function(self,list,player)
			if not GAMESTATE:Env()["OriginalOffset"] then GAMESTATE:Env()["OriginalOffset"] = string.format( "%.3f", PREFSMAN:GetPreference( "GlobalOffsetSeconds" ) ) end
			for i,_ in ipairs(self.Values) do
				if list[i] == true then
					GAMESTATE:Env()["NewOffset"] = string.format("%.3f",_)
					if not GAMESTATE:Env()["HasOriginalOffset"] then
						LoadModule("Config.Save.lua")("MachineOffset",string.format("%.3f",_),"Save/GrooveNightsPrefs.ini")
						GAMESTATE:Env()["HasOriginalOffset"] = true
					end
				end
			end
		end,
	},
	OPERATORGlobalOffset =
	{
		Default = 0,
		Choices = fnrformat(-0.1,0.102,0.002,""),
		Values = fornumrange(-0.1,0.102,0.002),
		LoadFunc = function(self,list)
			local set = string.format( "%.3f", PREFSMAN:GetPreference( "GlobalOffsetSeconds" ) )
			for i,_ in ipairs(self.Values) do
				if string.format("%.3f",_) == set then
					list[i] = true
					MESSAGEMAN:Broadcast("OPERATORGlobalOffsetChange",{choice=i})
					return
				end
			end
			list[16] = true
		end,
		SaveFunc = function(self,list,player)
			for i,_ in ipairs(self.Values) do
				if list[i] == true then
					PREFSMAN:SetPreference("GlobalOffsetSeconds", string.format("%.3f",_))
					LoadModule("Config.Save.lua")("MachineOffset",string.format("%.3f",_),"Save/GrooveNightsPrefs.ini")
				end
			end
		end,
	},
	ToggleSystemClock = 
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	UsePauseMenu = 
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ScoringFormat = 
	{
		Default = 0,
		UserPref = true,
		Choices = { "Normal", "Reverse Scoring", "Real Time Scoring", "Flat Scoring" },
		Values = { 0, 1, 2, 3 }
	},
	SpeedModType =
	{
		Default = "x",
		UserPref = true,
		Choices = { THEME:GetString("OptionNames","SpeedX"), THEME:GetString("OptionNames","SpeedA"), THEME:GetString("OptionNames","SpeedM"), THEME:GetString("OptionNames","SpeedC") },
		Values = {"x","a","m","c"},
		LoadFunction = function(self,list,pn)
			if GAMESTATE:IsHumanPlayer(pn) then
				local po = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
				if po:AverageScrollBPM() > 0 then list[2] = true return
					elseif po:MaxScrollBPM() > 0 then list[3] = true return 
					elseif po:TimeSpacing() > 0 then list[4] = true return 
					else list[1] = true return 
				end
			end
		end,
		SaveFunction = function(self,list,pn) end,
	},
	SpeedModVal =
	{
		Default = 1,
		OneInRow = true,
		UserPref = true,
		Choices = {" "},
		Values = {" "},
		LoadFunction = function(self,list,pn) list[1] = true end,
		SaveFunction = function(self,list,pn) end,
	},
}
