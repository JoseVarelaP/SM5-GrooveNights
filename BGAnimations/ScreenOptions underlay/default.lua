local t = Def.ActorFrame{}

t[#t+1] = Def.Quad{
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
        s:stretchto( SCREEN_WIDTH, SCREEN_HEIGHT-30, 0, 30 )
        s:diffuse(Color.Black)
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("options","page"),
    OnCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y) end
}


t[#t+1] = Def.Sprite{
    Texture="ScreenOptions frame",
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
    end
}

local PPos ={ [PLAYER_1] = SCREEN_CENTER_X-269, [PLAYER_2] = SCREEN_CENTER_X+269 }
for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
    -- Profile picture?
        t[#t+1] = Def.ActorFrame{
            Condition=GAMESTATE:Env()["ToGame"],
            Def.Sprite {
                Texture=LoadModule("Options.GetProfileData.lua")(pn)["Image"];
                OnCommand=function(s)
                    s:xy( PPos[pn],SCREEN_CENTER_Y-96)
                    :setsize(80,80)
                end,
            },

            Def.Sprite{
                Condition=GAMESTATE:IsHumanPlayer(pn),
                Texture=THEME:GetPathG("","PlayerReady"),
                OnCommand=function(s)
                    s:diffusealpha(0)
                    :xy( PPos[pn],SCREEN_CENTER_Y-76)
                    :zoom(1)
                    :draworder(5)
                    :diffuseblink()
                end,
                ["ExitSelected".. ToEnumShortString(pn) .."MessageCommand"]=function(s,param)
                    s:zoom(1):diffusealpha(1)
                    SOUND:PlayOnce( THEME:GetPathS( 'PlayerReady', 'sound' ) )
                end,
                ["ExitUnselected".. ToEnumShortString(pn) .."MessageCommand"]=function(s,param)
                    s:zoom(0):diffusealpha(0)
                    SOUND:PlayOnce( THEME:GetPathS( 'PlayerNotReady', 'sound' ) )
                end,
                AllReadyMessageCommand=function(s)
                    SOUND:PlayOnce( THEME:GetPathS( 'PlayerBothReady', 'sound' ) )
                end,
            },

            Def.Sprite{
                Condition=GAMESTATE:IsHumanPlayer(pn),
                Texture="ScreenOptions playerframe",
                OnCommand=function(s)
                    s:xy( PPos[pn], SCREEN_CENTER_Y-112 )
                    :zoomx( pn == PLAYER_2 and -1 or 1 )
                end,
            },

            --Player 1/2's BPM & Speed Display
            Def.BitmapText{
                Condition=GAMESTATE:GetCurrentSong(),
                Font="_eurostile blue glow", Text="BPM:",
                OnCommand=function(s)
                    s:halign(0):zoom(0.55):diffuse( color("0.6,0.8,0.9,1") )
                    s:xy( PPos[pn]-38, SCREEN_CENTER_Y-45 )
                end,
            },
            Def.BitmapText{
                Condition=GAMESTATE:GetCurrentSong(),
                Font="_eurostile blue glow", Text="SPEED:",
                OnCommand=function(s)
                    s:halign(0):zoom(0.55):diffuse( color("0.6,0.8,0.9,1") )
                    s:xy( PPos[pn]-38, SCREEN_CENTER_Y-33 )
                end,
            },
                
                -- Player Name
                Def.BitmapText{
                Condition=GAMESTATE:GetCurrentSong(),
                Font="_eurostile blue glow", Text=LoadModule("Options.GetProfileData.lua")(pn)["Name"],
                OnCommand=function(s)
                    local pn_to_color_name= {[PLAYER_1]= "PLAYER_1", [PLAYER_2]= "PLAYER_2"}
                    local color = GameColor.PlayerColors[pn_to_color_name[pn]]

                    s:zoom(0.6):diffuse( color )
                    s:xy( PPos[pn], SCREEN_CENTER_Y-154 )
                end,
            },

            -- BPM Display
            Def.BitmapText{
                Condition=GAMESTATE:GetCurrentSong(),
                Font="_eurostile blue glow",
                OnCommand=function(s)
                    s:halign(0):zoom(0.55):maxwidth(70)
                    s:xy( PPos[pn], SCREEN_CENTER_Y-45 )
                    -- We need to calculate the possible BPM of the CURRENT CHART.
                    -- This is because SM5 support separate timings.
                    local Steps = GAMESTATE:GetCurrentSteps(pn)
			        local val = ""
			        if Steps then
				        local bpms = Steps:GetDisplayBpms()
				        if bpms[1] == bpms[2] then
					        val = string.format("%i", math.floor(bpms[1]) )
				        else
					        val = string.format("%i-%i",math.floor(bpms[1]),math.floor(bpms[2]))
				        end
			        end
			        s:settext(val)
                end,
            },

            -- SPEED
            -- Formula: math.ceil((setModP1+addModP1)*highBPM*curRate)
            Def.BitmapText{
                Font="_eurostile blue glow",
                OnCommand=function(s)
                    s:halign(0):zoom(0.55):maxwidth(70)
                    s:xy( PPos[pn], SCREEN_CENTER_Y-33 )
                end,
                InitCommand= function(s)
                    local speed, mode= GetSpeedModeAndValueFromPoptions(pn)
                    s:playcommand("SpeedChoiceChanged", {pn= pn, mode= mode, speed= speed})
                end,
                SpeedChoiceChangedMessageCommand= function(s, param)
                    local speed = LoadModule("Gameplay.ObtainSpeed.lua")(pn,param)
                    if param.pn ~= pn then return end
                    s:settext( speed or "" )
		        end
            },
        }
end

t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathB("ScreenLogo","background/BGVid.avi"),
	OnCommand=function(s)
		s:diffusealpha(0.15):rotationy(180):blend("BlendMode_Add"):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom(1.1*(SCREEN_WIDTH/640))
	end,
}

t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathG("Screen divider","frame"),
	OnCommand=function(s)
		s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
	end,
}

return t;
--[[
[Layer1]
File=ScreenOptions frame
InitCommand=x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;


[Layer2]
Condition=GAMESTATE:IsHumanPlayer(PLAYER_1)
File=ScreenOptions playerframe
InitCommand=x,SCREEN_CENTER_X-269;y,SCREEN_CENTER_Y-112;

[Layer3]
Condition=GAMESTATE:IsHumanPlayer(PLAYER_1)
Text=@ScreenEndingGetDisplayName(PLAYER_1)
File=_eurostile normal
OnCommand=@'maxwidth,108;x,SCREEN_CENTER_X-269;y,SCREEN_CENTER_Y-154;horizalign,center;shadowlength,0;zoom,0.65;Diffuse,'..PlayerColor(PLAYER_1);

[Layer4]
Condition=GAMESTATE:IsHumanPlayer(PLAYER_2)
File=ScreenOptions playerframe
InitCommand=x,SCREEN_CENTER_X+269;y,SCREEN_CENTER_Y-112;rotationy,180;

[Layer5]
Condition=GAMESTATE:IsHumanPlayer(PLAYER_2)
Text=@ScreenEndingGetDisplayName(PLAYER_2)
File=_eurostile normal
OnCommand=@'maxwidth,108;x,SCREEN_CENTER_X+270;y,SCREEN_CENTER_Y-154;horizalign,center;shadowlength,0;zoom,0.65;Diffuse,'..PlayerColor(PLAYER_2);

	
[Layer6]
File=../ScreenLogo background/BGVid.avi
OnCommand=x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;blend,add;zoom,2;rotationy,180;diffusealpha,0.15;
]]