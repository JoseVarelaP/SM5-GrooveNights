return Def.ActorFrame{
	Def.Quad{
		OnCommand=function(self)
			self:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,SCREEN_HEIGHT):diffuse(Color.Black)
			:decelerate(0.2):addy( SCREEN_HEIGHT/2 )
		end
	},
	Def.Quad{
		OnCommand=function(self)
			self:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,0):diffuse(Color.Black)
			:decelerate(0.2):addy( -SCREEN_HEIGHT/2 )
		end
	},

	Def.Sound{
		IsAction = true,
		File = THEME:GetPathS("gnScreenTransition whoosh", "in"),
		OnCommand = function(self)
			self:play()
		end
	},

	Def.Sprite{
		Texture=THEME:GetPathG("","TransitionArrow"),
		OnCommand=function(s)
			s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):accelerate(0.2):addy( -SCREEN_HEIGHT/1.6 )
		end,
	}
}