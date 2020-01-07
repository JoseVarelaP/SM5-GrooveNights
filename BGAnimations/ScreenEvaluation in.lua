return Def.Quad{
    OnCommand=function(s) s:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0)
        :diffuse(Color.Black):linear(0.4):diffusealpha(0)
    end
}