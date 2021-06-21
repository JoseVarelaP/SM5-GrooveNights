return Def.ActorFrame{
	OnCommand=function(self)
		self:hibernate(1)
	end,
	Def.Quad{
		OnCommand=function(self)
			self:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,SCREEN_HEIGHT):diffuse(Color.Black)
			:addy( SCREEN_HEIGHT/2 ):decelerate(0.2):addy( -SCREEN_HEIGHT/2 )
		end
	},
	Def.Quad{
		OnCommand=function(self)
			self:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,0):diffuse(Color.Black):addy( -SCREEN_HEIGHT/2 )
			:decelerate(0.2):addy( SCREEN_HEIGHT/2 )
		end
	},

	Def.Sprite{
		Texture=THEME:GetPathG("","TransitionArrow"),
		OnCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100):queuecommand("SFX"):decelerate(0.2):y( SCREEN_CENTER_Y )
		end,
		SFXCommand=function(self)
			SOUND:PlayOnce( THEME:GetPathS("gnScreenTransition whoosh", "in") )
		end
	}
}