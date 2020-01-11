local t = Def.ActorFrame{}

t[#t+1] = Def.Quad{
    OnCommand=function(s) s:stretchto(SCREEN_WIDTH*1.2,SCREEN_HEIGHT,0,0):diffuse( Alpha(Color.Black,1) ):cropleft(1):fadeleft(0) end,
    StartTransitioningCommand=function(s) s:fadeleft(0.1):linear(0.1):cropleft(0) end,
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","TransitionArrow"),
    OnCommand=function(s)
        s:visible(false)
    end,
    StartTransitioningCommand=function(s)
        s:visible(true):xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100):decelerate(0.2):y( SCREEN_CENTER_Y ):sleep(0.3)
        SOUND:PlayOnce( THEME:GetPathS("gnScreenTransition whoosh", "short") )
    end,
}

return t;