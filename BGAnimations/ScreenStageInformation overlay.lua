local t = Def.ActorFrame{	
	Def.Quad{ InitCommand=function(self) self:FullScreen():diffuse(Color.Black) end }
}

GAMESTATE:Env()["gnNextScreen"] = "ScreenPlayerOptions"
PREFSMAN:SetPreference( "GlobalOffsetSeconds", GAMESTATE:Env()["NewOffset"] )

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s)
		s:xy( SCREEN_CENTER_X,SCREEN_BOTTOM+50 ):zoom(3.5):sleep(0.333):tween(0.5,"easeoutback"):y( SCREEN_CENTER_Y )
	end,
	LoadActor("CurrentStage.lua")
}

t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathG("","TransitionArrow"),
	OnCommand=function(s)
		s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):accelerate(0.2):y(-60)
		SOUND:PlayOnce( THEME:GetPathS("gnScreenTransition whoosh", "long") )
	end,
}

return t