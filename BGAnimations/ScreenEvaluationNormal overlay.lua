-- Time to insert a mapper.
-- This is used to track the player's inputs so we can use a lua screen.
local pageIndex = { ["PlayerNumber_P1"] = 1, ["PlayerNumber_P2"] = 1 }
local function ChangeOffset(player, index)
	pageIndex[player] = pageIndex[player] + index
	local changed = true
	if pageIndex[player] > 2 then pageIndex[player] = 2 changed = false end
	if pageIndex[player] < 1 then pageIndex[player] = 1 changed = false end
	if changed then
		-- SOUND:PlayOnce()
		MESSAGEMAN:Broadcast("EvaluationInputChanged",{ Player=player, Index=pageIndex[player] })
	end
end

local Actions = {
	["MenuLeft"] = function(player) ChangeOffset(player, -1) end,
	["MenuRight"] = function(player) ChangeOffset(player, 1) end,
}
local function Mapper(event)
	if not event.PlayerNumber then return end
	local ET = ToEnumShortString(event.type)
	-- Input that occurs at the moment the button is pressed.
	if ET == "FirstPress" or ET == "Repeat" then
		if Actions[event.GameButton] then Actions[event.GameButton](event.PlayerNumber) end
	end
	return
end

local t = Def.ActorFrame{
	OnCommand=function(s)
		SCREENMAN:GetTopScreen():AddInputCallback(Mapper)
	end,
};

local function side(pn)
	local s = 1
	if pn == PLAYER_1 then return s end
	return s*(-1)
end

local function Gradeside(pn)
	local s = -230 if pn == PLAYER_2 then s = 56 end
	return s
end

local function pnum(pn)
	if pn == PLAYER_2 then return 2 end
	return 1
end

-- Grade and Frame Info
local DoublesIsOn = GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides"
for player in ivalues( GAMESTATE:GetEnabledPlayers() ) do
	t[#t+1] = Def.ActorFrame{
	Condition=GAMESTATE:IsPlayerEnabled(player);
		LoadActor( THEME:GetPathG("","ScreenEvaluation grade frame"), player )..{
		InitCommand=function(self)
		self:xy( DoublesIsOn and SCREEN_CENTER_X or ( SCREEN_CENTER_X+((-130*1.2)*side(player)) ),SCREEN_CENTER_Y+58)
		end,
		};
	};
end

t[#t+1] = loadfile( THEME:GetPathB("ScreenWithMenuElements","overlay") )()

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s) s:x( DoublesIsOn and SCREEN_CENTER_X+80 or SCREEN_CENTER_X ) end,
	Def.Sprite{
		Texture=THEME:GetPathG("Common fallback","banner"),
		InitCommand=function(s) s:y(SCREEN_CENTER_Y-114)
		if GAMESTATE:IsCourseMode() then
			s:Load( GAMESTATE:GetCurrentCourse():GetBannerPath() )
		else
			if GAMESTATE:GetCurrentSong():GetBannerPath() ~= nil then 
				s:Load( GAMESTATE:GetCurrentSong():GetBannerPath() )
			end
			for pn in ivalues(PlayerNumber) do
				if GAMESTATE:GetCurrentSong():GetGroupName() == PROFILEMAN:GetProfile(pn):GetDisplayName() then
					s:Load( THEME:GetPathG("Banner","custom") )
				end
			end
		end
		end,
		OnCommand=function(s)
			s:scaletoclipped( 418/2,130/2):ztest(1)
		end;
	},

	Def.BitmapText{
		Font="_eurostile blue glow",
		OnCommand=function(s)
			s:y(SCREEN_CENTER_Y-168-6)
			:zoom(0.75):maxwidth(450)
			if GAMESTATE:GetCurrentSong() then
				s:settext( GAMESTATE:GetCurrentSong():GetDisplayMainTitle() )
			end
		end,
	},

	Def.BitmapText{
		Font="_eurostile blue glow",
		OnCommand=function(s)
			s:y( SCREEN_CENTER_Y-150-8 )
			:zoom(0.5):maxwidth(450)
			if GAMESTATE:GetCurrentSong() then
				s:settext( GAMESTATE:GetCurrentSong():GetDisplayArtist() )
			end
		end,
	},

	Def.Sprite{
		Texture=THEME:GetPathG("ScreenEvaluation Banner","Frame"),
		OnCommand=function(s)
			s:y( SCREEN_CENTER_Y-112 )
		end,
	}
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

t[#t+1] = Def.BitmapText{
	Font="_eurostile normal",
	Condition=LoadModule("Config.Load.lua")("ToggleTotalPlayTime","Save/GrooveNightsPrefs.ini"),
    InitCommand=function(s)
        s:xy( SCREEN_CENTER_X, SCREEN_BOTTOM-10 ):zoom(0.6)
		:playcommand("Update")
    end,
    UpdateCommand=function(s)
        local pn = GAMESTATE:GetMasterPlayerNumber()
        local TotalTime = STATSMAN:GetAccumPlayedStageStats(pn):GetGameplaySeconds()
        local TimeRightNow = STATSMAN:GetCurStageStats(pn):GetPlayerStageStats(pn):GetAliveSeconds()
        local Comtp = SecondsToHHMMSS(TotalTime+TimeRightNow)
        local SongsCount = " ("..STATSMAN:GetStagesPlayed().." songs)"
        s:finishtweening()
        s:settext( "Total PlayTime: ".. Comtp ..  SongsCount  )
        s:AddAttribute(0, {
            Length=string.len(s:GetText())-(string.len(Comtp)+string.len(SongsCount));
			Diffuse=color("#FFA314") }
		)
    end,
}

t[#t+1] = Def.HelpDisplay {
	File="_eurostile normal",
	OnCommand=function(s)
		s:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y+204):zoom(0.75):diffuseblink()
	end,
	InitCommand=function(s)
		local str = THEME:GetString("ScreenEvaluation","HelpTextNormal") .. "::" ..
			THEME:GetString("ScreenEvaluation","PageText") .. "::" ..
			THEME:GetString("ScreenEvaluation","TakeScreenshotHelpTextAppend")
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

return t;