return Def.ActorFrame{
	Def.Quad{
		OnCommand=function(s) s:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,SCREEN_HEIGHT):diffuse(Color.
		Black):addy( SCREEN_HEIGHT/2 ):decelerate(0.2):addy( -SCREEN_HEIGHT/2 )
		end
	},
	Def.Quad{
		OnCommand=function(s) s:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,0):diffuse(Color.Black):addy( -SCREEN_HEIGHT/2 )
			:decelerate(0.2):addy( SCREEN_HEIGHT/2 )
		end
	},

	Def.Sprite{
		Texture=THEME:GetPathG("","TransitionArrow"),
		OnCommand=function(s)
			s:xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100):decelerate(0.2):y( SCREEN_CENTER_Y )
			:vibrate():effectmagnitude(1,1,0):sleep(0.3)
		end,
		StartTransitioningCommand=function(s)
			SOUND:PlayOnce( THEME:GetPathS("gnScreenTransition whoosh", "short") )
		end,
	},

	Def.BitmapText{
		Font="journey/40/_journey 40",
		Text=THEME:GetString("Common","Loading..."),
		OnCommand=function(s)
			s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+65)
			s:zoom( LoadModule("Lua.Resize.lua")( s:GetZoomedWidth(), s:GetZoomedHeight(), SCREEN_WIDTH*0.6, SCREEN_HEIGHT*0.6 ) )
			:diffusealpha(0):sleep(0.2):linear(0.2):diffusealpha(1)
		end
	}
}