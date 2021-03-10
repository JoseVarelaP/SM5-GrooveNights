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
		OnCommand=function(s)
			s:xy( SCREEN_CENTER_X, var ):zoomtowidth(SCREEN_WIDTH):cropleft(-0.2):cropright(-0.2):diffuse( color("#060A0E") )
		end,
	}
	t[#t+1] = Def.Sprite{
		Texture="streak F",
		OnCommand=function(s)
			s:xy( SCREEN_CENTER_X, var ):zoomtowidth(SCREEN_WIDTH):cropleft(-0.2):cropright(-0.2):diffuse( color("#1C2C3C") )
		end,
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

return t;