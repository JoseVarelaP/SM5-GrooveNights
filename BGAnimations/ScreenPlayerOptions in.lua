return Def.ActorFrame{
	loadfile( THEME:GetPathB("Transitions/Arrow","In") )(),

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
			OnCommand=function(self) self:strokecolor(Color.Black):zoom(1.4) end
		}
	}
}