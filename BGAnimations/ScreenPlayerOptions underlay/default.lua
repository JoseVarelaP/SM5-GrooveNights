local t = Def.ActorFrame{}

local Steps = {}
local DifficultyIndex = {
    ["Difficulty_Beginner"] = 1,
    ["Difficulty_Easy"] = 2,
    ["Difficulty_Medium"] = 3,
    ["Difficulty_Hard"] = 4,
    ["Difficulty_Challenge"] = 5,
    ["Difficulty_Edit"] = 6,
}

for _,v in pairs( GAMESTATE:GetCurrentSong():GetStepsByStepsType( GAMESTATE:GetCurrentStyle():GetStepsType() ) ) do
    Steps[ DifficultyIndex[ v:GetDifficulty() ] ] = v
end
t[#t+1] = Def.Quad{
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
        s:stretchto( SCREEN_WIDTH, SCREEN_HEIGHT-30, 0, 30 )
        s:diffuse(Color.Black)
    end
}

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("options","page"),
    OnCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+10):diffuse( color("#060A0E") ) end
}


t[#t+1] = Def.Sprite{
    Texture="ScreenOptions frame",
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+10):diffuse( color("#1C2C3C") )
    end
}

t[#t+1] = Def.Sound{ Name="PlayerReady", File=THEME:GetPathS( 'PlayerReady', 'sound' ) }
t[#t+1] = Def.Sound{ Name="PlayerNotReady", File=THEME:GetPathS( 'PlayerNotReady', 'sound' ) }
t[#t+1] = Def.Sound{ Name="PlayerBothReady", File=THEME:GetPathS( 'PlayerBothReady', 'sound' ) }
local function side(pn)
	local s = 1
	if pn == PLAYER_1 then return s end
	return s*(-1)
end

for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
    t[#t+1] = LoadActor("../SpeedModUpdate.lua",pn)
    local PDir = MEMCARDMAN:GetCardState(pn) == 'MemoryCardState_none' and PROFILEMAN:GetProfileDir(string.sub(pn,-1)-1).."/GrooveNightsPrefs.ini" or "Save/TEMP"..pn
    local DJS = PDir and LoadModule("Config.Load.lua")("DefaultJudgmentSize",PDir) or GAMESTATE:Env()["DefaultJudgmentSizeMachinetemp"..pn]
    local DJO = PDir and LoadModule("Config.Load.lua")("DefaultJudgmentOpacity",PDir) or GAMESTATE:Env()["DefaultJudgmentOpacityMachinetemp"..pn]
    local DCS = PDir and LoadModule("Config.Load.lua")("DefaultComboSize",PDir) or GAMESTATE:Env()["DefaultComboSizeMachinetemp"..pn]
	
		local LabelACT = Def.ActorFrame{}
		local Labels = {"BPM","Speed","Steps","Length"}
		local longest = 0
		for _,v in pairs(Labels) do
			LabelACT[#LabelACT+1] = Def.BitmapText{
				Condition=GAMESTATE:GetCurrentSong(),
				Font="novamono/36/_novamono 36px", Text=Screen.String(v)..":",
				InitCommand=function(self)
					self:halign(0):zoom(0.5):diffuse( color("#FFA314") )
					:xy( SCREEN_CENTER_X-160*side(pn)-78, SCREEN_CENTER_Y+154-30+( 16*(_-1) ) )

					if self:GetZoomedWidth() > longest then
						longest = self:GetZoomedWidth()
					end
				end
			}
		end
		
		-- Profile picture?
        t[#t+1] = Def.ActorFrame{
            OnCommand=function(s)
                s:xy( SCREEN_CENTER_X-160*side(pn)-8, SCREEN_CENTER_Y+150 )
            end,

            Def.Sprite{ Texture="../ScreenSelectMusic underlay/PaneDisplay under.png", OnCommand=function(s) s:diffuse( color("#060A0E") ) end },
            Def.Sprite{ Texture="../ScreenSelectMusic underlay/PaneDisplay B", OnCommand=function(s) s:diffuse( color("#060A0E") ) end },
            
            -- Profile Managaer
            Def.Sprite {
                Texture=LoadModule("Options.GetProfileData.lua")(pn)["Image"];
                OnCommand=function(s)
                    s:xy(-114,-2)
                    :setsize(64,64)
                    if LoadModule("Options.GetProfileData.lua")(pn)["Name"] == "No Card" then
                        s:diffuse( PlayerColor(pn) )
                    end
                end,
            },
            Def.Quad {
                Condition=PROFILEMAN:GetProfile(pn):GetDisplayName() ~= "",
                OnCommand=function(s) s:zoomto(64,64):xy(-114,-2):croptop(0.7):fadetop(0.1):diffuse(Color.Black) end,
            },
            Def.Sprite {
                Texture=THEME:GetPathG("","AvatarFrame");
                OnCommand=function(s)
                    s:xy(-114,0):diffuse( color("#1C2C3C") )
                end,
            },
            Def.BitmapText {
                Font="novamono/36/_novamono 36px",
                Text=PROFILEMAN:GetProfile(pn):GetDisplayName(),
                OnCommand=function(s)
                    s:xy(-114,20):zoom(0.5):diffuse( PlayerColor(pn) )
                end,
            },

            --[[
            Def.Sprite{
                Condition=GAMESTATE:IsHumanPlayer(pn),
                Texture="ScreenOptions playerframe",
                OnCommand=function(s)
                    s:xy( PPos[pn], SCREEN_CENTER_Y-112 )
                    :zoomx( pn == PLAYER_2 and -1 or 1 )
                end,
            },
            ]]

            -- BPM Display
            Def.BitmapText{
                Condition=GAMESTATE:GetCurrentSong(),
                Font="novamono/36/_novamono 36px",
                OnCommand=function(s)
                    s:halign(0):zoom(0.55):maxwidth(70)
                    s:xy( -60+longest, -26+( 16*(0) ) )
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
                Font="novamono/36/_novamono 36px",
                OnCommand=function(s)
                    s:halign(0):zoom(0.55):maxwidth(330)
                    s:xy( -60+longest, -26+( 16*(1) ) )
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

            -- STEPS
            Def.BitmapText{
                Font="novamono/36/_novamono 36px",
                OnCommand=function(s)
                    s:halign(0):zoom(0.55):maxwidth(330 - longest)
                    s:xy( -60+longest, -26+( 16*(2) ) )
                    local st = GAMESTATE:GetCurrentSteps(pn):GetAuthorCredit() and GAMESTATE:GetCurrentSteps(pn):GetAuthorCredit() or GAMESTATE:GetCurrentSteps(pn):GetDescription()
                    s:settext( st )
                end,
                ["OptionRowSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s,param)
                    if param.Index then
                        if Steps[param.Index] then
                            local st = Steps[param.Index]:GetAuthorCredit() and Steps[param.Index]:GetAuthorCredit() or Steps[param.Index]:GetDescription()
                            s:settext( st )
                        end
                    end
                end,
            },

            -- LENGTH
            Def.BitmapText{
                Font="novamono/36/_novamono 36px",
                OnCommand=function(s)
                    s:halign(0):zoom(0.55):maxwidth(70)
                    :xy( -60+longest, -26+( 16*(3) ) )
                    :settext(
                        math.floor(GAMESTATE:GetCurrentSong():MusicLengthSeconds()) == 105 and "Patched" or
                        SecondsToMMSS( math.floor(GAMESTATE:GetCurrentSong():MusicLengthSeconds()) )
                    )
                end,
            },
        }

		t[#t+1] = LabelACT

        -- Draw ready on top of everything else
        t[#t+1] = Def.ActorFrame{
			Condition=GAMESTATE:IsHumanPlayer(pn),
			InitCommand=function(self)
				self:xy( SCREEN_CENTER_X-160*side(pn)-5, SCREEN_CENTER_Y+144 )
				:zoom(0)
			end,
			["ExitSelected".. ToEnumShortString(pn) .."MessageCommand"]=function(self,param)
				self:stoptweening():tween(0.2,"decelerate"):zoom(1):diffusealpha(1)
				self:GetParent():GetChild("PlayerReady"):play()
			end,
			["ExitUnselected".. ToEnumShortString(pn) .."MessageCommand"]=function(self,param)
				self:stoptweening():tween(0.2,"accelerate"):zoom(0.3):diffusealpha(0)
				self:GetParent():GetChild("PlayerNotReady"):play()
			end,
			AllReadyMessageCommand=function(self)
				self:GetParent():GetChild("PlayerBothReady"):play()
			end,

			Def.Quad{
				OnCommand=function(self)
					local frame = self:GetParent():GetParent():GetChild("PaneDisplayFrame")
					self:zoomto(
						frame:GetZoomedWidth()-12,
						frame:GetZoomedHeight()-38
					)
					:diffuse( Alpha(Color.Black,0.8) ):y(12)
				end,
			},

			Def.BitmapText{
				Font="journey/40/_journey 40",
				Text=Screen.String("Ready"),
				OnCommand=function(self)
					self:strokecolor(Color.Black):diffuseshift():effectcolor1( PlayerColor(pn) ):effectcolor2( ColorDarkTone( PlayerColor(pn) ) )
				end,
			},
		}

        t[#t+1] = Def.Sprite{
			Name="PaneDisplayFrame",
			Texture="../ScreenSelectMusic underlay/PaneDisplay F",
        	OnCommand=function(self)
				self:diffuse( color("#1C2C3C") ):xy( SCREEN_CENTER_X-160*side(pn)-8, SCREEN_CENTER_Y+154 )
        	end
		}

        t[#t+1] = Def.Sprite{
            Texture=THEME:GetPathG("Judgment","label"),
            Condition=GAMESTATE:Env()["gnNextScreen"] == "gnPlayerSettings",
            OnCommand=function(s)
                s:animate(0):xy( SCREEN_CENTER_X-240*side(pn), SCREEN_CENTER_Y-166 )
                :zoom( 0.75*DJS )
                :diffusealpha( DJO )
            end,
            DefaultJudgmentSizeChangeMessageCommand=function(s,param)
                if param.pn == pn and param.choice then
                    s:finishtweening():zoom( 0.75*(param.choice)/10 ) curzoom = (param.choice-1)/10 end
            end,
            DefaultJudgmentOpacityChangeMessageCommand=function(s,param)
                if param.pn == pn and param.choice then
                    s:diffusealpha( (param.choice-1)/10 ) end
            end,
        }

        t[#t+1] = Def.BitmapText{
            Font="_xenotron metal",
            Condition=GAMESTATE:Env()["gnNextScreen"] == "gnPlayerSettings",
            Text=math.random(50),
            OnCommand=function(s)
                s:animate(0):xy( SCREEN_CENTER_X-130*side(pn), SCREEN_CENTER_Y-166 )
                :zoom( 0.75*DCS )
            end,
            DefaultComboSizeChangeMessageCommand=function(s,param)
                if param.pn == pn and param.choice then
                    s:finishtweening():zoom( 0.75*(param.choice)/10 ) curzoom = (param.choice-1)/10 end
            end,
        }
end

t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathB("ScreenLogo","background/BGVid.mkv"),
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

t[#t+1] = LoadActor("../TotalPlaytime.lua")

return t;