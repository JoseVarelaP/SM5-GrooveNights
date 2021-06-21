return Def.ActorFrame{
	loadfile( THEME:GetPathB("Transitions/Arrow","In") )(),
	Def.BitmapText{
		Font="journey/40/_journey 40",
		Text=THEME:GetString("Common","Loading..."),
		OnCommand=function(s)
			s:zoom( LoadModule("Lua.Resize.lua")( s:GetZoomedWidth(), s:GetZoomedHeight(), SCREEN_WIDTH*0.6, SCREEN_HEIGHT*0.6 ) )
			s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+65):strokecolor(Color.Black):accelerate(0.2):diffusealpha(0)
		end,
	},
}