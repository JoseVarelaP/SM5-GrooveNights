return Def.ActorFrame{
    OnCommand=function(s)
        s:hibernate(1)
    end,
    Def.Quad{
        OnCommand=function(s) s:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,SCREEN_HEIGHT):diffuse(Color.
        Black):addy( SCREEN_HEIGHT/2 ):decelerate(0.2):addy( -SCREEN_HEIGHT/2 )
        end
    },
    Def.Quad{
        OnCommand=function(s) s:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,0):diffuse(Color.Black):addy( -SCREEN_HEIGHT/2 )
            :decelerate(0.2):addy( SCREEN_HEIGHT/2 )
        end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("","TransitionArrow"),
        OnCommand=function(s)
            s:xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100):queuecommand("SFX"):decelerate(0.2):y( SCREEN_CENTER_Y )
        end,
        SFXCommand=function(s)
            SOUND:PlayOnce( THEME:GetPathS("gnScreenTransition whoosh", "in") )
        end,
    },
}