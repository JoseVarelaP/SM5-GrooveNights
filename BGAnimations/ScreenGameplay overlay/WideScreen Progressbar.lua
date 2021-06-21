local t = Def.ActorFrame{}

local meterbar = { {0.5,0,SCREEN_WIDTH/11.5},{0,0.5,SCREEN_WIDTH/-11.5},{0.326,0.326,0} }
for v in ivalues(meterbar) do
	t[#t+1] = Def.Sprite{
		Texture="meter frame",
		OnCommand=function(self)
			self:zoomtowidth(SCREEN_WIDTH/2):cropright(v[2]):cropleft(v[1]):x(v[3]):diffuse( color("#1C2C3C") )
		end
	}
end

return t