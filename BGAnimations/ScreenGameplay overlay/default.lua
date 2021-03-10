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
        Font="_eurostile normal",
        OnCommand=function(s) s:zoom(0.6):maxwidth( SCREEN_WIDTH/1.02 ) end,
        InitCommand=function(s) s:shadowlength(0):playcommand("Update") end,
        CurrentSongChangedMessageCommand=function(s) s:playcommand("Update") end,
		UpdateCommand=function(s)
			local song = GAMESTATE:GetCurrentSong()
			s:settext( song and ( GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse():GetDisplayFullTitle().." - "..song:GetDisplayFullTitle() or song:GetDisplayFullTitle()) or "" )
		end
    }
}

local IsEvent = GAMESTATE:IsEventMode()
local CourseIndx = 1
local StageStart = GAMESTATE:IsCourseMode() and "course song "..CourseIndx or "stage ".. ToEnumShortString(GAMESTATE:GetCurrentStage())
local CurrentStage = Def.Sprite{
    Texture=THEME:GetPathG( "Stages/ScreenGameplay",StageStart ),
    BeforeLoadingNextCourseSongMessageCommand=function(s)
        CourseIndx = CourseIndx + 1
        s:Load( THEME:GetPathG("Stages/ScreenGameplay course song",CourseIndx) )
        :finishtweening():linear(0.3):Center():zoom(1):sleep(0.5)
        :zoom( (IsEvent and not GAMESTATE:IsCourseMode()) and 0.25 or 0.4 ):y(SCREEN_BOTTOM-40)
    end,
    OnCommand=function(self)
        if GAMESTATE:GetCurrentStage() == "Stage_Final" then
            self:Load( THEME:GetPathG("Stages/ScreenGameplay stage","final") )
        end
        self:Center():draworder(105):zoom(1):linear(0.3):zoom( (IsEvent and not GAMESTATE:IsCourseMode()) and 0.25 or 0.4)
        :y( LoadModule("Config.Load.lua")("ToggleSystemClock","Save/GrooveNightsPrefs.ini") and ( IsEvent and SCREEN_BOTTOM-58 or SCREEN_BOTTOM-66) or SCREEN_BOTTOM-40)
    end;
}

local Score = Def.ActorFrame{}
local pn_to_color_name= {[PLAYER_1]= "PLAYER_1", [PLAYER_2]= "PLAYER_2"}

local scoreModes = {
    -- Method 1: Normal Scoring
    function( GPSS , ScoreToCalculate )
        return ScoreToCalculate > 0 and string.format( "%.2f%%", ScoreToCalculate*100) or " 0.00%"
    end,
    -- Method 2: Reverse Scoring
    function( GPSS , ScoreToCalculate )
        local reverseScore = GPSS:GetCurrentPossibleDancePoints() - GPSS:GetActualDancePoints()
        reverseScore = (( GPSS:GetPossibleDancePoints() - reverseScore ) / GPSS:GetPossibleDancePoints())
        return ScoreToCalculate > 0 and FormatPercentScore( reverseScore ) or "100.00%"
    end,
    -- Method 3: Real Time Scoring
    function( GPSS , ScoreToCalculate )
        local realTimeScore = GPSS:GetActualDancePoints() / GPSS:GetCurrentPossibleDancePoints()
        return realTimeScore > 0 and FormatPercentScore(realTimeScore) or " 0.00%" 
    end,
    -- Method 4: Flat Scoring
    function( GPSS , ScoreToCalculate, totalNotes )
        local notesHit = 0
        for i=1,5 do
            notesHit = notesHit + GPSS:GetTapNoteScores( "TapNoteScore_W"..i )
        end
        return notesHit > 0 and FormatPercentScore( notesHit / totalNotes ) or " 0.00%"
    end,
}

