local t = Def.ActorFrame{}

t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:zoom(0.7):xy(SCREEN_CENTER_X-208, 60)
		:sleep(1):easeincubic(0.5):y(30):diffusealpha(0)
	end,
	SortOrderChangedMessageCommand=function(self)
		self:playcommand("Set")
	end,
	SetCommand=function(self)
		local sortorder = GAMESTATE:GetSortOrder()
		if sortorder and sortorder ~= "SortOrder_ModeMenu" then
			self:GetChild("SortText"):settext( SortOrderToLocalizedString(sortorder) )
			self:stoptweening():easeoutcubic(0.5):y(60):diffusealpha(1)
			:sleep(1):easeincubic(0.5):y(30):diffusealpha(0)
		end
	end,
	SelectMenuOpenedMessageCommand=function(self)
		self:stoptweening():easeoutcubic(0.5):y(60):diffusealpha(1)
	end,
	SelectMenuClosedMessageCommand=function(self)
		self:stoptweening():easeoutcubic(0.5):y(30):diffusealpha(0)
	end,

	Def.Sprite{ Texture="ScreenSelectMusic underlay/PaneDisplay under.png",
		InitCommand=function(self) self:rotationz(180):cropbottom(0.4):diffuse( color("#060A0E") ) end
	},
	Def.Sprite{ Texture="ScreenSelectMusic underlay/PaneDisplay F",
		InitCommand=function(self) self:rotationz(180):cropbottom(0.4):diffuse( color("#4F5F6F") ) end
	},

	Def.BitmapText{
		Font="Common Normal",
		Text=THEME:GetString("ScreenSelectMusic","CurrentSort"),
		InitCommand=function(self) self:xy(-4,0):zoom(0.8) end
	},

	Def.BitmapText{
		Font="Common Normal",
		Name="SortText",
		Text="All Music (Group)",
		InitCommand=function(self) self:xy(-4,18) end
	}
}

t[#t+1] = loadfile( THEME:GetPathB("ScreenWithMenuElements","overlay") )()

t[#t+1] = loadfile( THEME:GetPathG('ScreenSelectMusic','StepsDisplayList') )()..{
    OnCommand=function(s) s:xy( SCREEN_CENTER_X+136, SCREEN_CENTER_Y+14 ) end
}


t[#t+1] = Def.HelpDisplay {
	File="novamono/36/_novamono 36px",
	OnCommand=function(s)
        s:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y+198):zoom(0.75):diffuseblink()
        
        local OptionStrings = {
            ["DefaultJudgmentSize"] = 1,
            ["DefaultJudgmentOpacity"] = 1,
            ["DefaultComboSize"] = 1,
            ["ToggleComboBounce"] = true,
            ["ToggleJudgmentBounce"] = true,
            ["ToggleComboExplosion"] = true,
            ["ScoringFormat"] = 0,
        }
        for pn in ivalues( GAMESTATE:GetEnabledPlayers() ) do
            for _,v in pairs(OptionStrings) do
                if not GAMESTATE:Env()[_.."Machinetemp"..pn] then GAMESTATE:Env()[_.."Machinetemp"..pn] = v end
            end
        end
	end,
    InitCommand=function(s)
		s:SetSecsBetweenSwitches(THEME:GetMetric("HelpDisplay","TipSwitchTime"))
		:SetTipsColonSeparated( LoadModule("Text.GenerateHelpText.lua")( {"HelpTextNormal","DifficultyChangingAvailableHelpTextAppend","SelectButtonAvailableHelpTextAppend"} ) )
	end,
	SetHelpTextCommand=function(s, params) s:SetTipsColonSeparated( params.Text ) end,
	SelectMenuOpenedMessageCommand=function(s) s:stoptweening():decelerate(0.2):zoomy(0) end,
	SelectMenuClosedMessageCommand=function(s) s:stoptweening():decelerate(0.2):zoomy(0.75) end
}

GAMESTATE:Env()["gnNextScreen"] = "ScreenPlayerOptions"
GAMESTATE:Env()["gnAlreadyAtMenu"] = false
t[#t+1] = Def.ActorFrame{
    OnCommand=function(self)
        self:xy( SCREEN_CENTER_X, SCREEN_BOTTOM-17-12 ):zoom(0.8):zoomy(0)

		local CenterText = self:GetChild("ChangeSort"):GetChild("Dialog"):GetZoomedWidth()
		self:GetChild("Easier"):x( -(CenterText*.5+50) )
		self:GetChild("Harder"):x( ((CenterText*.5+20)) )
		self:GetChild("ChangeSort"):x( -CenterText*.5 )
    end,
	SelectMenuOpenedMessageCommand=function(self)
		self:stoptweening():decelerate(0.2):y( SCREEN_BOTTOM-17-24 ):zoomy(0.8):diffusealpha(1)
	end,
	SelectMenuClosedMessageCommand=function(self)
		self:stoptweening():decelerate(0.2):diffusealpha(0):zoomy(0):y( SCREEN_BOTTOM-17-12 )
	end,

	Def.Sound{
		File=THEME:GetPathS("ScreenSelectMusic select","down"),
		SelectMenuOpenedMessageCommand=function(self)
			self:play()
		end,
	},

    Def.ActorFrame{
		Name="Easier",
        Def.BitmapText{
			Font="Common Normal",
			Name="Button",
			Text="&MENULEFT;",
			OnCommand=function(self) self:x( -(self:GetParent():GetChild("Dialog"):GetZoomedWidth() + 15) ) end,
        },

        Def.BitmapText{
			Font="Common Normal",
			Name="Dialog",
			Text=Screen.String("Easier"),
			OnCommand=function(self)
				self:halign(1):diffuseramp():effectperiod(1):effectoffset(0.20):effectclock("bgm")
				:effectcolor1(color("#FFFFFF")):effectcolor2(color("#20D020"))
			end
        }
    },

	Def.ActorFrame{
		Name="Harder",
        Def.BitmapText{
			Font="Common Normal",
			Name="Button",
			Text="&MENURIGHT;",
			OnCommand=function(self) self:x( (self:GetParent():GetChild("Dialog"):GetZoomedWidth() + 15) ) end,
        },

        Def.BitmapText{
			Font="Common Normal",
			Name="Dialog",
			Text=Screen.String("Harder"),
			InitCommand=function(self)
				self:halign(0):diffuseramp():effectperiod(1):effectoffset(0.20):effectclock("bgm")
				:effectcolor1(color("#FFFFFF")):effectcolor2(color("#E06060"))
			end
        }
    },

	Def.ActorFrame{
		Name="ChangeSort",
        Def.BitmapText{
			Font="Common Normal",
			Name="Button",
			Text="&START;",
			InitCommand=function(self) self:x(-7):halign(1) end,
        },

        Def.BitmapText{
			Font="Common Normal",
			Name="Dialog",
			Text=Screen.String("ChangeSort"),
			InitCommand=function(self) self:halign(0) end
        }
    }
}

return t;