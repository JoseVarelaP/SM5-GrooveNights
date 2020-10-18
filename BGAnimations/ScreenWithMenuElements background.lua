return Def.Sprite{
	Texture=THEME:GetPathB("ScreenLogo","background/BGVid.mkv"),
    OnCommand=function(s)
        local gnZoomRatio = (SCREEN_WIDTH/640)
		s:diffusealpha(0.5):blend("BlendMode_Add"):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom(1.1*gnZoomRatio)
		s:diffuse( color("#1C2C3C") )
	end,
}