local player = ...
assert(player)

local ach = LoadModule("GrooveNights.LevelCalculator.lua")(player)

------ GROOVENIGHTS LEVEL CALCULATION ------

-- All 17 Tiers
-- Beginner to Edit
-- Tier01 = Quad
-- Tier02 = Triple
-- Tier03 = Double
-- Tier04 = Single
-- Rest counts as SongsP1
local DataToCalculate = {"Beginner","Easy","Medium","Hard","Challenge"}

-- Achievement Icons
local Achievements = {
    5, -- SongCount
    8, -- ExpCount
    11, -- DeadCount
    14, -- StarCount
}

local total = {}

for i=1,4 do
	total["Tier"..string.format( "%02i", i )] = 0
	for v in ipairs(DataToCalculate) do
		total["Tier"..string.format( "%02i", i )] = total["Tier"..string.format( "%02i", i )] + PROFILEMAN:GetProfile(player):GetTotalStepsWithTopGrade("StepsType_Dance_Single",v,"Grade_Tier".. string.format( "%02i", i ) )
	end
end

local Calculations = {
	["StarCount"] = function()
		local totalstars = 0
		local achlevel = 0
		for i=1,4 do totalstars = totalstars + total["Tier"..string.format("%02i", i)] end
		for a,e in ipairs( Achievements[4][1] ) do
			if totalstars > e then achlevel = a end
		end
		return achlevel > 0 and string.format( "%04i", 14+(achlevel-1) ) or false
	end,
}

------ GROOVENIGHTS LEVEL CALCULATION ------

local t = Def.ActorFrame{
    OnCommand=function(s)
        local ymargin = player == PLAYER_1 and 30 or 130
        s:xy( SCREEN_CENTER_X+52, SCREEN_CENTER_Y+ymargin )
        :diffusealpha( GAMESTATE:IsPlayerEnabled(player) and 1 or 0 )
    end,
	PlayerJoinedMessageCommand=function(s)
		s:linear(0.2):diffusealpha( GAMESTATE:IsPlayerEnabled(player) and 1 or 0 )
		:sleep(0.1):queuecommand("BeginLoad")
	end,
	BeginLoadCommand=function(s) MESSAGEMAN:Broadcast("UpdateInfoPlayer") end,
}

