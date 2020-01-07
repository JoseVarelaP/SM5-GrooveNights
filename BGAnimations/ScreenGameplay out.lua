return Def.Quad{
    OnCommand=function(s) s:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0)
        :diffuse(Color.Black):diffusealpha(0):sleep(2):linear(0.4):diffusealpha(1)
    end
}