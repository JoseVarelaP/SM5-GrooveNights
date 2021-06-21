return Def.ActorFrame{
	loadfile( THEME:GetPathB("Transitions/Arrow","Out") )(),
	Def.BitmapText{
		Font="journey/40/_journey 40",
		Text=THEME:GetString("ScreenProfileSave","Saving"),
		OnCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+65)
			:zoom( LoadModule("Lua.Resize.lua")( self:GetZoomedWidth(), self:GetZoomedHeight(), SCREEN_WIDTH*0.6, SCREEN_HEIGHT*0.6 ) )
			:diffusealpha(0):sleep(0.2):linear(0.2):diffusealpha(1)
		end
	}
}