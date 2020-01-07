-- Gameplay Bar
local ProgressBar = Def.ActorFrame{
    OnCommand=function(s)
        s:xy( SCREEN_CENTER_X, 24 )
    end,
    Def.Sprite{ Texture="meter measure", OnCommand=function(s) s:zoomtowidth( WideScale(440, 424+154) ) end, },
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
			s:settext( song and song:GetDisplayFullTitle() or "" )
		end
    }
}

local CurrentStage = Def.Sprite{
    Texture=THEME:GetPathG( "Stages/ScreenGameplay","stage ".. ToEnumShortString(GAMESTATE:GetCurrentStage()) ),
    OnCommand=function(self)
        if GAMESTATE:GetCurrentStage() == "Stage_Final" then
            self:Load( THEME:GetPathG("Stages/ScreenGameplay stage","final") )
        end
        self:Center():draworder(105):zoom(1):sleep(1.2):linear(0.3):zoom(0.25):y(SCREEN_BOTTOM-40)
    end;
}

local Score = Def.ActorFrame{}

for player in ivalues( GAMESTATE:GetEnabledPlayers() ) do
    local pn_to_color_name= {[PLAYER_1]= "PLAYER_1", [PLAYER_2]= "PLAYER_2"}
    local color = GameColor.PlayerColors[pn_to_color_name[player]]

    Score[#Score+1] = Def.BitmapText{
        Condition=GAMESTATE:IsPlayerEnabled(player) and (GAMESTATE:GetPlayMode() ~= "PlayMode_Rave" and GAMESTATE:GetPlayMode() ~= "PlayMode_Oni");
        Font="_futurist metalic";
        Text=" 0.00%";
        OnCommand=function(s)
            s:xy( player == PLAYER_1 and SCREEN_CENTER_X-180 or SCREEN_CENTER_X+180, SCREEN_TOP+56 )
            -- :visible( Settings.CurrentScreen ~= "ScreenGameplaySyncMachine" )
            :diffuse( color )
        end;
        JudgmentMessageCommand=function(s) s:queuecommand("UpdateScore") end;
        UpdateScoreCommand=function(s)
            s:settext( LoadModule("Gameplay.CalculatePercentage.lua")(player) )
            -- time to check who's winning
            if GAMESTATE:GetNumPlayersEnabled() == 2 then
                if LoadModule("Gameplay.RealTimeWinnerCalculation.lua")(player) < LoadModule("Gameplay.RealTimeWinnerCalculation.lua")(player == PLAYER_1 and 1 or 0) then
                    s:diffusealpha(0.8)
                else
                    s:diffusealpha(1)
                end
            end
        end;
    };

    Score[#Score+1] = Def.Sprite{
        Condition=GAMESTATE:IsPlayerEnabled(player) and GAMESTATE:GetNumPlayersEnabled() == 2,
        Texture="winning.png",
        OnCommand=function(s)
            local margin = 40
            s:xy( player == PLAYER_1 and margin or SCREEN_RIGHT-margin, SCREEN_CENTER_Y-110 )
            :zoom(0.6):rotationz( player == PLAYER_1 and 30 or -30 )
        end;
        JudgmentMessageCommand=function(s) s:queuecommand("UpdateScore") end;
        UpdateScoreCommand=function(s)
            -- time to check who's winning
            if GAMESTATE:GetNumPlayersEnabled() == 2 then
                if LoadModule("Gameplay.RealTimeWinnerCalculation.lua")(player) < LoadModule("Gameplay.RealTimeWinnerCalculation.lua")(player == PLAYER_1 and 1 or 0) then
                    s:diffusealpha(0)
                else
                    s:diffusealpha(1)
                end
            end
        end;
    };

    Score[#Score+1] = Def.ActorFrame{
        OnCommand=function(s)
            local margin = 56
            s:xy( player == PLAYER_1 and margin or SCREEN_RIGHT-margin, 25 )
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
            Font="_eurostile normal",
            OnCommand=function(s) s:zoom(0.6):xy( player == PLAYER_1 and -12 or 12, -1 ) end,
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
            Font="_eurostile normal",
            OnCommand=function(s)
                s:zoom(0.6):xy(player == PLAYER_1 and 33 or -32,-1):playcommand("Update")
            end;
            ["CurrentSteps".. ToEnumShortString(player) .."ChangedMessageCommand"]=function(s)
                s:playcommand("Update")
            end;
            UpdateCommand=function(s)
                if GAMESTATE:GetCurrentSteps(player) then
                    local steps = GAMESTATE:GetCurrentSteps(player)
                    s:settext( steps:GetMeter() )
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
        for player in ivalues( GAMESTATE:GetEnabledPlayers() ) do
            local dispP1 = self:GetChild("DisplayP1")
            local dispP2 = self:GetChild("DisplayP2")
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

local BPMDisplay = Def.ActorFrame{}

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
    if GAMESTATE:IsPlayerEnabled(player) then
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

return Def.ActorFrame{
    ProgressBar,
    BPMDisplay,
    Score,
    Def.Quad{
        InitCommand=function(s) s:diffuse(0,0,0,1) end;
        OnCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0):linear(0.3):diffusealpha(0) end,
    },
    LoadActor("../_song credit display")..{
        OnCommand=function(s)
            s:diffusealpha(1):sleep(2):linear(0.2):diffusealpha(0)
        end;
    };
    CurrentStage,
}