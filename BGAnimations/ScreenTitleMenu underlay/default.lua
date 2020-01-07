return Def.ActorFrame{
    Def.Sprite{
    Texture="HomeFrame",
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+130)
        :diffusealpha(0):linear(0.3):diffusealpha(0.8)
        :zoomx(1.1)
        setenv( "ToGame", false )
    end,
}
}
