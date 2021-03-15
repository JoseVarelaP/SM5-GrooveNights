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

	Def.ActorFrame{
		OnCommand=function(self)
			self:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y+78 )
	
			local textwidth = self:GetChild("MainText"):GetZoomedWidth()
	
			self:zoom( LoadModule("Lua.Resize.lua")( textwidth, self:GetChild("MainText"):GetZoomedHeight(), SCREEN_WIDTH*0.6, SCREEN_HEIGHT*0.6 ) )
			self:visible( not GAMESTATE:Env()["gnAlreadyAtMenu"] ):linear(0.1):diffusealpha(0)

			if not GAMESTATE:Env()["gnAlreadyAtMenu"] then
				GAMESTATE:Env()["gnAlreadyAtMenu"] = true
			end
		end,
		Def.BitmapText{
			Font="journey/40/_journey 40",
			Name="MainText",
			Text=THEME:GetString("ScreenSelectMusic","EnteringOptions"),
			OnCommand=function(self) self:strokecolor(Color.Black):zoom(1.4) end,
		}
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