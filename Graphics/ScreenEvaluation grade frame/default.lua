local player = ...
assert( player )

--local ach = LoadModule("GrooveNights.LevelCalculator.lua")(player)
local ach = GAMESTATE:Env()[player.."gnCalculation"]
-- This is to obtain data from the options the player has selected.
-- First we get the state. Then the option array, which is a bunch of strings that later give a table.
local PlayerState = GAMESTATE:GetPlayerState(player)
local PlayerOptions = PlayerState:GetPlayerOptionsArray(0)
-- We begin with an empty set.
local optionslist = ""
local PlayerGrade = "Grade_Tier17"
local GradeNum = 17

local PlayerStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

PlayerGrade = PlayerStats:GetGrade()
GradeNum = tonumber(string.sub( ToEnumShortString( PlayerGrade ), 5 ))
if PlayerStats:GetFailed( player ) then
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
if PlayerStats:GetPeakComboAward() ~= nil then
	if string.len( PlayerStats:GetPeakComboAward() ) > 1 then
		ComboAward = PlayerStats:GetPeakComboAward()
	end
end

-- time for checks for each PerDifficulty award.
if PlayerStats:GetStageAward() ~= nil then
	DiffAward = PlayerStats:GetStageAward()
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

local enableEXP = true

ach:GenerateFullData()

local function TrailOrSteps(pn)
	if GAMESTATE:IsCourseMode() then return GAMESTATE:GetCurrentTrail(pn) end
	return GAMESTATE:GetCurrentSteps(pn)
end

local t = Def.ActorFrame{}
local isvalidplayer = LoadModule("Profile.IsMachine.lua")(player)

