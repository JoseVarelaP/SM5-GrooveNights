local t = Def.ActorFrame{}
t[#t+1] = loadfile( THEME:GetPathB("ScreenWithMenuElements","overlay") )()

t[#t+1] = Def.BitmapText{
    Font="novamono/36/_novamono 36px",
    OnCommand=function(s)
        s:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y-178 )
        :zoom(0.75):maxwidth(450)
        if GAMESTATE:GetCurrentSong() then
            s:settext( GAMESTATE:GetCurrentSong():GetDisplayMainTitle(), GAMESTATE:GetCurrentSong():GetTranslitMainTitle() )
        end
    end
}

t[#t+1] = Def.BitmapText{
    Font="novamono/36/_novamono 36px",
    OnCommand=function(s)
        s:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y-162 )
        :zoom(0.5):maxwidth(450)    
        if GAMESTATE:GetCurrentSong() then
            s:settext( GAMESTATE:GetCurrentSong():GetDisplayArtist() )
        end
    end
}

t[#t+1] = Def.HelpDisplay {
	File="novamono/36/_novamono 36px",
	OnCommand=function(s)
		s:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y+198):zoom(0.75):diffuseblink()
	end,
	InitCommand=function(s)
		s:SetSecsBetweenSwitches(THEME:GetMetric("HelpDisplay","TipSwitchTime"))
		:SetTipsColonSeparated( LoadModule("Text.GenerateHelpText.lua")( {"HelpTextNormal","SelectAvailableHelpTextAppend"} ) )
	end,
	SelectMenuOpenedMessageCommand=function(s)
		s:stoptweening():decelerate(0.2):zoomy(0)
	end,
	SelectMenuClosedMessageCommand=function(s)
		s:stoptweening():bouncebegin(0.2):zoomy(0.75)
	end
}

return t;