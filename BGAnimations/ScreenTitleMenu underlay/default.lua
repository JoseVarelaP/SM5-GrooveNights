return Def.ActorFrame{
    Def.Sprite{
    Texture="HomeFrame",
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+130)
        :diffusealpha(0):linear(0.3):diffusealpha(0.8)
        :zoomx(1.1)
    end,
    CodeMessageCommand=function(s,param)
        SCREENMAN:SystemMessage( param.Name .." code Activated" )
        GAMESTATE:Env()[param.Name] = true
    end;
    }
}
