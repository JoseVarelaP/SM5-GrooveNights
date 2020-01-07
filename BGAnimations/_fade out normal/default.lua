--[[
[BGAnimation]
LengthSeconds=0.02

[Layer1]
File=../_black
Type=1		// 0=sprite, 1=stretch, 2=particles, 3=tiles
Command=diffusealpha,0;linear,0.02;diffusealpha,1
]]

return Def.Quad{
    OnCommand=function(s)
        s:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0):diffuse(Color.Black):diffusealpha(0):linear(0.02)
        :diffusealpha(1):sleep(0.3)
    end,
}