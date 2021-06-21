local t = Def.ActorFrame{}

t[#t+1] = Def.Quad{
	OnCommand=function(self) self:stretchto(SCREEN_WIDTH*1.2,SCREEN_HEIGHT,0,0):diffuse( Alpha(Color.Black,1) ):cropleft(1):fadeleft(0) end,
	StartTransitioningCommand=function(self) self:fadeleft(0.1):linear(0.1):cropleft(0) end,
}

return t