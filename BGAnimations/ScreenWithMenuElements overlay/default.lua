local t = Def.ActorFrame{
	OnCommand=function(s)
		if GAMESTATE:Env()["Vibrate"] then
            if SCREENMAN:GetTopScreen() then
                for v in pairs( SCREENMAN:GetTopScreen():GetChildren() ) do
                    if SCREENMAN:GetTopScreen():GetChild(v) then
                        SCREENMAN:GetTopScreen():GetChild(v):vibrate():effectmagnitude(2,2,2)
                    end
                end
            end
        end
	end
}

local pos = { SCREEN_BOTTOM-36, SCREEN_TOP+40 }

for var in ivalues(pos) do
	t[#t+1] = Def.Sprite{
		Texture="streak B",
		OnCommand=function(self)
			self:xy( SCREEN_CENTER_X, var ):zoomtowidth(SCREEN_WIDTH):cropleft(-0.2):cropright(-0.2):diffuse( color("#060A0E") )
		end
	}
	t[#t+1] = Def.Sprite{
		Texture="streak F",
		OnCommand=function(self)
			self:xy( SCREEN_CENTER_X, var ):zoomtowidth(SCREEN_WIDTH):cropleft(-0.2):cropright(-0.2):diffuse( color("#1C2C3C") )
		end
	}
end
t[#t+1] = Def.BitmapText{
	Font="novamono/36/_novamono 36px",
	InitCommand=function(s)
		local sClass = Var "LoadingScreen"
		local string = Screen.String("HeaderText")
		if GAMESTATE:Env()["AngryGrandpa"] and THEME:HasString( sClass, "GrandpaHeader" ) then
			string = Screen.String("GrandpaHeader")
		end
		s:settext( string ):strokecolor(Color.Black)
	end,
	OnCommand=function(s) s:xy( s:GetWidth()/2+20, 33 ) end,
}

-- Some stage graphics contain different coloring offsets depending on the text string.
local stagecases = {
	Conditionals = {
		["Stage_Event"] = { Text="EventMode", ColorOffset=true },
		["Stage_Final"] = { Text="Final", ColorOffset=true },
	},

	__index = function( this, stage )
		-- If there's a special case found in the Conditionals Table, then it means that it has to use custom
		-- text and possibly an offset. Otherwise, it might just be a typical round, and will require both bitmaptext actors.
		return this.Conditionals[stage] or { Text="Round", ColorOffset=false }
	end
}

setmetatable(stagecases, stagecases)

local currentdata = stagecases[GAMESTATE:GetCurrentStage()]
local curindex = GAMESTATE:GetCurrentStageIndex()+( Var "LoadingScreen" ~= "ScreenEvaluationNormal" and 1 or 0 )

t[#t+1] = Def.ActorFrame{
	OnCommand=function(s)
		s:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y-205 - ( currentdata.ColorOffset and 2 or 0 ) ):zoom(0.9)
		:visible( SCREENMAN:GetTopScreen():GetScreenType() == "ScreenType_GameMenu" )
	end,

	Def.BitmapText{
		Font="journey/40/_journey 40px",
		Name="RoundArea",
		Text=THEME:GetString("ScreenSelectMusic", currentdata.Text ),
		OnCommand=function(s)
			s:zoom( currentdata.ColorOffset and 1 or 0.8):diffuse( currentdata.ColorOffset and Color.Red or Color.White ):strokecolor(Color.Black)
		end
	},
	
	Def.BitmapText{
		Font="journey/40/_journey 40px",
		Condition=(not GAMESTATE:IsEventMode() and not currentdata.ColorOffset),
		Text=curindex,
		OnCommand=function(s)
			s:xy( s:GetParent():GetChild("RoundArea"):GetZoomedWidth()*0.6, -4 ):diffuse(Color.Red):strokecolor(Color.Black)
		end
	}
}

return t