local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathB("ScreenLogo","background/BGVid.avi"),
    OnCommand=function(s)
        local gnZoomRatio = (SCREEN_WIDTH/640)
		s:diffusealpha(0.5):blend("BlendMode_Add"):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom(1.1*gnZoomRatio)
	end,
}

t[#t+1] = Def.Quad{
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
        s:stretchto( SCREEN_WIDTH, SCREEN_HEIGHT-30, 0, 30 )
        s:diffuse(Color.Black)
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenSelectMusic wheel","under"),
    InitCommand=function(s)
        s:xy(SCREEN_CENTER_X-5,SCREEN_CENTER_Y):MaskSource()
    end,
}

return t;