local DoublesIsOn = GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" or GAMESTATE:Env()["UsingBOA"]
t[#t+1] = Def.ActorFrame{
	Def.Sprite{ Texture="base frame B" }..{
		OnCommand=function(self)
			self:diffuse(color("#060A0E"))
		end
	},
	Def.Sprite{ Texture="base frame F" }..{
		OnCommand=function(self)
			self:diffuse(color("#1C2C3C"))
		end
	},

	Def.Sprite{
		Texture=THEME:GetPathG("Player","combo/explosion"),
		OnCommand=function(self) self:xy( DoublesIsOn and -100 or -30*side(player), -200 ):spin():diffusealpha(0):zoom(0.6):sleep(0.2):linear(0.3):diffusealpha(0.5):zoom(1.2):linear(0.3):diffusealpha(0):zoom(1.7) end,
	},

	Def.Sprite{
		Texture=THEME:GetPathG("Player","combo/minisplode"),
		OnCommand=function(self) self:xy( DoublesIsOn and -100 or -30*side(player), -200 ):diffusealpha(0):zoom(0.6):sleep(0.2):linear(0.3):diffusealpha(0.5):zoom(1.2):addrotationz(10):linear(0.3):diffusealpha(0):zoom(1.5):addrotationz(10) end,
	},

	Def.Sprite{
		Texture=THEME:GetPathG("Player","combo/arrowsplode"),
		OnCommand=function(self) self:xy( DoublesIsOn and -100 or -30*side(player), -200 ):diffusealpha(0):zoom(0.6):sleep(0.2):linear(0.3):diffusealpha(0.5):zoom(1.2):addrotationz(10):linear(0.3):diffusealpha(0):zoom(1.7):addrotationz(10) end,
	},

	LoadActor( THEME:GetPathG("", "Grades/".. (
		ToEnumShortString( PlayerGrade ) ~= "Failed" and (GradeNum > 4 and "TierCommon" or ToEnumShortString( PlayerGrade ))
		or "Failed"
		) ..".lua" ), {player,GradeNum} )..{
		OnCommand=function(self) self:xy( (DoublesIsOn and -93 or -30)*side(player), -200 ) end,
	},

	Def.ActorFrame{
	OnCommand=function(self)
		self:xy( -156-1*3, -113 )
	end,
		Def.Sprite{
			Texture=THEME:GetPathG('_difficulty pips','B'),
			OnCommand=function(self)
				self:animate(0):playcommand("Update")
			end,
			UpdateCommand=function(self,parent) self:setstate( LoadModule("Gameplay.SetFrameDifficulty.lua")(player,true) ) end
		},

		Def.Sprite{
			Texture=THEME:GetPathG('_difficulty pips','F'),
			OnCommand=function(self)
				self:animate(0):diffuse(color("#1C2C3C"))
			end,
			UpdateCommand=function(self,parent) self:setstate( LoadModule("Gameplay.SetFrameDifficulty.lua")(player,true) ) end
		},

		Def.BitmapText{
			Font="Common Normal",
			OnCommand=function(self)
				self:zoom(0.5):xy(33,-6):strokecolor(Color.Black):playcommand("Update")
			end,
			UpdateCommand=function(self)
				self:settext( TrailOrSteps(player):GetMeter() )
			end
		},

		Def.BitmapText{
			Font="Common Normal",
			OnCommand=function(self)
				self:zoom(0.5):xy(102,-6):maxwidth(200)
				:settext(
					GAMESTATE:GetCurrentSteps(player):GetAuthorCredit() and GAMESTATE:GetCurrentSteps(player):GetAuthorCredit()
					or GAMESTATE:GetCurrentSteps(player):GetDescription()
				)
			end
		}
	},

	-- Avatar Frame
	Def.Sprite{
		Texture="nocard",
		Condition=not isvalidplayer,
		OnCommand=function(self)
			self:xy(-70,18):diffuse( color("#1C2C3C") )
		end,
		EvaluationInputChangedMessageCommand=function(self,param)
			if param.Player == player then
				self:stoptweening():linear(0.2):diffusealpha( param.Index == 1 and 1 or 0 )
			end
		end
	},
	Def.ActorFrame{
		Condition=isvalidplayer,
		OnCommand=function(self)
			self:xy( -100, 6 )
		end,
		EvaluationInputChangedMessageCommand=function(self,param)
			if param.Player == player then
				self:stoptweening():linear(0.2):diffusealpha( param.Index == 1 and 1 or 0 )
			end
		end,

		Def.Sprite{ 
			Texture=LoadModule("Options.GetProfileData.lua")(player)["Image"],
			OnCommand=function(self) self:setsize(64,64):diffusealpha(0):decelerate(0.2):diffusealpha(1) end,
		},
		Def.Sprite{			
			Texture=THEME:GetPathG("","AvatarFrame"),
			OnCommand=function(self)
				self:xy(0,0):diffuse( color("#1C2C3C") )
			end
		},

		Def.ActorFrame{
			Condition=enableEXP,
			OnCommand=function(self)
				self:xy( 6,60 )
			end,
			-- Level Indicator
			Def.BitmapText{
				Font="Common Normal",
				OnCommand=function(self)
					self:halign(0):xy( -38, -14 ):zoom(0.45)
					:settext( string.format(THEME:GetString("Level","Level"), ach.PlayerLevel) )
				end,
			},
			Def.BitmapText{
				Condition=LoadModule("Config.Load.lua")("ToggleEXPCounter","Save/GrooveNightsPrefs.ini"),
				Font="Common Normal",
				OnCommand=function(self)
					self:halign(1):xy( 48, -12 ):zoom(0.35)
					:settext( "(".. math.floor(ach.EXPCurrentLevel).."/".. math.floor(ach.EXPToNextLevel) ..")" )
				end,
			},
			Def.Quad{ OnCommand=function(self) self:diffuse( color("0.1,0.1,0.1,1") ):zoomto(90,4):xy(4,-2) end, },
			Def.Quad{ OnCommand=function(self) self:diffuse( color("0.6,0.8,0.9,1") ):zoomto(90,4):xy(4,-2)
				:cropright( 1-ach.EXPLevelTrunc ) end, },
			Def.Sprite{ Texture=THEME:GetPathG("","EXP/expBar") },
		}

	},

	LoadActor( THEME:GetPathO("","GraphDisplay"), { Pn = player, Width = 272, Height = 38  } )..{
		OnCommand=function(self)
			self:y(134-20)
		end
	},

		Def.ComboGraph{
			InitCommand=function(self)
				self:y( 134-10 )
			end,
			BeginCommand=function(self)
				self:Load("ComboGraphP"..pnum(player))
				local playerStageStats = PlayerStats
				local stageStats = STATSMAN:GetCurStageStats()
				self:Set(stageStats, playerStageStats)
			end,
		},

		Def.BitmapText{
			Font="journey/number/_journey 40", Text=LoadModule("Gameplay.CalculatePercentage.lua")(player) << 0, OnCommand=function(self)
				self:xy(DoublesIsOn and -110 or -46*side(player),-20-83-50):diffuse(PlayerColor(player))
				:zoom(0.8):decelerate(0.3):zoom(1):zoomy(0.9)
			end
		},
		
		
		Def.BitmapText{
			Font="novamono/36/_novamono 36px", Text=optionslist, OnCommand=function(self)
				self:xy(-65,-102):zoom(0.44):shadowlength(2):wrapwidthpixels(240):valign(0)
			end
		},

		Def.BitmapText{
			Condition=GAMESTATE:GetPlayMode() ~= "PlayMode_Rave",
			Font="novamono/36/_novamono 36px",OnCommand=function(self)
				self:xy(-65,-56):zoom(0.44):shadowlength(2):wrapwidthpixels(240):valign(0):diffusealpha(0.4)
			end,
			EvaluationInputChangedMessageCommand=function(self,param)
				if param.Player == player then
					self:finishtweening():diffusealpha(0.4):settext( string.format( THEME:GetString("ScreenEvaluation","Page"), param.Index, "2" ) ):sleep(0.3):linear(0.2):diffusealpha(0)
				end
			end,
		},

	-- LoadActor( "../ComboAwards/"..ComboAward..".lua" )..{ OnCommand=function(s) s:y(1.2) end },
	-- LoadActor( "../ComboAwards/"..DiffAward..".lua" )..{ OnCommand=function(s) s:y(1.2) end }
}

