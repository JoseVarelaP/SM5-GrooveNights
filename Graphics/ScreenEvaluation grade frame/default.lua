local player = ...
assert( player );

local ach = LoadModule("GrooveNights.LevelCalculator.lua")(player)
-- This is to obtain data from the options the player has selected.
-- First we get the state. Then the option array, which is a bunch of strings that later give a table.
local PlayerState = GAMESTATE:GetPlayerState(player)
local PlayerOptions = PlayerState:GetPlayerOptionsArray(0)
-- We begin with an empty set.
local optionslist = ""
local PlayerGrade = "Grade_Tier17"

PlayerGrade = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetGrade()
if STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetFailed( player ) then
	PlayerGrade = "Grade_Failed"
end

-- Now set a ipairs instance to get all things.
for k,option in ipairs(PlayerOptions) do
	if k < #PlayerOptions then
		optionslist = optionslist..option..", "
	else
		optionslist = optionslist..option
	end
end

-- This is to set the Combo award.
-- We begin with an empty set.
local ComboAward = "_empty"
local DiffAward = "_empty"

-- If we do get an award, then return the value it gives.
-- I know this is a shit method, but I've tried some others with no success.
if STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetPeakComboAward() ~= nil then
	if string.len( STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetPeakComboAward() ) > 1 then
		ComboAward = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetPeakComboAward()
	end
end

-- time for checks for each PerDifficulty award.
if STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetStageAward() ~= nil then
	DiffAward = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetStageAward()
end

local function side(pn)
	local s = 1
	if pn == PLAYER_1 then return s end
	return s*(-1)
end

local function pnum(pn)
	if pn == PLAYER_2 then return 2 end
	return 1
end

local function TrailOrSteps(pn)
	if GAMESTATE:IsCourseMode() then return GAMESTATE:GetCurrentTrail(pn) end
	return GAMESTATE:GetCurrentSteps(pn)
end

local t = Def.ActorFrame{};

local DoublesIsOn = GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides"
t[#t+1] = Def.ActorFrame{
	Def.Sprite{ Texture="base frame" }..{
		OnCommand=function(s)
			s:y(1.8)
			:x( GAMESTATE:GetPlayMode() == "PlayMode_Rave" and 0 or 0 )
		end;
	};

	LoadActor( THEME:GetPathG("", "Grades/".. ToEnumShortString( PlayerGrade ) .. ".lua" ) )..{
		OnCommand=function(s)
			s:xy( -91, -92 )
		end,
	},

	Def.ActorFrame{
	OnCommand=function(self)
		self:xy( ((DoublesIsOn and -170 or ( GAMESTATE:GetPlayMode() == "PlayMode_Rave" and -75 or -95))+(-1)*3)*side(player), (DoublesIsOn and -190 or -149)+6 )
	end;
		Def.Sprite{
			Texture=THEME:GetPathG('','_difficulty icons'),
			OnCommand=function(self)
				self:xy(0,0):animate(0):playcommand("Update")
			end;
			UpdateCommand=function(self,parent) self:setstate( LoadModule("Gameplay.SetFrameDifficulty.lua")(player,true) ) end,
		},

		Def.BitmapText{
			Font="Common Normal",
			OnCommand=function(self)
				self:zoom(0.5):x( -10 ):playcommand("Update");
			end;
			UpdateCommand=function(self)
					local steps = TrailOrSteps(player):GetDifficulty();
						if GAMESTATE:IsCourseMode() then
							self:settext( LoadModule("Gameplay.DifficultyName.lua")("Trail", player) )
						else
							self:settext( LoadModule("Gameplay.DifficultyName.lua")("Steps", player) )
						end
				end,
			},

		Def.BitmapText{
			Font="Common Normal",
			OnCommand=function(self)
				self:zoom(0.5):x(33):playcommand("Update")
			end;
			UpdateCommand=function(self)
					self:settext( TrailOrSteps(player):GetMeter() )
				end,
			},
	};

	-- Avatar Frame
	Def.ActorFrame{
		OnCommand=function(s)
			s:xy( 0*side(player), -168 )
		end,

		Def.Sprite {
			Texture=LoadModule("Options.GetProfileData.lua")(player)["Image"];
			OnCommand=function(s) s:setsize(70,70) end,
		},
		Def.Sprite{ Texture=THEME:GetPathG("","AvatarFrame") },
	},

		Def.GraphDisplay{
			InitCommand=function(self)
				self:y(-36+(1.3))
			end,
			BeginCommand=function(self)
				self:Load("GraphDisplayP"..pnum(player))
				local playerStageStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
				local stageStats = STATSMAN:GetCurStageStats()
				self:Set(stageStats, playerStageStats)
			end,
			OffCommand=function(s)
				s:accelerate(0.1):zoomy(0)
			end
		},

	--[[

		Def.ComboGraph{
			Condition=GAMESTATE:GetPlayMode() ~= "PlayMode_Rave",
			InitCommand=function(self)
				self:y(-7+(1.3))
			end,
			BeginCommand=function(self)
				self:Load("ComboGraphP"..pnum(player))
				local playerStageStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
				local stageStats = STATSMAN:GetCurStageStats()
				self:Set(stageStats, playerStageStats)
			end,
		},

		-- Grade time
		Def.Sprite{
			Condition=GAMESTATE:GetPlayMode() == "PlayMode_Rave",
			Texture="battle/Event/win",
			OnCommand=function(self)
				self:animate(0):xy(0,-114+(2.7)):zoom(0.9)
				:setstate( GAMESTATE:IsDraw() and 2 or ( GAMESTATE:IsWinner(player) and 0 or 1 ) )
			end
		},
		
	]]
		Def.BitmapText{
			Font="_futurist metalic", Text=LoadModule("Gameplay.CalculatePercentage.lua")(player), OnCommand=function(self)
				self:xy(30,-74+(2.7)):diffuse(PlayerColor(player))
				:zoom(0.9):linear(0.3):zoom(1)
				if GAMESTATE:GetPlayMode() == "PlayMode_Rave" then
					self:xy(60,-88+(2.7)):zoom(0.8):draworder(10000000000)
				end
			end
		},
		
		
		Def.BitmapText{
			Condition=GAMESTATE:GetPlayMode() ~= "PlayMode_Rave",
			Font="_eurostile normal", Text=optionslist, OnCommand=function(self)
				self:xy(38,-108+(2.7)):zoom(0.48):shadowlength(2):wrapwidthpixels(460)
			end
		},
			

	Def.BitmapText{ Font="Common Normal", Text=THEME:GetString("ScreenEvaluation","Disqualified"),
	Condition=STATSMAN:GetCurStageStats():GetPlayerStageStats(player):IsDisqualified();
	OnCommand=function(self)
		self:xy(0,-26):zoom(0.6):shadowlength(2):wrapwidthpixels(400):diffusealpha(0.4)
	end,
	},

	-- LoadActor( "../ComboAwards/"..ComboAward..".lua" )..{ OnCommand=function(s) s:y(1.2) end; };
	-- LoadActor( "../ComboAwards/"..DiffAward..".lua" )..{ OnCommand=function(s) s:y(1.2) end; };
};

