-- Summer Rain, I made this chart so I don't need to credit myself (oops)
return Def.ActorFrame{
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom( (SCREEN_WIDTH/640) )
    end,
    Def.Sprite{
        Texture="easter_eggs/rainnear",
        OnCommand=function(s)
            s:customtexturerect(0,0,1,1):texcoordvelocity(0,-1)
            :stretchto( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT ):align(1,1)
            :diffusealpha(0):linear(1):diffusealpha(1)
        end,
    },

    Def.Sprite{
        Texture="easter_eggs/rainmed",
        OnCommand=function(s)
            s:customtexturerect(0,0,1,1):texcoordvelocity(0,-0.8)
            :stretchto( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT ):align(1,1):rotationz(5)
            :diffusealpha(0):linear(1):diffusealpha(1)
        end,
    },

    Def.Sprite{
        Texture="easter_eggs/rainfar",
        OnCommand=function(s)
            s:customtexturerect(0,0,1,1):texcoordvelocity(0,-0.6)
            :stretchto( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT ):align(1,1):rotationz(-5)
            :diffusealpha(0):linear(1):diffusealpha(1)
        end,
    },

    Def.Sprite{
        Texture="easter_eggs/rainClouds",
        OnCommand=function(s)
            s:diffusealpha(0):linear(1):diffusealpha(1)
        end,
    },
}