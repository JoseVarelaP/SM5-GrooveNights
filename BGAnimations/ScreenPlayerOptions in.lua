return Def.ActorFrame{
    Def.Quad{
        OnCommand=function(s) s:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,SCREEN_HEIGHT):diffuse(Color.
        Black)
            :decelerate(0.2):addy( SCREEN_HEIGHT/2 )
        end
    },
    Def.Quad{
        OnCommand=function(s) s:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,0):diffuse(Color.Black)
            :decelerate(0.2):addy( -SCREEN_HEIGHT/2 )
        end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("","TransitionArrow"),
        OnCommand=function(s)
            s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):accelerate(0.2):addy( -SCREEN_HEIGHT/1.6 )
            SOUND:PlayOnce( THEME:GetPathS("gnScreenTransition whoosh", "in") )
        end,
    },

	Def.BitmapText{
		Font="journey/40/_journey 40",
		Text=THEME:GetString("ScreenSelectMusic","EnteringOptions"),
		OnCommand=function(self)
			self:visible( not GAMESTATE:Env()["gnAlreadyAtMenu"] )
			self:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y+78 ):strokecolor(Color.Black):zoom(1.4)
			:linear(0.1):diffusealpha(0)

			if not GAMESTATE:Env()["gnAlreadyAtMenu"] then
				GAMESTATE:Env()["gnAlreadyAtMenu"] = true
			end
		end,
	}
	--[[
	Def.Sprite{
        Texture=THEME:GetPathG("ScreenSelectMusic","Options Message"),
        OnCommand=function(self)
            self:Center():pause():setstate(1)
            :linear(0.1):diffusealpha(0)
        end;
    }
	]]
}