-- Info regarding all judgment data
local JudgmentInfo = {
	Types = { 'W1', 'W2', 'W3', 'W4', 'W5', 'Miss' },
	RadarVal = { "Jumps", "Holds", "Mines", "Hands", "Rolls" },
};

for index, ValTC in ipairs(JudgmentInfo.Types) do
	t[#t+1] = Def.ActorFrame{
		OnCommand=function(self) self:xy(-134,31-18) end;
		Def.Sprite{ Texture="judgment"..string.format("%04i",index),
		OnCommand=function(s)
			s:y(3+(16*index)):zoom(0.7):horizalign(left)
		end;
		};
	};
end

local PColor = {
	["PlayerNumber_P1"] = color("#836002"),
	["PlayerNumber_P2"] = color("#2F8425"),
};

for index, ScWin in ipairs(JudgmentInfo.Types) do
	t[#t+1] = Def.ActorFrame{
		Condition=not GAMESTATE:Env()["WorkoutMode"],
		OnCommand=function(self) self:xy(-10,31-16) end;
		Def.BitmapText{ Font="ScreenEvaluation judge",
		OnCommand=function(self)
			self:y(1+16*index):zoom(0.5):halign(1):diffuse( PlayerColor(player) )
			local sco = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_"..ScWin)
			self:settext(("%4.0f"):format( sco )):diffuse( PlayerColor(player) )
			local leadingZeroAttr = { Length=4-tonumber(tostring(sco):len()); Diffuse=PColor[player] }
			self:AddAttribute(0, leadingZeroAttr )
			if GAMESTATE:GetPlayMode() == "PlayMode_Rave" then
				self:xy(84,-96+15.8*index)
			end
		end;
		};
	};
end


for index, RCType in ipairs(JudgmentInfo.RadarVal) do
	local performance = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetRadarActual():GetValue( "RadarCategory_"..RCType )
	local possible = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetRadarPossible():GetValue( "RadarCategory_"..RCType )

	t[#t+1] = Def.ActorFrame{
		Condition=not GAMESTATE:Env()["WorkoutMode"],
		OnCommand=function(self)
			self:xy(128,31-16)
			if GAMESTATE:GetPlayMode() == "PlayMode_Rave" then
				self:xy(66,32-18)
			end
		end;

		Def.BitmapText{ Font="ScreenEvaluation judge",
		OnCommand=function(self)
			self:xy( -40, 16*index ):zoom(0.5):halign(1)
			self:settext(("%3i"):format(performance)):diffuse( PlayerColor(player) )
			local leadingZeroAttr = { Length=3-tonumber(tostring(performance):len()); Diffuse=PColor[player] }
			self:AddAttribute(0, leadingZeroAttr )
		end;
		};
		
		Def.BitmapText{ Font="ScreenEvaluation judge",
		OnCommand=function(self)
			self:y( 16*index ):zoom(0.5):halign(1)
			self:settext(("%3i"):format(possible)):diffuse( PlayerColor(player) )
			local leadingZeroAttr = { Length=3-tonumber(tostring(possible):len()); Diffuse=PColor[player] }
			self:AddAttribute(0, leadingZeroAttr )
		end;
		};

		Def.Sprite{ Texture="judgment"..string.format("%04i",index+6),
		OnCommand=function(self)
			self:xy( -125, 1+(16*index-1) ):zoom(0.7):halign(0)
		end;
		};

		Def.BitmapText{ Font="ScreenEvaluation judge", Text="/",
		OnCommand=function(self)
			self:xy( -40, 16*index -1 ):zoom(0.5):halign(0):diffuse( PlayerColor(player) )
		end;
		};

	};
