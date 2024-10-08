-- Gameplay Bar
local ProgressBar = Def.ActorFrame{
	OnCommand=function(s)
		s:xy( SCREEN_CENTER_X, 24 )
	end,
	Def.Sprite{ Texture="meter measure", OnCommand=function(s) s:zoomtowidth( WideScale(440, 424+154) ):diffuse( color("#1C2C3C") ) end, },
	Def.SongMeterDisplay{
		StreamWidth=WideScale(414, 424+128),
		Stream=Def.Sprite{ 
			Texture="meter stream",
		},
		Tip=Def.Sprite{ Texture="tip" }
	},

	LoadActor( "./WideScreen Progressbar.lua" ),

	Def.BitmapText{
		Font="novamono/36/_novamono 36px",
		OnCommand=function(self) self:zoom(0.6):y(-4):strokecolor(Color.Black):maxwidth( SCREEN_WIDTH/1.02 ) end,
		InitCommand=function(self)
			if not GAMESTATE:IsCourseMode() then
				self:playcommand("Update")
			end
		end,
		CurrentSongChangedMessageCommand=function(self) self:playcommand("Update") end,
		UpdateCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			self:settext( song and ( GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse():GetDisplayFullTitle().." - "..song:GetDisplayFullTitle() or song:GetDisplayFullTitle()) or "", song:GetTranslitFullTitle() )
		end
	}
}

local usesystemclock = LoadModule("Config.Load.lua")("ToggleSystemClock","Save/GrooveNightsPrefs.ini")
local CurrentStage = LoadActor("../CurrentStage.lua")..{
	BeforeLoadingNextCourseSongMessageCommand=function(self)
		self:finishtweening():tween(0.3,"easeoutexpo"):Center():zoom(2.5):sleep(0.5)
		:zoom( 1 ):y( usesystemclock and SCREEN_BOTTOM-58 or SCREEN_BOTTOM-40)
	end,
	OnCommand=function(self)
		self:Center():draworder(105):zoom(3.5)
		--:linear(0.3)
		:tween(0.5,"easeoutexpo")
		:zoom( 1 )
		:y( usesystemclock and SCREEN_BOTTOM-58 or SCREEN_BOTTOM-40)
	end
}
local Score = Def.ActorFrame{}
local pn_to_color_name= {[PLAYER_1]= "PLAYER_1", [PLAYER_2]= "PLAYER_2"}

