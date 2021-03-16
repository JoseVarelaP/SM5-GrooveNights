return Def.Quad{
    OnCommand=function(s)
        s:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0):diffuse(Color.Black):diffusealpha(0):linear(0.1)
        :diffusealpha(1):sleep(0.3)
    end
}