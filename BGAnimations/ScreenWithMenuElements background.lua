return Def.Sprite{
	Texture=THEME:GetPathB("ScreenLogo","background/BGVid.avi"),
    OnCommand=function(s)
        local gnZoomRatio = (SCREEN_WIDTH/640)
		s:diffusealpha(0.5):blend("BlendMode_Add"):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom(1.1*gnZoomRatio)
	end,
}