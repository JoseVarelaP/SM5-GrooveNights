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
t[#t+1] = loadfile( THEME:GetPathG('ScreenSelectMusic','StepsDisplayList') )()..{
    OnCommand=function(s) s:xy( SCREEN_CENTER_X+136, SCREEN_CENTER_Y+14 ) end
}

t[#t+1] = Def.HelpDisplay {
	File="_eurostile normal",
	OnCommand=function(s)
		s:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y+204):zoom(0.75):diffuseblink()
	end,
	InitCommand=function(s)
		local str = THEME:GetString("ScreenSelectMusic","HelpTextNormal") .. "::" ..
			THEME:GetString("ScreenSelectMusic","DifficultyChangingAvailableHelpTextAppend") .. "::" ..
			THEME:GetString("ScreenSelectMusic","SelectButtonAvailableHelpTextAppend")
		s:SetSecsBetweenSwitches(THEME:GetMetric("HelpDisplay","TipSwitchTime"))
		s:SetTipsColonSeparated(str)
	end,
	SetHelpTextCommand=function(s, params)
		s:SetTipsColonSeparated( params.Text )
	end,
	SelectMenuOpenedMessageCommand=function(s)
		s:stoptweening():decelerate(0.2):zoomy(0)
	end,
	SelectMenuClosedMessageCommand=function(s)
		s:stoptweening():bouncebegin(0.2):zoomy(0.75)
	end
}

GAMESTATE:Env()["gnNextScreen"] = "ScreenPlayerOptions"
t[#t+1] = Def.ActorFrame{
    OnCommand=function(s)
        s:y( SCREEN_BOTTOM-17-18 )
    end,
    SelectMenuOpenedMessageCommand=function(s)
        SOUND:PlayOnce( THEME:GetPathS("ScreenSelectMusic select","down") )
    end,

    Def.ActorFrame{
    OnCommand=function(s)
        if ModeMenuAvailable then s:x(SCREEN_CENTER_X-225) else s:x(SCREEN_CENTER_X-125) end
    end,
        LoadFont("Common Normal")..{ Text="&MENULEFT;";
        OnCommand=function(s)
            s:x(-5):horizalign(right):zoomx(0.5):zoomy(0.7):diffusealpha(0)
        end,
        SelectMenuOpenedMessageCommand=function(s)
            s:stoptweening():bounceend(0.2):diffusealpha(1):zoomx(0.7)
        end,
        SelectMenuClosedMessageCommand=function(s)
            s:stoptweening():linear(0.2):diffusealpha(0):zoomx(0.5)
        end,
        };

        LoadFont("Common Normal")..{ Text="Easier";
        OnCommand=function(s)
            s:x(0):horizalign(left):zoomx(0.5):zoomy(0.7):diffusealpha(0):diffuseramp():effectperiod(1):effectoffset(0.20):effectclock("bgm"):effectcolor1(color("#FFFFFF")):effectcolor2(color("#20D020"))
        end,
        SelectMenuOpenedMessageCommand=function(s)
            s:stoptweening():bounceend(0.2):diffusealpha(1):zoomx(0.7)
        end,
        SelectMenuClosedMessageCommand=function(s)
            s:stoptweening():linear(0.2):diffusealpha(0):zoomx(0.5)
        end,
        };
    };

    Def.ActorFrame{
        OnCommand=function(s)
            if ModeMenuAvailable then s:x(SCREEN_CENTER_X+225) else s:x(SCREEN_CENTER_X+125) end
        end,
            LoadFont("Common Normal")..{ Text="&MENURIGHT;";
            OnCommand=function(s)
                s:x(15):horizalign(center):zoomx(0.5):zoomy(0.7):diffusealpha(0)
            end,
            SelectMenuOpenedMessageCommand=function(s)
                s:stoptweening():bounceend(0.2):diffusealpha(1):zoomx(0.7)
            end,
            SelectMenuClosedMessageCommand=function(s)
                s:stoptweening():linear(0.2):diffusealpha(0):zoomx(0.5)
            end,
            };

            LoadFont("Common Normal")..{ Text="Harder";
            OnCommand=function(s)
                s:x(0):horizalign(right):zoomx(0.5):zoomy(0.7):diffusealpha(0):diffuseramp():effectperiod(1):effectoffset(0.20):effectclock("bgm"):effectcolor1(color("#FFFFFF")):effectcolor2(color("#E06060"))
            end,
            SelectMenuOpenedMessageCommand=function(s)
                s:stoptweening():bounceend(0.2):diffusealpha(1):zoomx(0.7)
            end,
            SelectMenuClosedMessageCommand=function(s)
                s:stoptweening():linear(0.2):diffusealpha(0):zoomx(0.5)
            end,
            };
    };

    Def.BitmapText{
        Font="Common Normal",
        Text="&START; Change Sort",
        Condition=ModeMenuAvailable;
        OnCommand=function(s)
            s:x(SCREEN_CENTER_X):zoomx(0.5):zoomy(0.7):diffusealpha(0)
        end,
        SelectMenuOpenedMessageCommand=function(s)
            s:stoptweening():bounceend(0.2):diffusealpha(1):zoomx(0.7)
        end,
        SelectMenuClosedMessageCommand=function(s)
            s:stoptweening():linear(0.2):diffusealpha(0):zoomx(0.5)
        end,
    };

};

return t;