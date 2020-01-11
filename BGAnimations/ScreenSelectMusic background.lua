local t = Def.ActorFrame{}

t[#t+1] = Def.ActorFrame{
    OnCommand=function(s) s:fov(105):zoom(1.3) end,
    Def.Sprite{
        Texture=THEME:GetPathB("ScreenLogo","background/BGVid.avi"),
        OnCommand=function(s)
            local gnZoomRatio = (SCREEN_WIDTH/640)
            s:diffusealpha(1):diffuse( color("#1C2C3C") ):blend("BlendMode_Add"):zoom(1.1*gnZoomRatio)
        end,
    }
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenSelectMusic divider","B"),
    InitCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):MaskSource()
    end,
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenSelectMusic divider","B"),
    InitCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):diffuse( color("#060A0E") )
    end,
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenSelectMusic wheel","under"),
    InitCommand=function(s)
        s:xy(SCREEN_CENTER_X-5,SCREEN_CENTER_Y):MaskSource()
    end,
}

return t;