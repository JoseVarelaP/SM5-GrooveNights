local function fnrformat(s,e,it,format)
	local num = {}
	for i = s,e,it or 1 do
		num[#num+1] = format or i
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
		Choices = { "Music Selection","Gameplay", "GrooveNights Settings" ,"Player Options" },
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
		Choices = fnrformat(-1.5,1.5,0.02,""),
		Values = fornumrange(-1.5,1.5,0.02),
		LoadFunc = function(self,list)
			local function roundyes(x)
				return x>0 and math.floor(x+0.5) or math.ceil(x-0.5)
			end
			local set = string.format( "%.2f", PREFSMAN:GetPreference( "GlobalOffsetSeconds" ) )
			for i,_ in ipairs(self.Values) do
				if string.format("%.2f",_) == set then
					list[i] = true
					MESSAGEMAN:Broadcast("gnGlobalOffsetChange",{choice=i})
					return
				end
			end
			list[16] = true
		end,
		SaveFunc = function(self,list,player)
			for i,_ in ipairs(self.Values) do
				if list[i] == true then
					PREFSMAN:SetPreference( "GlobalOffsetSeconds", _ )
				end
			end
		end,
	},
}
