local t = Def.ActorFrame{
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom( (SCREEN_WIDTH/640) )
        s:sleep(1):queuecommand("Start")
    end,
    StartCommand=function(s)
        for player in ivalues( GAMESTATE:GetHumanPlayers() ) do
            if GAMESTATE:IsHumanPlayer(player) then
                if SCREENMAN:GetTopScreen() then
                    SCREENMAN:GetTopScreen():GetChild("Player"..ToEnumShortString(player)):bounce():effectmagnitude(-20,20,0):effectclock("bgm")
                    :effectperiod(0.2)
                    local ps= GAMESTATE:GetPlayerState(player)
	                ps:SetPlayerOptions('ModsLevel_Song', ps:GetPlayerOptionsString('ModsLevel_Song') .. ', 50% Drunk, 150% Bumpy,*20 70% dark')
                end
            end
        end
    end,

    Def.Sprite{
        Texture="easter_eggs/blurredsnow.png",
        OnCommand=function(s) s:align(0,0)
            s:customtexturerect(0,0,1.5,1.5)
            :texcoordvelocity(2.40,-1.90):stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0):diffusealpha(0):linear(1):diffusealpha(0)
            :bob()
        end,
    },

    Def.Sprite{
        Texture="easter_eggs/blurredsnow.png",
        OnCommand=function(s) s:align(0,0)
            s:customtexturerect(0,0,1,1)
            :texcoordvelocity(1.40,-0.90):stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0):diffusealpha(0):linear(1):diffusealpha(0)
            :bob()
        end,
    },

    Def.Quad{
        OnCommand=function(s) s:align(0,0)
            s:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0):sleep(1):linear(2):diffusealpha(0.2)
        end,
    },

    -- SNOW
    Def.Sprite{
        Texture="easter_eggs/blurredsnow.png",
        OnCommand=function(s) s:align(0,0)
            s:customtexturerect(0,0,1,1)
            :texcoordvelocity(1.4,-0.90):stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0):diffusealpha(0):linear(1):diffusealpha(1)
        end,
    },

    Def.Sprite{
        Texture="easter_eggs/blurredsnowFar.png",
        OnCommand=function(s) s:align(0,0)
            s:customtexturerect(0,0,1,1)
            :texcoordvelocity(1.2,-0.90):stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0):diffusealpha(0):linear(1):diffusealpha(1)
        end,
    },

    Def.Sprite{
        Texture="easter_eggs/blurredsnowNear.png",
        OnCommand=function(s) s:align(0,0)
            s:customtexturerect(0,0,1,1)
            :texcoordvelocity(1,-0.90):stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0):diffusealpha(0):linear(1):diffusealpha(1)
        end,
    },
}

return t;