local t = Def.ActorFrame{}

t[#t+1] = loadfile( THEME:GetPathB("ScreenWithMenuElements","overlay") )()

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG( "Stages/SWME/ScreenWithMenuElements","stage ".. ToEnumShortString(GAMESTATE:GetCurrentStage()) ),
    OnCommand=function(s)
        if GAMESTATE:GetCurrentStage() == "Stage_Final" then
            s:Load( THEME:GetPathG("Stages/SWME/ScreenWithMenuElements stage","final") )
        end
        s:xy( SCREEN_CENTER_X, SCREEN_TOP+40 )
    end;
}


return t;