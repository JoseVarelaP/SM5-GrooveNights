local t = Def.ActorFrame{
    OnCommand=function(s) s:zoom(.3):xy(-1,1):wag():effectmagnitude(0,0,2) end,
}

t[#t+1] = Def.Sprite{
    Texture="GradeTier0017",
    InitCommand=function(s)
        s:diffusealpha(0):y(24):sleep(0.2):queuecommand("GradeSound")
        :decelerate(0.6):zoom(1.5):diffusealpha(1):accelerate(0.4):zoom(1)
        :decelerate(0.1):zoom(0.9):diffusealpha(0.8):accelerate(0.1):zoom(1):diffusealpha(1)
    end,
    GradeSoundCommand=function(s)
        SOUND:PlayOnce( THEME:GetPathS("","grade1") )
    end,
    OnCommand=function(s) s:sleep(0.2) end,
}

return t;