-- Achievement Icons
local Achievements = {
    5, -- SongCount
    8, -- ExpCount
    11, -- DeadCount
    14, -- StarCount
}
local achstats = ach:GetAchievementStats()
for _,v in pairs(Achievements) do
    t[#t+1] = Def.Sprite{
		Condition=isvalidplayer,
        Texture=THEME:GetPathG("",achstats[_] > 0 and "achievements/achievement".. string.format("%04i",(v-1)+achstats[_]) or "achievements/achievement".. string.format("%04i",(v)) ),
        OnCommand=function(self)
			self:xy( -50, (20 * (_-1))-24 ):zoom(0.8)
			:diffuse( achstats[_] > 0 and Color.White or color("#555555") )
		end,
		EvaluationInputChangedMessageCommand=function(self,param)
			if param.Player == player then
				self:stoptweening():linear( 0.2 ):diffusealpha( param.Index == 1 and 1 or 0 )
			end
		end,
    }
end

-- Now show the achieved scores
--ach:CalculateTierSums()
for i=1,4 do
	local total = ach.TierSum["Grade_Tier0"..i]
	t[#t+1] = Def.Sprite{
		Condition=isvalidplayer,
        Texture=THEME:GetPathG("","achievements/achievement".. string.format( "%04i", i )),
        OnCommand=function(self)
            self:xy( -28, (24*(i-1))-24 ):zoom(0.6)
		end,
		EvaluationInputChangedMessageCommand=function(self,param)
			if param.Player == player then
				self:stoptweening():linear( 0.2 ):diffusealpha( param.Index == 1 and 1 or 0 )
			end
		end
	}
	t[#t+1] = Def.BitmapText{
		Condition=isvalidplayer,
		Font="novamono/36/_novamono 36px",
		Text=total,
        OnCommand=function(self)
            self:xy( -11, (24*(i-1))-28 ):zoom(0.5):diffuse( PlayerColor(player) )
		end,
		EvaluationInputChangedMessageCommand=function(s,param)
			if param.Player == player then
				s:stoptweening():linear( 0.2 ):diffusealpha( param.Index == 1 and 1 or 0 )
			end
		end
    }