for player in ivalues( GAMESTATE:GetEnabledPlayers() ) do
	local color = GameColor.PlayerColors[pn_to_color_name[player]]
	local PDir = (PROFILEMAN:GetProfile(player):GetDisplayName() ~= "" and MEMCARDMAN:GetCardState(player) == 'MemoryCardState_none') and PROFILEMAN:GetProfileDir(string.sub(player,-1)-1).."GrooveNightsPrefs.ini" or "Save/TEMP"..player
	local isRealProf = LoadModule("Profile.IsMachine.lua")(player)
	local totalNotes = LoadModule("Pane.RadarValue.lua")(player,6)
	local config = LoadModule("Config.gnLoad.lua")(player, "ScoringFormat")[1] or 0
	config = tonumber(config)
	local ach = GAMESTATE:Env()[player.."gnCalculation"] and GAMESTATE:Env()[player.."gnCalculation"](player) or nil
	
	local ScoringMethodology = LoadModule("Gameplay.CalculatePercentage.lua")( player )
	Score[#Score+1] = Def.BitmapText{
		Condition=GAMESTATE:IsPlayerEnabled(player) and GAMESTATE:GetPlayMode() ~= "PlayMode_Oni";
		Font="journey/number/_journey 40",
		OnCommand=function(self)
			self:xy( player == PLAYER_1 and SCREEN_CENTER_X-180 or SCREEN_CENTER_X+180, 56 )
			:diffuse( color ):zoomy(0.9):playcommand("UpdateScore")
		end,
		JudgmentMessageCommand=function(self) self:queuecommand("UpdateScore") end,
		UpdateScoreCommand=function(self)
			if not GAMESTATE:Env()["UsingBOA"] then
				if PREFSMAN:GetPreference("BothAtOnce") then
					GAMESTATE:Env()["UsingBOA"] = true
				end
			end
			self:settext( ScoringMethodology << nil )
		end
	}


	-- Dedicated true score percentage.
	-- Only applicable on Flat Scoring
	if config == 3 then
		Score[#Score+1] = Def.BitmapText{
			Condition=GAMESTATE:IsPlayerEnabled(player) and GAMESTATE:GetPlayMode() ~= "PlayMode_Oni",
			Font="journey/number/_journey 40",
			OnCommand=function(self)
				self:xy( player == PLAYER_1 and SCREEN_CENTER_X-156 or SCREEN_CENTER_X+156, SCREEN_TOP+76 ):zoomx(0.6):zoomy(0.54)
				:diffuse( color ):playcommand("UpdateScore")
			end,
			JudgmentMessageCommand=function(self) self:queuecommand("UpdateScore") end,
			UpdateScoreCommand=function(self)
				local GPSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
				local ScoreToCalculate = GPSS:GetPercentDancePoints()
				self:settext( ScoringMethodology << 0 )
			end
		}
	end

	if GAMESTATE:GetNumPlayersEnabled() == 2 then
		Score[#Score+1] = Def.Sprite{
			Condition=GAMESTATE:IsPlayerEnabled(player),
			Texture="winning.png",
			OnCommand=function(self)
				local margin = 40
				self:xy( player == PLAYER_1 and margin or SCREEN_RIGHT-margin, SCREEN_CENTER_Y-110 )
				:zoom(0.6):rotationz( player == PLAYER_1 and 30 or -30 )
			end,
			JudgmentMessageCommand=function(self) self:queuecommand("UpdateScore") end,
			UpdateScoreCommand=function(self)
				-- time to check who's winning
				self:visible( LoadModule("Gameplay.RealTimeWinnerCalculation.lua")(player) > LoadModule("Gameplay.RealTimeWinnerCalculation.lua")(player == PLAYER_1 and 1 or 0) )
			end
		}
	end

	Score[#Score+1] = Def.ActorFrame{
		OnCommand=function(s)
			s:xy( player == PLAYER_1 and 56 or SCREEN_RIGHT-56, 25 )
		end,
		OffCommand=function() if ach then ach:PromiseNewData() end end,
		Def.Sprite{
			Condition=GAMESTATE:IsPlayerEnabled(player),
			Texture=THEME:GetPathG("_difficulty","icons"),
			OnCommand=function(s)
			   s:zoomx( player == PLAYER_1 and 1 or -1 ):animate(0)
			end;
			-- Update Difficulty frame when update begins.
			["CurrentSteps".. ToEnumShortString(player) .."ChangedMessageCommand"]=function(s) s:playcommand("Update"); end;
			UpdateCommand=function(s,parent) s:setstate( LoadModule("Gameplay.SetFrameDifficulty.lua")(player) ) end,
		},

		Def.BitmapText{
			Font="novamono/36/_novamono 36",
			OnCommand=function(s) s:zoom(0.6):xy( player == PLAYER_1 and -12 or 12, -5 ):strokecolor(Color.Black) end,
			["CurrentSteps".. ToEnumShortString(player) .."ChangedMessageCommand"]=function(s)
				s:playcommand("Update")
			end;
			UpdateCommand=function(s)
				if GAMESTATE:GetCurrentSteps(player) then
					local steps = GAMESTATE:GetCurrentSteps(player):GetDifficulty();
					s:settext( LoadModule("Gameplay.DifficultyName.lua")("Steps", player) ):maxwidth(90)
				end
			end,
		},

		Def.BitmapText{
			Font="novamono/36/_novamono 36",
			OnCommand=function(s)
				s:zoom(0.6):xy(player == PLAYER_1 and 33 or -32,-5):strokecolor(Color.Black):playcommand("Update")
			end;
			["CurrentSteps".. ToEnumShortString(player) .."ChangedMessageCommand"]=function(s)
				s:playcommand("Update")
			end;
			UpdateCommand=function(s)
				if GAMESTATE:GetCurrentSteps(player) then
					s:settext( GAMESTATE:GetCurrentSteps(player):GetMeter() )
				end
			end,
		},
	}
end

local StepsData = {}
local CurBPM, SongPosition
local bpmDisplay, MusicRate
local TimingDiverged = false

-- the update function when two BPM Displays are needed for divergent TimingData (split BPMs)
local Update2PBPM = function(self)
	MusicRate = GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate()
	-- need current bpm for p1 and p2
	if GAMESTATE:GetNumPlayersEnabled() == 2 and TimingDiverged then
		local dispP1 = self:GetChild("DisplayP1")
		local dispP2 = self:GetChild("DisplayP2")
		for player in ivalues( GAMESTATE:GetEnabledPlayers() ) do
			bpmDisplay = (player == PLAYER_1) and dispP1 or dispP2
			SongPosition = GAMESTATE:GetPlayerState(player):GetSongPosition()
			if bpmDisplay then
				bpmDisplay:settext( round( SongPosition:GetCurBPS() * 60 * MusicRate ) )
			end
		end
	else
		bpmDisplay = self:GetChild("Display")
		SongPosition = GAMESTATE:GetPlayerState( GAMESTATE:GetMasterPlayerNumber() ):GetSongPosition()
		bpmDisplay:settext( round( SongPosition:GetCurBPS() * 60 * MusicRate ) )
	end
