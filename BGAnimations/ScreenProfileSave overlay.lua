return Def.ActorFrame{
	BeginCommand=function(s)
		if SCREENMAN:GetTopScreen():HaveProfileToSave() then
			for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
				if PROFILEMAN:IsPersistentProfile(pn) then
					PROFILEMAN:SaveProfile( pn )
				end
			end
		end
		s:queuecommand("Load")
	end,

	Def.Quad{
		OnCommand=function(s) s:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0):diffuse(Color.Black) end
	},

	Def.Sprite{
		Texture=THEME:GetPathG("","TransitionArrow"),
		OnCommand=function(s)
			s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):vibrate():effectmagnitude(1,1,0)
		end
	},

	Def.BitmapText{
		Font="journey/40/_journey 40",
		Text=Screen.String("Saving"),
		OnCommand=function(s)
			s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+65)
			s:zoom( LoadModule("Lua.Resize.lua")( s:GetZoomedWidth(), s:GetZoomedHeight(), SCREEN_WIDTH*0.6, SCREEN_HEIGHT*0.6 ) )
		end,
		LoadCommand=function(s)
			SCREENMAN:GetTopScreen():Continue()
			s:linear(0.2):diffusealpha(0)
		end
	},

	Def.BitmapText{
		Font="journey/40/_journey 40",
		Text=THEME:GetString("Common","Loading..."),
		OnCommand=function(s)
			s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+65)
			s:zoom( LoadModule("Lua.Resize.lua")( s:GetZoomedWidth(), s:GetZoomedHeight(), SCREEN_WIDTH*0.6, SCREEN_HEIGHT*0.6 ) )
			:diffusealpha(0)
		end,
		LoadCommand=function(s)
			if SOUND.Volume then
				SOUND:Volume(0,0.6)
			end
			s:sleep(0.2):linear(0.2):diffusealpha(1)
		end
	}
}