end

-- Info regarding all judgment data
local JudgmentInfo = {
	Types = { 'W1', 'W2', 'W3', 'W4', 'W5', 'Miss' },
	RadarVal = { "Jumps", "Holds", "Mines", "Hands", "Rolls" }
}

local PColor = {
	["PlayerNumber_P1"] = color("#836002"),
	["PlayerNumber_P2"] = color("#2F8425")
}

local Colors = {
	color("#3399cc"),
	color("#dda601"),
	color("#01cc33"),
	color("#7f7fff"),
	color("#f59331"),
	color("#ff3f3f")
}

local totalnote = 0

for index, ScWin in ipairs(JudgmentInfo.Types) do
	t[#t+1] = Def.ActorFrame{
		OnCommand=function(self) self:xy(130,-136) end,
		EvaluationInputChangedMessageCommand=function(s,param)
			if param.Player == player then
				s:stoptweening():sleep( 0.02*index ):linear( 0.2 ):diffusealpha( param.Index == 1 and 1 or 0 )
			end
		end,

		Def.BitmapText{
			Font="journey/40/_journey 40",
			-- Since we already define the strings for LuaTimings, that will be used,
			-- instead of making new lines.
			Text=THEME:GetString("ITG","Judgment"..ScWin),
			--Texture="judgment0012",
			OnCommand=function(self)
				self:xy( -124, 16*index-2 ):zoom(0.36):halign(0)
				:diffuse( Colors[index] )
			end
		},

		Def.BitmapText{ Font="ScreenEvaluation judge",
			OnCommand=function(self)
				self:y(1+16*index):zoom(0.5):halign(1):diffuse( PlayerColor(player) )
				local sco = PlayerStats:GetTapNoteScores("TapNoteScore_"..ScWin)
				totalnote = totalnote + sco
				self:settext(("%4.0f"):format( sco )):diffuse( PlayerColor(player) )
				local leadingZeroAttr = { Length=4-tonumber(tostring(sco):len()), Diffuse=PColor[player] }
				self:AddAttribute(0, leadingZeroAttr )
				if GAMESTATE:GetPlayMode() == "PlayMode_Rave" then
					self:xy(84,-96+16*index)
				end
			end
		},

		Def.Quad{
			OnCommand=function(self)
				self:xy(-120,16*index+8)
				:halign(0):diffusealpha(0):zoomx(0):zoomy(1)
				:accelerate((index/10)/2):zoomx(0):decelerate(0.2):diffusealpha(0.3):accelerate(0.2):diffusealpha(0.1)
				:zoomx(121):decelerate(0.2):diffusealpha(0.3):accelerate(0.2):diffusealpha(0.1)
			end
		},

		Def.Sound{
			Name="Sound",
			File=THEME:GetPathS("gnJudgeBar", index..".ogg"),
			SFXCommand=function(self) self:play() end
		},
		
		Def.Quad{
			OnCommand=function(self)
				self:xy(-120,16*index+8):diffuse( Colors[index] )
				:halign(0):diffusealpha(1):zoomx(0):zoomy(1):queuecommand("Calculate")
			end,
			CalculateCommand=function(self)
				local JudgeText = math.ceil(tonumber(PlayerStats:GetTapNoteScores("TapNoteScore_"..ScWin)) / totalnote * 121)
				if JudgeText >= 121 then JudgeText = 121 end
				self:sleep( ((index-1)/10)/2 ):accelerate(0.5):zoomx(JudgeText):queuecommand("SFX")
			end,
			SFXCommand=function(self)
				self:GetParent():GetChild("Sound"):playcommand("SFX")
			end	
		},

		Def.Sprite{
			Texture=THEME:GetPathG("Player","combo/arrowswoosh"),
			OnCommand=function(self) self:xy( -10, 16*index ):zoom(0):diffusealpha(0):playcommand("Bling") end,
			BlingCommand=function(self)
				self:sleep( (((index-1)/10)/2) +0.5):diffusealpha(1):zoom(0):addy(6):decelerate( 0.049*3 )
				:addx( 12 ):zoom( 0.2 ):diffusealpha( 0.4 ):linear( 0.049*3 ):diffusealpha(0)
			end,
		},
	}
