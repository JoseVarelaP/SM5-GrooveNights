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
	end
}

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
	Condition=GAMESTATE:IsPlayerEnabled(player),
		LoadActor( THEME:GetPathG("","ScreenEvaluation grade frame"), player )..{
		InitCommand=function(self)
			self:xy( DoublesIsOn and SCREEN_CENTER_X or ( SCREEN_CENTER_X+((-130*1.2)*side(player)) ),SCREEN_CENTER_Y+58)
			if GAMESTATE:Env()["UsingBOA"] then
				self:tween(0.5,"easeoutquad"):x( SCREEN_CENTER_X ):diffusealpha( GAMESTATE:GetMasterPlayerNumber() == player and 1 or 0 )
			end
		end
		}
	}
end

t[#t+1] = loadfile( THEME:GetPathB("ScreenWithMenuElements","overlay") )()

t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:x( DoublesIsOn and SCREEN_CENTER_X+80 or SCREEN_CENTER_X )
		if GAMESTATE:Env()["UsingBOA"] then
			self:tween(0.5,"easeoutquad"):x( SCREEN_CENTER_X+90 )
		end
	end,
	Def.Sprite{
		Texture=THEME:GetPathG("Common fallback","banner"),
		InitCommand=function(self)
			self:y(SCREEN_CENTER_Y-114)
			if GAMESTATE:IsCourseMode() then
				self:Load( GAMESTATE:GetCurrentCourse():GetBannerPath() )
			else
				if GAMESTATE:GetCurrentSong():GetBannerPath() ~= nil then 
					self:Load( GAMESTATE:GetCurrentSong():GetBannerPath() )
				end
				for pn in ivalues(PlayerNumber) do
					if GAMESTATE:GetCurrentSong():GetGroupName() == PROFILEMAN:GetProfile(pn):GetDisplayName() then
						self:Load( THEME:GetPathG("Banner","custom") )
					end
				end
			end
		end,
		OnCommand=function(self)
			self:scaletoclipped( 418/2,130/2):ztest(1)
		end
	},

	Def.BitmapText{
		Font="Common Normal",
		OnCommand=function(self)
			self:y(SCREEN_CENTER_Y-178):zoom(0.75):maxwidth(450)
			if GAMESTATE:GetCurrentSong() then
				self:settext( GAMESTATE:GetCurrentSong():GetDisplayMainTitle() )
			end
		end
	},

	Def.BitmapText{
		Font="novamono/36/_novamono 36px",
		OnCommand=function(self)
			self:y( SCREEN_CENTER_Y-162 ):zoom(0.5):maxwidth(450)
			if GAMESTATE:GetCurrentSong() then
				self:settext( GAMESTATE:GetCurrentSong():GetDisplayArtist() )
			end
		end
	},

	Def.Sprite{
		Texture=THEME:GetPathG("ScreenEvaluation Banner","Frame"),
		OnCommand=function(self)
			self:y( SCREEN_CENTER_Y-112 )
		end
	}
}

t[#t+1] = LoadActor("TotalPlaytime.lua")

t[#t+1] = Def.HelpDisplay {
	File="Common Normal",
	OnCommand=function(self)
		self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+198):zoom(0.75):strokecolor(Color.Black):diffuseblink()
	end,
	InitCommand=function(self)
		self:SetSecsBetweenSwitches(THEME:GetMetric("HelpDisplay","TipSwitchTime"))
		:SetTipsColonSeparated( LoadModule("Text.GenerateHelpText.lua")( {"HelpTextNormal","PageText","TakeScreenshotHelpTextAppend"} ) )
	end,
	SetHelpTextCommand=function(self, params) self:SetTipsColonSeparated( params.Text ) end,
	SelectMenuOpenedMessageCommand=function(self) self:stoptweening():decelerate(0.2):zoomy(0) end,
	SelectMenuClosedMessageCommand=function(self) self:stoptweening():bouncebegin(0.2):zoomy(0.75) end
}

return t