-- Begin by drawing the overlay
t[#t+1] = Def.Sprite{ Texture="PaneDisplay level2" }
-- Ok, base drawing done, time for profile picture.
t[#t+1] = Def.Sprite {
    Texture=LoadModule("Options.GetProfileData.lua")(player)["Image"];
    OnCommand=function(s)
        s:xy(-114,0)
        :setsize(70,70)
	end,
	UpdateInfoPlayerMessageCommand=function(s)
		s:Load( LoadModule("Options.GetProfileData.lua")(player)["Image"] )
		:setsize(70,70)
	end,
};
if PROFILEMAN:GetProfile(player):GetDisplayName() ~= "" then
	t[#t+1] = Def.Quad {
		OnCommand=function(s) s:zoomto(70,70):x(-114):croptop(0.7):fadetop(0.1):diffuse(Color.Black) end,
	}
end
t[#t+1] = Def.BitmapText {
	Font="_eurostile normal",
	Text=PROFILEMAN:GetProfile(player):GetDisplayName(),
    OnCommand=function(s)
        s:xy(-114,22):zoom(0.5):diffuse( PlayerColor(player) )
	end,
	PlayerJoinedMessageCommand=function(s)
		if PROFILEMAN:GetProfile(player):GetDisplayName() == "" then
			s:settext("Loading...")
		end
	end,
	UpdateInfoPlayerMessageCommand=function(s)
		s:settext( PROFILEMAN:GetProfile(player):GetDisplayName() )
	end,
};

t[#t+1] = Def.Sprite{ Texture="PaneDisplay level1" }

	local StepsOrCourse = function() return GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(player) or GAMESTATE:GetCurrentSteps(player) end
	local ObtainData = {
		--LEFT SIDE
		{
			{"Steps", function() return StepsOrCourse() and LoadModule("Pane.RadarValue.lua")(player, 5) or 0 end },
			{"Holds", function() return StepsOrCourse() and LoadModule("Pane.RadarValue.lua")(player, 8) or 0 end },
			{function() return LoadModule("Pane.PercentScore.lua")(player)[2] end, function() return LoadModule("Pane.PercentScore.lua")(player)[1] end },
			{"Card", function() return LoadModule("Pane.PercentScore.lua")(player)[1] end },
			xpos = {-75,0},
		},
		--RIGHT SIDE
		{
			{"Jumps", function() return StepsOrCourse() and LoadModule("Pane.RadarValue.lua")(player, 7) or 0 end },
			{"Mines", function() return StepsOrCourse() and LoadModule("Pane.RadarValue.lua")(player, 9) or 0 end },
			{"Hands", function() return StepsOrCourse() and LoadModule("Pane.RadarValue.lua")(player, 10) or 0 end },
			{"Rolls", function() return StepsOrCourse() and LoadModule("Pane.RadarValue.lua")(player, 11) or 0 end },
			xpos = {10,80},
		},
		DiffPlacement = 120
	}
	for ind,content in ipairs(ObtainData) do
		for vind,val in ipairs( ObtainData[ind] ) do
			t[#t+1] = Def.BitmapText{
				Font="_eurostile normal",
				Text=val[1],
				InitCommand=function(s)
					s:zoom(0.5):xy(
						ObtainData[ind].xpos[1] + 0
						,-24+14*(vind-1)):halign(0)
				end;
				["CurrentSteps"..ToEnumShortString(player).."ChangedMessageCommand"]=function(s)
                    -- replace
					if GAMESTATE:GetCurrentSteps(player) and val[1] and type(val[1]) == "function" then
						s:settext( val[1]() )
					end
				end;
			};
			t[#t+1] = Def.BitmapText{
				Font="_eurostile normal",
				Text=val[2],
				InitCommand=function(s)
					s:zoom(0.5):xy(
						ObtainData[ind].xpos[2] + 0
                        ,-24+14*(vind-1)
                    ):halign(1)
                end,
                CurrentSongChangedMessageCommand=function(s)
                    if not GAMESTATE:GetCurrentSong() then
                        s:settext("?")
                    end
                end,
                ["CurrentSteps"..ToEnumShortString(player).."ChangedMessageCommand"]=function(s)
					if GAMESTATE:GetCurrentSteps(player) and val[2] then
						s:settext( val[2]() )
					end
				end,
			};
		end
    end
    t[#t+1] = Def.BitmapText{
		Font="_eurostile normal",
		InitCommand=function(self) self:x(ObtainData.DiffPlacement):y(12):maxwidth(90):zoom(0.6) end;
		["CurrentSteps"..ToEnumShortString(player).."ChangedMessageCommand"]=function(s)
		if StepsOrCourse() then
			s:settext(
				THEME:GetString("Difficulty", ToEnumShortString( StepsOrCourse():GetDifficulty() ) )
			)
			:diffuse( DifficultyColor( StepsOrCourse():GetDifficulty() ) )
		end
	end
    };

    t[#t+1] = Def.BitmapText{
        Font="_eurostile normal",
        Text="Step Artist",
		InitCommand=function(self) self:x(ObtainData.DiffPlacement):y(-24):maxwidth(120):zoom(0.53):diffuse(color("0.6,0.8,0.9,1")) end;
	};
    
    t[#t+1] = Def.BitmapText{
		Font="_eurostile normal",
		InitCommand=function(self) self:x(ObtainData.DiffPlacement):y(-9):maxwidth(110):zoom(0.56) end;
		["CurrentSteps"..ToEnumShortString(player).."ChangedMessageCommand"]=function(s)
        if StepsOrCourse() then
            s:settext(
                GAMESTATE:GetCurrentSteps(player):GetAuthorCredit() and GAMESTATE:GetCurrentSteps(player):GetAuthorCredit()
                or GAMESTATE:GetCurrentSteps(player):GetDescription()
            )
		end
	end
};

-- Level & Progress Stats --
t[#t+1] = Def.ActorFrame{
    OnCommand=function(s)
        s:xy( 206, -38 )
	end,
	-- Level Indicator
	Def.BitmapText{
		Font="Common Normal",
		OnCommand=function(s)
			s:halign(0):xy( -38, -12 ):zoom(0.5)
			s:settext( "Level ".. ach[3] )
		end,
	},
	Def.BitmapText{
		Condition=LoadModule("Config.Load.lua")("ToggleEXPCounter","Save/GrooveNightsPrefs.ini"),
		Font="Common Normal",
		OnCommand=function(s)
			s:halign(1):xy( 48, -11 ):zoom(0.3)
			s:settext( "(".. math.floor(ach[2]).."/".. math.floor(ach[4]) ..")" )
		end,
	},
    Def.Quad{ OnCommand=function(s) s:diffuse( color("0.1,0.1,0.1,1") ):zoomto(90,4):xy(4,-2) end, },
	Def.Quad{ OnCommand=function(s) s:diffuse( color("0.6,0.8,0.9,1") ):zoomto(90,4):xy(4,-2)
		:cropright( (100-ach[1])/100 ) end, },
    Def.Sprite{ Texture=THEME:GetPathG("","EXP/expBar") },
}

for _,v in pairs(Achievements) do
    t[#t+1] = Def.Sprite{
        Texture=THEME:GetPathG("",ach.Achievements[_] > 0 and "achievements/achievement".. string.format("%04i",(v-1)+ach.Achievements[_]) or "_blank" ),
        OnCommand=function(s)
			s:xy( 174 + (24 * (_-1)), 16 ):zoom(0.8)
        end,
    }
end

-- Now show the achieved scores
for i=1,4 do
	t[#t+1] = Def.Sprite{
        Texture=THEME:GetPathG("","achievements/achievement".. string.format( "%04i", i )),
        OnCommand=function(s)
            s:xy( 174 + (24 * (i-1)), -24 ):zoom(0.8)
        end,
	}
	t[#t+1] = Def.BitmapText{
		Font="_eurostile normal",
		Text=total["Tier"..string.format( "%02i", i )],
        OnCommand=function(s)
            s:xy( 174 + (24 * (i-1)), -6 ):zoom(0.6)
		end,
		UpdateInfoPlayerMessageCommand=function(s)
			if PROFILEMAN:GetProfile(player) and PROFILEMAN:IsPersistentProfile(player) then
				for i=1,4 do
					total["Tier"..string.format( "%02i", i )] = 0
					for v in ipairs(DataToCalculate) do
						total["Tier"..string.format( "%02i", i )] = total["Tier"..string.format( "%02i", i )] + PROFILEMAN:GetProfile(player):GetTotalStepsWithTopGrade("StepsType_Dance_Single",v,"Grade_Tier".. string.format( "%02i", i ) )
					end
				end
				s:settext( total["Tier"..string.format( "%02i", i )] )
			end
		end
    }
end

return t;