end


for index, RCType in ipairs(JudgmentInfo.RadarVal) do
	local performance = PlayerStats:GetRadarActual():GetValue( "RadarCategory_"..RCType )
	local possible = PlayerStats:GetRadarPossible():GetValue( "RadarCategory_"..RCType )

	t[#t+1] = Def.ActorFrame{
		OnCommand=function(self) self:xy(128,-36) end,
		EvaluationInputChangedMessageCommand=function(self,param)
			if param.Player == player then
				self:stoptweening():sleep( 0.02*6 + (0.02*index)):linear( 0.2 ):diffusealpha( param.Index == 1 and 1 or 0 )
			end
		end,

		Def.BitmapText{ Font="ScreenEvaluation judge",
		OnCommand=function(self)
			self:xy( 0, 16*index ):zoom(0.5):halign(1)
			self:settext( ("%3i/%3i"):format(performance,possible) ):diffuse( PlayerColor(player) )

			local numper = tonumber(tostring(performance):len())
			
			local leadingPerfAttr = { Length=3-numper, Diffuse=PColor[player] }
			local leadingPossAttr = { Length=3-tonumber(tostring(possible):len()), Diffuse=PColor[player] }


			--lua.ReportScriptError( RCType..": " ..  )
			self:AddAttribute(0, leadingPerfAttr ):AddAttribute( (3-numper)+(numper+1), leadingPossAttr )
		end
		},

		Def.BitmapText{
			Font="journey/40/_journey 40",
			Text=THEME:GetString("PaneDisplay",RCType),
			--Texture="judgment0012",
			OnCommand=function(self)
				self:xy( -123, 16*index-3 ):zoom(0.36):halign(0)
			end
		},

		Def.Quad{
			OnCommand=function(self)
				self:xy(-120,16*index+7)
				:halign(0):diffusealpha(0):zoomx(0):zoomy(1)
				:accelerate(((index+6)/10)/2):zoomx(0):decelerate(0.2):diffusealpha(0.3):accelerate(0.2):diffusealpha(0.1)
				:zoomx(121):decelerate(0.2):diffusealpha(0.3):accelerate(0.2):diffusealpha(0.1)
			end
		},

		Def.Sound{
			Name="Sound",
			File=THEME:GetPathS("gnJudgeBar", (index+6)..".ogg"),
			SFXCommand=function(self) self:play() end
		},
		
		Def.Quad{
			OnCommand=function(self)
				self:xy(-120,16*index+7)
				:halign(0):diffusealpha(1):zoomx(0):zoomy(1):queuecommand("Calculate")
			end,
			CalculateCommand=function(self)
				local JudgeText = math.ceil(performance / possible * 121)
				if JudgeText >= 121 then JudgeText = 121 end
				-- lua.ReportScriptError( JudgeText .."/" .. totalnote )
				self:sleep( ((index+5)/10)/2 ):accelerate(0.5):zoomx(JudgeText):queuecommand("SFX")
			end,
			SFXCommand=function(self)
				self:GetParent():GetChild("Sound"):playcommand("SFX")
			end
		},

		Def.Sprite{
			Texture=THEME:GetPathG("Player","combo/arrowswoosh"),
			OnCommand=function(self) self:xy( -9, 16*(index) ):zoom(0):diffusealpha(0):playcommand("Bling") end,
			BlingCommand=function(self)
				self:sleep( (((index+6)/10)/2) +0.4):diffusealpha(1):zoom(0):addy(6):decelerate( 0.049*3 )
				:addx( 12 ):zoom( 0.2 ):diffusealpha(0.4):linear( 0.049*3 ):diffusealpha(0)
			end,
		},

	}
end

