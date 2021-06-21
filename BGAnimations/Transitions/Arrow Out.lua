return Def.ActorFrame{
	Def.Quad{
		OnCommand=function(self)
			self:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,SCREEN_HEIGHT):diffuse(Color.Black)
			:addy( SCREEN_HEIGHT/2 ):decelerate(0.2):addy( -SCREEN_HEIGHT/2 )
		end
	},
	Def.Quad{
		OnCommand=function(self)
			self:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,0):diffuse(Color.Black)
			:addy( -SCREEN_HEIGHT/2 ):decelerate(0.2):addy( SCREEN_HEIGHT/2 )
		end
	},

	Def.Sprite{
		Texture=THEME:GetPathG("","TransitionArrow"),
		OnCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100):decelerate(0.2):y( SCREEN_CENTER_Y )
			:vibrate():effectmagnitude(1,1,0):sleep(0.3)
		end,
		StartTransitioningCommand=function(self)
			SOUND:PlayOnce( THEME:GetPathS("gnScreenTransition whoosh", "short") )
		end
	}
}