for player in ivalues( GAMESTATE:GetEnabledPlayers() ) do
    local color = GameColor.PlayerColors[pn_to_color_name[player]]
	local PDir = (PROFILEMAN:GetProfile(player):GetDisplayName() ~= "" and MEMCARDMAN:GetCardState(player) == 'MemoryCardState_none') and PROFILEMAN:GetProfileDir(string.sub(player,-1)-1).."GrooveNightsPrefs.ini" or "Save/TEMP"..player
    local isRealProf = LoadModule("Profile.IsMachine.lua")(player)
    local totalNotes = LoadModule("Pane.RadarValue.lua")(player,6)
    local config = LoadModule("Config.gnLoad.lua")(player, "ScoringFormat")[1] or 0
    Score[#Score+1] = Def.BitmapText{
        Condition=GAMESTATE:IsPlayerEnabled(player) and GAMESTATE:GetPlayMode() ~= "PlayMode_Oni";
        Font="_futurist metalic";
        OnCommand=function(s)
            s:xy( player == PLAYER_1 and SCREEN_CENTER_X-180 or SCREEN_CENTER_X+180, SCREEN_TOP+56 )
            :diffuse( color ):playcommand("UpdateScore")
        end;
        JudgmentMessageCommand=function(s) s:queuecommand("UpdateScore") end;
        UpdateScoreCommand=function(s)
            local GPSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
            local ScoreToCalculate = GPSS:GetPercentDancePoints()
            s:settext( scoreModes[config+1]( GPSS, ScoreToCalculate, totalNotes ) )
        end;
    };

    -- Dedicated true score percentage.
    -- Only applicable on Flat Scoring
    if tonumber(config) == 3 then
        Score[#Score+1] = Def.BitmapText{
            Condition=GAMESTATE:IsPlayerEnabled(player) and GAMESTATE:GetPlayMode() ~= "PlayMode_Oni",
            Font="_futurist metalic",
            OnCommand=function(s)
                s:xy( player == PLAYER_1 and SCREEN_CENTER_X-156 or SCREEN_CENTER_X+156, SCREEN_TOP+76 ):zoom(0.6)
                :diffuse( color ):playcommand("UpdateScore")
            end,
            JudgmentMessageCommand=function(s) s:queuecommand("UpdateScore") end,
            UpdateScoreCommand=function(s)
                local GPSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)
                local ScoreToCalculate = GPSS:GetPercentDancePoints()
                s:settext( scoreModes[1]( GPSS, ScoreToCalculate, totalNotes ) )
                -- time to check who's winning
                if GAMESTATE:GetNumPlayersEnabled() == 2 then
                    if LoadModule("Gameplay.RealTimeWinnerCalculation.lua")(player) < LoadModule("Gameplay.RealTimeWinnerCalculation.lua")(player == PLAYER_1 and 1 or 0) then
                        s:diffusealpha(0.8)
                    else
                        s:diffusealpha(1)
                    end
                end
            end
        }
    end

    if GAMESTATE:GetNumPlayersEnabled() == 2 then
        Score[#Score+1] = Def.Sprite{
            Condition=GAMESTATE:IsPlayerEnabled(player),
            Texture="winning.png",
            OnCommand=function(s)
                local margin = 40
                s:xy( player == PLAYER_1 and margin or SCREEN_RIGHT-margin, SCREEN_CENTER_Y-110 )
                :zoom(0.6):rotationz( player == PLAYER_1 and 30 or -30 )
            end,
            JudgmentMessageCommand=function(s) s:queuecommand("UpdateScore") end,
            UpdateScoreCommand=function(s)
                -- time to check who's winning
                if LoadModule("Gameplay.RealTimeWinnerCalculation.lua")(player) < LoadModule("Gameplay.RealTimeWinnerCalculation.lua")(player == PLAYER_1 and 1 or 0) then
                    s:diffusealpha(0)
                else
                    s:diffusealpha(1)
                end
            end
        }
    end

    Score[#Score+1] = Def.ActorFrame{
        OnCommand=function(s)
            s:xy( player == PLAYER_1 and 56 or SCREEN_RIGHT-56, 25 )
        end,
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
            OnCommand=function(s) s:zoom(0.6):xy( player == PLAYER_1 and -12 or 12, -1 ):strokecolor(Color.Black) end,
            ["CurrentSteps".. ToEnumShortString(player) .."ChangedMessageCommand"]=function(s)
                s:playcommand("Update")
            end;
            UpdateCommand=function(s)
                if GAMESTATE:GetCurrentSteps(player) then
                    local steps = GAMESTATE:GetCurrentSteps(player):GetDifficulty();
                    s:settext( LoadModule("Gameplay.DifficultyName.lua")("Steps", player) ):maxwidth(100)
                end
            end,
        },

        Def.BitmapText{
            Font="novamono/36/_novamono 36",
            OnCommand=function(s)
                s:zoom(0.6):xy(player == PLAYER_1 and 33 or -32,-1):strokecolor(Color.Black):playcommand("Update")
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
        OnCommand=function(s) s:xy( SCREEN_CENTER_X,60 ):SetUpdateFunction(Update2PBPM) end,
        Def.BitmapText{ Name="DisplayP1", Font="_eurostile normal", OnCommand=function(s) s:x( -30 ) end, },
        Def.BitmapText{ Name="DisplayP2", Font="_eurostile normal", OnCommand=function(s) s:x( 30 ) end, },
    }
end

local function SingleBPMActor()
    return Def.ActorFrame{
        OnCommand=function(s) s:xy( SCREEN_CENTER_X,60 ):SetUpdateFunction(Update2PBPM) end,
        Def.BitmapText{ Name="Display", Font="_eurostile normal" },
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

local TotalPlayTime = Def.BitmapText{
    Font="_eurostile normal",
    Condition=LoadModule("Config.Load.lua")("ToggleTotalPlayTime","Save/GrooveNightsPrefs.ini") and not GAMESTATE:IsDemonstration(),
    OnCommand=function(s)
        s:xy( SCREEN_CENTER_X, SCREEN_BOTTOM-10 ):zoom(0.6):strokecolor(Color.Black)
        :playcommand("Update")
    end,
    UpdateCommand=function(s)
        local Comtp = SecondsToHHMMSS(
            STATSMAN:GetAccumPlayedStageStats(GAMESTATE:GetMasterPlayerNumber()):GetGameplaySeconds()
            +
            STATSMAN:GetCurStageStats(GAMESTATE:GetMasterPlayerNumber()):GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber()):GetAliveSeconds()
        )
        local SongsCount = " ("..STATSMAN:GetStagesPlayed().." songs)"
        s:finishtweening()
        s:settext( "Total PlayTime: ".. Comtp ..  SongsCount  )
        s:AddAttribute(0, {
            Length=string.len(s:GetText())-(string.len(Comtp)+string.len(SongsCount));
			Diffuse=color("#FFA314") }
		)
        s:sleep(1):queuecommand("Update")
    end,
}

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
    loadfile( THEME:GetPathB("ScreenGameplay","overlay/stepCollector.lua") )(),
    TotalPlayTime,
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