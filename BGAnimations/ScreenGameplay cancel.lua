return Def.ActorFrame{
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

	Def.BitmapText{
		Font="journey/40/_journey 40",
		Text=THEME:GetString("Common","Loading..."),
		OnCommand=function(self)
			self:zoom( LoadModule("Lua.Resize.lua")( self:GetZoomedWidth(), self:GetZoomedHeight(), SCREEN_WIDTH*0.6, SCREEN_HEIGHT*0.6 ) )
			:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+65):diffusealpha(0):sleep(0.3):linear(0.2):diffusealpha(1)
		end
	},

	Def.Sound{
		IsAction = true,
		File = THEME:GetPathS("gnScreenTransition whoosh", "short"),
		StartTransitioningCommand = function(self)
			self:play()
		end
	},

	Def.Sprite{
		Texture=THEME:GetPathG("","TransitionArrow"),
		OnCommand=function(self)
			self:xy(SCREEN_RIGHT+200,SCREEN_CENTER_Y):rotationz(-90):decelerate(0.2):x( SCREEN_CENTER_X )
			:tween(0.25,"easeinoutquint"):rotationz(0)
		end
	}
}