-- Max Combo
t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		if GAMESTATE:GetPlayMode() == "PlayMode_Rave" then
			self:xy(-71,-4)
		end
	end,
	EvaluationInputChangedMessageCommand=function(self,param)
		if param.Player == player then
			self:stoptweening():sleep(0.02*6):linear( 0.2 ):diffusealpha( param.Index == 1 and 1 or 0 )
		end
	end,

	Def.BitmapText{
		Font="journey/40/_journey 40",
		Text=THEME:GetString("ScreenEvaluation","MAXCOMBO"),
		--Texture="judgment0012",
		OnCommand=function(self)
			self:xy( 6, 16*3.6 ):zoom(0.38):halign(0)
		end
	},

	Def.BitmapText{ Font="ScreenEvaluation judge",
		OnCommand=function(self)
			self:xy( 128, 16*4-3 ):zoom(0.5):halign(1)
			local combo = PlayerStats:MaxCombo()
			self:settext( ("%5.0f"):format( combo ) )

			local leadingZeroAttr = { Length=5-tonumber(tostring(combo):len()), Diffuse=PColor[player] }
			self:AddAttribute(0, leadingZeroAttr )

			:diffuse( PlayerColor(player) )
			if GAMESTATE:GetPlayMode() == "PlayMode_Rave" then
				self:x(137)
			end
		end
	}
}

-- Arrow Breakdown / Offset Information
local offsetTable = GAMESTATE:Env()["OffsetTable"][player]
local timingWindow = GAMESTATE:Env()["perColJudgeData"][player]
local ArB = Def.ActorFrame{
	OnCommand=function(self)
		self:xy( -70, -116 ):diffusealpha(0)
		local total = offsetTable.Early + offsetTable.Late
		self:GetChild("Early"):cropright( 1 - (offsetTable.Early/total) )
		self:GetChild("Late"):cropleft( 1 - (offsetTable.Late/total) )
	end,
	EvaluationInputChangedMessageCommand=function(self,param)
		if param.Player == player then
			self:stoptweening():linear( 0.2 ):diffusealpha( param.Index == 1 and 0 or 1 )
		end
	end,
	Def.BitmapText{ Font="novamono/36/_novamono 36px", Text=Screen.String("Arrow Breakdown"), OnCommand=function(self) self:zoom(0.5):y(-8+96) end },
	Def.BitmapText{ Font="novamono/36/_novamono 36px", Text=Screen.String("Offset Derivative"), OnCommand=function(self) self:zoom(0.5):xy(140,-4) end },
	Def.BitmapText{ Font="novamono/36/_novamono 36px", Text=Screen.String("Early"), OnCommand=function(self) self:zoom(0.35):xy( 90,10 ) end },
	Def.BitmapText{ Font="novamono/36/_novamono 36px", Text=Screen.String("Late"), OnCommand=function(self) self:zoom(0.35):xy( 185,10 ) end },

	Def.BitmapText{ Font="novamono/36/_novamono 36px", Text=offsetTable.Early, OnCommand=function(self) self:zoom(0.35):xy( 90,24 ) end },
	Def.BitmapText{ Font="novamono/36/_novamono 36px", Text=offsetTable.Late, OnCommand=function(self) self:zoom(0.35):xy( 185,24 ) end },

	Def.Quad{ Name="Early", OnCommand=function(self) self:zoomto( 121, 1 ):xy( 138, 18 ):diffuse( Color.Blue ) end, },
	Def.Quad{ Name="Late", OnCommand=function(self) self:zoomto( 121, 1 ):xy( 138, 18 ):diffuse( Color.Red ) end, },
}

--local Side = {"&LEFT;","&DOWN;","&UP;","&RIGHT;"}

-- Noteskin Operation
local noteskin = GAMESTATE:GetPlayerState(player):GetPlayerOptions('ModsLevel_Song'):NoteSkin():lower()

