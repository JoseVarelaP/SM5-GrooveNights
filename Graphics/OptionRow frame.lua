local t = Def.ActorFrame{}
local CurDir = {}
if not GAMESTATE:Env()["GNSetting"] then
	GAMESTATE:Env()["GNSetting"] = "nil"
end
if not GAMESTATE:Env()["OriginalOffset"] then
	GAMESTATE:Env()["OriginalOffset"] = string.format( "%.3f", PREFSMAN:GetPreference( "GlobalOffsetSeconds" ) )
end
local set = string.format( "%.3f", GAMESTATE:Env()["OriginalOffset"] )
local OperatorSet = string.format( "%.3f", PREFSMAN:GetPreference( "GlobalOffsetSeconds" ) )

t[#t+1] = Def.Actor{
	OnCommand=function(s)
		s:visible(false)
		local OpRow = s:GetParent():GetParent():GetParent()
		if OpRow then
			if OpRow:GetName() == "Steps" then
				s:visible(true)
				for pn in ivalues( GAMESTATE:GetEnabledPlayers() ) do
					CurDir[pn] = OpRow:GetChoiceInRowWithFocus(pn)
				end
				s:queuecommand("Update")
			end
		end
	end,
	UpdateCommand=function(s)	
		local OpRow = s:GetParent():GetParent():GetParent()
		for pn in ivalues( GAMESTATE:GetEnabledPlayers() ) do
			if OpRow:GetChoiceInRowWithFocus(pn) ~= CurDir[pn] then
				MESSAGEMAN:Broadcast("OptionRowSteps"..ToEnumShortString(pn).."Changed",{Index=OpRow:GetChoiceInRowWithFocus(pn)+1})
				CurDir[pn] = OpRow:GetChoiceInRowWithFocus(pn)
			end
		end
		s:sleep(4/60):queuecommand("Update")
	end,
}

local TKN = PREFSMAN:GetPreference("ThreeKeyNavigation")
local widths = { TKN and 300 or 360, TKN and 3.6 or 4, TKN and 200 or 216 }
local ammount = LoadModule("Options.Prefs.lua").gnGlobalOffset.Values

local valmargin = 0.1
t[#t+1] = Def.ActorFrame{
	OnCommand=function(s)
		local name = s:GetParent():GetParent():GetParent():GetName()
		s:y(6):x( TKN and 298 or 276 )
		s:visible( name == "gnGlobalOffset" or name == "OPERATORGlobalOffset" )
	end,

	Def.Quad{
		InitCommand=function(s)
			s:xy( widths[1]-250, 6 ):zoom(4):rotationz(45):diffuse( Color.Green )
		end,
	},

	Def.BitmapText{
		Font="Common Normal",
		Text="Original Offset (".. (GAMESTATE:Env()["GNSetting"] == "Operator" and OperatorSet or set) ..")",
		InitCommand=function(s)
			s:zoom(0.4):xy( widths[1]-240, 6 ):halign(0)
		end,
	},

	Def.BitmapText{ Font="Common Normal", Text="Late", InitCommand=function(s) s:zoom(0.4):xy( -widths[3], -4 ):halign(1) end },
	Def.BitmapText{ Font="Common Normal", Text="Early", InitCommand=function(s) s:zoom(0.4):xy( widths[3], -4 ):halign(1) end },


	Def.Quad{
		OnCommand=function(s)
			s:xy( -12,-4 ):zoomto( widths[1]+30,4 ):diffuse( color("#1C2C3C") )
		end,
	},
	Def.Sprite{
		Texture=THEME:GetPathG("","EXP/expBar"),
		OnCommand=function(s)
			s:x( -34 ):zoom(1.8):zoomx( widths[2] )
		end,
	},
	Def.Quad{
		InitCommand=function(s)
			s:xy(
				scale( GAMESTATE:Env()["GNSetting"] == "Operator" and OperatorSet or set, -1, 1, -190, 160 )
				, -4
			):zoom(4):rotationz(45):diffuse( Color.Green )
		end,
	},

	Def.BitmapText{
		Font="Common Normal",
		InitCommand=function(s)
			s:zoom(0.4):y( -16 )
		end,
		gnGlobalOffsetChangeMessageCommand=function(s,param)
			s:x( scale( param.choice, 0, #ammount, -190, 160 ) )
			s:settext( string.format( "%.3f",-valmargin + (0.002*(param.choice-1)) ) )
		end,
		OPERATORGlobalOffsetChangeMessageCommand=function(s,param)
			s:x( scale( param.choice, 0, #ammount, -190, 160 ) )
			s:settext( string.format( "%.3f",-valmargin + (0.002*(param.choice-1)) ) )
		end,
	},
	Def.Quad{
		InitCommand=function(s)
			s:xy( 70, -4 ):zoom(8):rotationz(45)
		end,
		gnGlobalOffsetChangeMessageCommand=function(s,param)
			local spot = string.format( "%.3f", (-valmargin + (0.002*(param.choice-1))))

			--lua.ReportScriptError( ("%f - %f"):format( spot,set ) )

			s:x( scale( param.choice, 0, #ammount, -190, 160 ) )
			s:diffuse( spot == set and Color.Green or Color.White )
		end,
		OPERATORGlobalOffsetChangeMessageCommand=function(s,param)
			s:x( scale( param.choice, 0, #ammount, -190, 160 ) )
			s:diffuse( Color.Green )
		end,
	},
}

return t;