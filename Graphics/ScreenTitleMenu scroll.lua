local t = Def.ActorFrame{}
local gc = Var "GameCommand"

local maximum = 0
local originalwidth = 0
t[#t+1] = Def.BitmapText{
	Font="journey/40/_journey 40",
	Text=Screen.String(gc:GetText()),
	InitCommand=function(self)
		self:zoom(0.75)
		originalwidth = self:GetZoomedWidth()
		maximum = LoadModule("Lua.Resize.lua")( self:GetZoomedWidth(), self:GetZoomedHeight(), 120, 80 )
	end,
	OnCommand=function(self)
		self:diffusealpha(0):linear(0.35):diffusealpha(1)
	end,
	LoseFocusCommand=function(self)
		self:stoptweening():tween(0.2,"easeoutcircle"):y(0):zoom(0.5):diffuse( color("#777777") )
	end,
	GainFocusCommand=function(self)
		local maxzoom = originalwidth > 120 and maximum or 0.75
		local maxy = maxzoom * 2
		self:stoptweening():tween(0.2,"easeoutcircle"):y( -maxy ):zoom( maxzoom ):diffuse( Color.White )
	end
}

return t