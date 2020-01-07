local t = Def.ActorFrame{}

local pos = { SCREEN_BOTTOM-36, SCREEN_TOP+40 }

for var in ivalues(pos) do
	t[#t+1] = Def.Sprite{
		Texture="streak",
		OnCommand=function(s)
			s:xy( SCREEN_CENTER_X, var ):zoomtowidth(SCREEN_WIDTH):cropleft(-0.2):cropright(-0.2)
		end,
	}
end

t[#t+1] = Def.BitmapText{
	Font="_eurostile blue glow",
	Text=string.upper(Screen.String("HeaderText")),
	OnCommand=function(s) s:xy( s:GetWidth()/2+20, 41 ) end,
}

return t;