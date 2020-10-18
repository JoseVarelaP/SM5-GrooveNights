local t = Def.ActorFrame{}
t[#t+1] = Def.Quad{
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):stretchto(SCREEN_WIDTH*2,SCREEN_HEIGHT*2,0,0)
        :diffuse( Alpha(color("#1C2C3C"), .2) )
    end
}

t[#t+1] = Def.Sprite{
    Texture="BGVid.mkv",
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom( 1.1*(SCREEN_WIDTH/640) )
        :diffuse( color("#1C2C3C") ):rate(0.5)
    end,
}

t[#t+1] = Def.Sprite{
    Texture="BGVid.mkv",
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom( 1.1*(SCREEN_WIDTH/640) )
        :diffuse( color("#1C2C3C") ):rate(0.5):blend("BlendMode_Add")
    end,
}

t[#t+1] = Def.Sprite{
    Texture="DE-Presents0001.png",
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):diffuse(color("0,0,0,1")):rotationz(-10)
        :addy(-600):sleep(1):zoom(10):accelerate(2):addy(460):diffuse(Color.White)
        :rotationz(0):zoom(1.1):decelerate(0.1):zoom(1):accelerate(0.1):zoom(1.1)
        :diffusealpha(1):linear(3):zoom(1.35):queuecommand("vibrate")
    end,
    vibrateCommand=function(s)
        s:vibrate()
        :effectmagnitude(0.5,2,0.1):accelerate(2.2):addy(180):zoom(0)
        :rotationz(10):addy(0):diffuse(color("0,0,0,1"))
    end,
}

t[#t+1] = Def.Quad{
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):stretchto(SCREEN_WIDTH*2,SCREEN_HEIGHT*2,0,0)
        :diffusealpha( 0 ):sleep(8.7):linear(0.3):diffuse(Color.White)
    end
}

return t