end

local BPMDisplay = Def.ActorFrame{
	OnCommand=function(s) if GAMESTATE:IsDemonstration() then s:addy(20) end end,
}

local function DoubleBPMActor()
	return Def.ActorFrame{
		OnCommand=function(s) s:xy( SCREEN_CENTER_X,50 ):SetUpdateFunction(Update2PBPM) end,
		Def.BitmapText{ Name="DisplayP1", Font="novamono/36/_novamono 36px", OnCommand=function(s) s:strokecolor(Color.Black):x( -30 ) end, },
		Def.BitmapText{ Name="DisplayP2", Font="novamono/36/_novamono 36px", OnCommand=function(s) s:strokecolor(Color.Black):x( 30 ) end, },
	}
end

local function SingleBPMActor()
	return Def.ActorFrame{
		OnCommand=function(s) s:xy( SCREEN_CENTER_X,50 ):SetUpdateFunction(Update2PBPM) end,
		Def.BitmapText{ Name="Display", Font="novamono/36/_novamono 36px", OnCommand=function(s) s:strokecolor(Color.Black) end },
	}
end

for player in ivalues( GAMESTATE:GetEnabledPlayers() ) do
	-- First we need to check if both players are on the same BPM course.
	-- Add each player's BPM to verify.
	if GAMESTATE:IsPlayerEnabled(player) and GAMESTATE:GetCurrentSteps(player) then
		StepsData[player] = GAMESTATE:GetCurrentSteps(player):GetTimingData()
	end
end

-- Now that we've done this, let's check.
-- If there's only one player, we don't need to do this check, and can just display the 1 BPM version.
if GAMESTATE:GetNumPlayersEnabled() == 2 and (StepsData[PLAYER_1] == StepsData[PLAYER_2] )then
	BPMDisplay[#BPMDisplay+1] = SingleBPMActor()
elseif GAMESTATE:GetNumPlayersEnabled() == 1 then
	BPMDisplay[#BPMDisplay+1] = SingleBPMActor()
else
	TimingDiverged = true
	BPMDisplay[#BPMDisplay+1] = DoubleBPMActor()
end

local Special = Def.ActorFrame{}
local EnvCh = {"Rain","Blizzard","Frost","Santa"}
for v in ivalues(EnvCh) do
	if GAMESTATE:Env()[v] then
		Special[#Special+1] = loadfile( THEME:GetPathB("ScreenGameplay","Overlay/"..v) )()
	end
end

local Demo = Def.ActorFrame{
	Condition=GAMESTATE:IsDemonstration(),
	Def.Sprite{ Texture="demonstration gradient", OnCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0)
	:diffusealpha(0.8) end },
	Def.Sprite{ Texture="demonstration logo", OnCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-184):pulse():effectmagnitude(1,.9,0):effectclock("bgm"):effectperiod(1) end },
}

return Def.ActorFrame{
	OnCommand=function(s)
		if GAMESTATE:Env()["Vibrate"] then
			if SCREENMAN:GetTopScreen() then
				for v in pairs( SCREENMAN:GetTopScreen():GetChildren() ) do
					if SCREENMAN:GetTopScreen():GetChild(v) then
						SCREENMAN:GetTopScreen():GetChild(v):vibrate():effectmagnitude(2,2,2)
					end
				end
			end
		end
	end,
	ProgressBar,
	BPMDisplay,
	Score,
	--loadfile( THEME:GetPathB("ScreenGameplay","overlay/stepCollector.lua") )(),
	LoadActor("../TotalPlaytime.lua", true)..{ Condition=not GAMESTATE:IsDemonstration() },
	Def.Quad{
		InitCommand=function(s) s:diffuse(0,0,0,1) end;
		OnCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0):linear(0.3):diffusealpha(0) end,
	},
	CurrentStage,
	Special,
	Demo,
	LoadActor("../_song credit display")..{ Condition=GAMESTATE:IsDemonstration() };
	loadfile( THEME:GetPathB("ScreenAttract","overlay.lua") )()..{ Condition=GAMESTATE:IsDemonstration() },
}