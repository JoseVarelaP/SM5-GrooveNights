local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathG("options","page"),
	OnCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+10):diffuse( color("#060A0E") ) end
}


t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathB("ScreenPlayerOptions underlay/ScreenOptions","frame"),
	OnCommand=function(self)
		self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+10):diffuse( color("#1C2C3C") )
	end
}

return t