local t = Def.ActorFrame{}

t[#t+1] = Def.Quad{
    OnCommand=function(s) s:stretchto(SCREEN_WIDTH*1.2,SCREEN_HEIGHT,0,0):diffuse( Alpha(Color.Black,1) ):cropleft(1):fadeleft(0) end,
    ShowPressStartForOptionsCommand=function(s) s:fadeleft(0.1):linear(0.1):cropleft(0) end,
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenSelectMusic","Options Message"),
    InitCommand=function(self)
        self:Center():pause():diffusealpha(0)
    end;
    ShowPressStartForOptionsCommand=function(self)
        self:diffusealpha(1):faderight(.3):fadeleft(.3):cropleft(-0.3):cropright(1.3):linear(0.3):cropright(-0.3):sleep(1.2):linear(0.3):cropleft(1.3)
    end;
    ShowEnteringOptionsCommand=function(self)
        self:stoptweening():setstate(1):cropright(0):sleep(0.6):linear(0.3):cropleft(1.3)
    end;
    HidePressStartForOptionsCommandCommand=function(self)
        self:linear(0.3):cropleft(1.3)
    end;
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","TransitionArrow"),
    OnCommand=function(s)
        s:visible(false)
    end,
    ShowPressStartForOptionsCommand=function(s)
        s:visible(true):xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100):decelerate(0.2):y( SCREEN_CENTER_Y )
        :vibrate():effectmagnitude(1,1,0):sleep(0.3)
        SOUND:PlayOnce( THEME:GetPathS("gnScreenTransition whoosh", "short") )
    end,
}

return t;