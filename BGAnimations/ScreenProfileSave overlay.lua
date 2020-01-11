return Def.ActorFrame{
    BeginCommand=function(s)
        if SCREENMAN:GetTopScreen():HaveProfileToSave() then
            s:sleep(1)
        end
        s:queuecommand("Load")
    end,

    Def.Quad{
        OnCommand=function(s) s:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0):diffuse(Color.Black) end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("","TransitionArrow"),
        OnCommand=function(s)
            s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):vibrate():effectmagnitude(1,1,0)
        end,
    },

    Def.Sprite{
        Texture=THEME:GetPathG("","_saving"),
        InitCommand=function(s)
            s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+70)
        end,
        LoadCommand=function(s)
            SCREENMAN:GetTopScreen():Continue()
            s:linear(0.2):diffusealpha(0)
        end,
    },

    Def.Sprite{
        Texture=THEME:GetPathG("","Loading"),
        InitCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+70):diffusealpha(0) end,
        LoadCommand=function(s) s:sleep(0.2):linear(0.2):diffusealpha(1) end,
    }
}