end

-- Max Combo
t[#t+1] = Def.ActorFrame{
	Condition=not GAMESTATE:Env()["WorkoutMode"],
	OnCommand=function(s)
		if GAMESTATE:GetPlayMode() == "PlayMode_Rave" then
			s:xy(-71,-4)
		end
	end;
	Def.Sprite{ Texture="judgment0012",
	OnCommand=function(self)
		self:xy( 3, 16*7 ):zoom(0.7):halign(0)
	end;
	};

	Def.BitmapText{ Font="ScreenEvaluation judge";
	OnCommand=function(self)
		self:xy( 128, 16*7-1 ):zoom(0.5):halign(1)
		local combo = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):MaxCombo()
		self:settext( ("%5.0f"):format( combo ) )

		local leadingZeroAttr = { Length=5-tonumber(tostring(combo):len()); Diffuse=PColor[player] }
		self:AddAttribute(0, leadingZeroAttr )

		:diffuse( PlayerColor(player) )
		if GAMESTATE:GetPlayMode() == "PlayMode_Rave" then
			self:x(137)
		end
	end;
	};

}

local Tags = { "BPM", "Speed", "Steps" }

for _,v in pairs(Tags) do
	t[#t+1] = Def.BitmapText{
		Font="_eurostile normal",
		Text= player == PLAYER_1 and v..":" or ":"..v,
		OnCommand=function(s)
			s:halign( player == PLAYER_1 and 0 or 1 ):zoom(0.5):diffuse(color("0.6,0.8,0.9,1"))
			s:xy( -140*side(player), -196+(14*(_-1)) )
		end,
	}

	t[#t+1] = Def.BitmapText{
		Font="_eurostile normal",
		Text=100,
		OnCommand=function(s)
			s:halign( player == PLAYER_1 and 0 or 1 ):zoom(0.5)
			s:xy( -104*side(player), -196+(14*(_-1)) ):maxwidth(120)

			local funct = {
				function()
					local Steps = GAMESTATE:GetCurrentSteps(player)
			        local val = ""
			        if Steps then
				        local bpms = Steps:GetDisplayBpms()
				        if bpms[1] == bpms[2] then
					        val = string.format("%i", math.floor(bpms[1]) )
				        else
					        val = string.format("%i-%i",math.floor(bpms[1]),math.floor(bpms[2]))
				        end
					end
					return val
				end,
				function()
					return GetSpeedModeAndValueFromPoptions(player)
				end,
				function()
					if GAMESTATE:GetCurrentSteps(player) then
						local st = GAMESTATE:GetCurrentSteps(player)
						return st:GetAuthorCredit() and st:GetAuthorCredit() or st:GetDescription()
					end
				end,
			}

			s:settext( funct[_]() )
		end,
	}
end

t[#t+1] = Def.ActorFrame{
    OnCommand=function(s)
        s:xy( -100*side(player), -210 )
	end,
	-- Level Indicator
	Def.BitmapText{
		Font="Common Normal",
		OnCommand=function(s)
			s:halign(0):xy( -38, -12 ):zoom(0.5)
			s:settext( "Level ".. ach[3] )
		end,
	},
	Def.BitmapText{
		Condition=LoadModule("Config.Load.lua")("ToggleEXPCounter","Save/GrooveNightsPrefs.ini"),
		Font="Common Normal",
		OnCommand=function(s)
			s:halign(1):xy( 48, -11 ):zoom(0.3)
			s:settext( "(".. math.floor(ach[2]).."/".. math.floor(ach[4]) ..")" )
		end,
	},
    Def.Quad{ OnCommand=function(s) s:diffuse( color("0.1,0.1,0.1,1") ):zoomto(90,4):xy(4,-2) end, },
	Def.Quad{ OnCommand=function(s) s:diffuse( color("0.6,0.8,0.9,1") ):zoomto(90,4):xy(4,-2)
		:cropright( (100-ach[1])/100 ) end, },
    Def.Sprite{ Texture=THEME:GetPathG("","EXP/expBar") },
}

return t;