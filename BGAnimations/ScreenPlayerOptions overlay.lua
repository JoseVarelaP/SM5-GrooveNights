local t = Def.ActorFrame{}
t[#t+1] = loadfile( THEME:GetPathB("ScreenWithMenuElements","overlay") )()

t[#t+1] = Def.BitmapText{
    Font="_eurostile blue glow",
    OnCommand=function(s)
        s:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y-168 )
        :zoom(0.75):maxwidth(450)
        if GAMESTATE:GetCurrentSong() then
            s:settext( GAMESTATE:GetCurrentSong():GetDisplayMainTitle() )
        end
    end,
}

t[#t+1] = Def.BitmapText{
    Font="_eurostile blue glow",
    OnCommand=function(s)
        s:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y-150 )
        :zoom(0.5):maxwidth(450)
        if GAMESTATE:GetCurrentSong() then
            s:settext( GAMESTATE:GetCurrentSong():GetDisplayArtist() )
        end
    end,
}

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