-- Print the noteskin columns
local col = GAMESTATE:GetCurrentStyle():ColumnsPerPlayer()
for i=1,col do
	-- Check if the noteskin actually exists, otherwise warn, and use the first noteskin
	-- available on the array.
	if not NOTESKIN:DoesNoteSkinExist( noteskin ) then
		Warn( "The noteskin currently set does not exist on this game mode. Using ".. NOTESKIN:GetNoteSkinNames()[1] .." instead." )
		noteskin = NOTESKIN:GetNoteSkinNames()[1]
	end
	local tcol = GAMESTATE:GetCurrentStyle():GetColumnInfo( player, i )
	local sidespacing = scale( col,3,10,20,210 )
	ArB[#ArB+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:xy( scale( i, 1, col, -sidespacing, sidespacing ), 106 )
			:zoom(.3)
		end,
		NOTESKIN:LoadActorForNoteSkin( tcol["Name"], "Tap Note", noteskin)
	}

	for index, ValTC in ipairs(JudgmentInfo.Types) do
		ArB[#ArB+1] = Def.BitmapText{
			Font="novamono/36/_novamono 36px",
			Text=timingWindow[i][ValTC],
			OnCommand=function(self)
				self:xy( scale( i, 1, col, -sidespacing, sidespacing ), 12*index+108 ):zoom(0.5):diffuse( JudgmentLineToColor( "JudgmentLine_"..ValTC ) )
			end
		}
	end
end

if PlayerStats:IsDisqualified() then
	t[#t+1] = Def.ActorFrame{
		OnCommand=function(self)
			self:sleep(0.5):queuecommand("ShowStuff")
		end,
		Def.BitmapText{
			Font="Common Normal",
			Text=THEME:GetString("ScreenEvaluation","Disqualified"),
			OnCommand=function(self)
				self:xy(0,70):zoom(0.5):wrapwidthpixels(400):diffusealpha(0)
			end,
			ShowStuffCommand=function(self)
				self:easeoutcubic(0.3):y(90):diffusealpha(0.8)
			end
		},

		Def.Sound{
			File=THEME:GetPathS("MemoryCardManager","error"),
			ShowStuffCommand=function(self)
				self:play()
			end
		}
	}
end

local machineProfile = PROFILEMAN:GetMachineProfile()
-- local index = PlayerStats:GetMachineHighScoreIndex()
local SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
local StepsOrTrail = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(player) or GAMESTATE:GetCurrentSteps(player)
local highscoreList = (SongOrCourse and StepsOrTrail) and machineProfile:GetHighScoreList(SongOrCourse,StepsOrTrail)
local highscores = highscoreList and highscoreList:GetHighScores()
if highscores then
	for i=1,10 do
		local name = highscores[i] and highscores[i]:GetName() or "----"
		local score = highscores[i] and FormatPercentScore( highscores[i]:GetPercentDP() ) or "--.--%"
		local grade = highscores[i] and THEME:GetPathG("","Grades/GradeTier".. string.format("%04i", tonumber(string.sub( ToEnumShortString( highscores[i]:GetGrade() ), 5 )) ) )
			or THEME:GetPathG("","_blank")
		ArB[#ArB+1] = Def.ActorFrame{
			OnCommand=function(self)
				self:xy( 120, 35 + ( 16*(i-1) ) ):zoom(0.4)
				if score == LoadModule("Gameplay.CalculatePercentage.lua")(player) << 0 then
					local nm = {"Num","Nam","Scr"}
					for _,v in pairs(nm) do
						self:GetChild(v..i):diffuseshift():effectcolor1( Color.Yellow )
					end
				end
			end,

			Def.BitmapText{ Name="Num"..i, Font="novamono/36/_novamono 36px", Text="#"..i, OnCommand=function(self) self:x( -90 ) end, },
			Def.BitmapText{ Name="Nam"..i, Font="novamono/36/_novamono 36px", Text=name },
			Def.Sprite{ Texture=grade, OnCommand=function(self) self:setsize( 40,40 ):x( 76 ) end, },
			Def.BitmapText{ Name="Scr"..i, Font="novamono/36/_novamono 36px", Text=score, OnCommand=function(self) self:halign(1):x( 190 ) end, }
		}
	end
end

t[#t+1] = ArB

return t