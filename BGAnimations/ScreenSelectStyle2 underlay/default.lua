local Choices = {
	{
		Video = "1player",
		--Description = "One Player uses 4 panels",
		--Grandpa = "play once",
		Available = function( pnm )
			return GAMESTATE:GetNumPlayersEnabled() == 1
		end
	},
	{
		Video = "2player",
		--Description = "Two Players, each uses 4 panels",
		--Grandpa = "play twice",
		Available = function( pnm )
			local CanJoin = true

			if (GAMESTATE:GetNumPlayersEnabled() < 2 and not GAMESTATE:PlayersCanJoin()) then CanJoin = false end

			return CanJoin
		end
	},
	{
		Video = "double",
		--Description = "One Player uses all 8 panels",
		--Grandpa = "play once then twice",
		Available = function( pnm )
			--local coins = GAMESTATE:GetCoins()
			--local coinsPerCredit = PREFSMAN:GetPreference("CoinsPerCredit")
			local remaining = GAMESTATE:GetCoinsNeededToJoin()
			local CanJoin = true

			if (GAMESTATE:GetNumPlayersEnabled() < 2 and not GAMESTATE:PlayersCanJoin()) then CanJoin = false end
			if GAMESTATE:GetPremium() == "Premium_Off" then CanJoin = false end
			if GAMESTATE:GetCoinMode() == "CoinMode_Pay" and remaining ~= 0 then CanJoin = false end

			--if GAMESTATE:GetPremium() ~= "Premium_Off" and not (GAMESTATE:GetCoinMode() ~= "CoinMode_Pay" or GAMESTATE:IsEventMode())
			--(GAMESTATE:GetCoinMode() == COIN_MODE_FREE or GAMESTATE:GetCoinMode() == COIN_MODE_HOME or GAMESTATE:IsEventMode())
			
			return CanJoin
		end
	}
}

local snm = Var "LoadingScreen"
local curchoice = 0
local t = Def.ActorFrame{
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback( LoadModule("Lua.InputSystem.lua")(self) )
		GAMESTATE:JoinPlayer(0)
		GAMESTATE:UnjoinPlayer(1)
		self:playcommand("UpdateArea",{Val=1})
		SCREENMAN:GetTopScreen():SetAllowLateJoin(true)
	end,
	MenuLeftCommand=function(self)
		self:playcommand("UpdateArea",{Val=-1})
	end,
	MenuRightCommand=function(self)
		self:playcommand("UpdateArea",{Val=1})
	end,
	PlayerJoinedMessageCommand=function(self)
		self:playcommand("UpdateArea",{Val=1})
	end,
	UpdateAreaCommand=function(self,param)
		local og = curchoice
		curchoice = curchoice + param.Val

		if curchoice > #Choices then curchoice = 1 end
		if curchoice < 1 then curchoice = #Choices end

		-- We may have locked options, so move on to the next available space.
		while( not Choices[curchoice].Available() ) do
			curchoice = curchoice + param.Val

			-- Wrap around again if it's the case.
			if curchoice > #Choices then curchoice = 1 end
			if curchoice < 1 then curchoice = #Choices end

			-- Check if now the next option is available.
			if Choices[curchoice].Available() then
				break
			end
		end

		--local needschange = og ~= curchoice

		if og ~= curchoice then
			-- Update the current video preview with the new choice.
			self:GetChild("VideoLoader"):playcommand("NewVid", { Video = THEME:GetPathB("ScreenSelectStyle2","underlay/video_".. Choices[curchoice].Video) })
			self:GetChild("Description"):settext(
				THEME:GetString( snm, Choices[curchoice].Video .. (GAMESTATE:Env()["AngryGrandpa"] and "Grandpa" or "Description") )
			)

			self:GetChild("Scroller"):playcommand("UpdateCur")
		end
	end,
	StartCommand=function(self)
		-- If the player is not available, perform a series of checks to see if it's capable of joining.
		if not GAMESTATE:IsPlayerEnabled(self.pn) then
			local remaining = GAMESTATE:GetCoinsNeededToJoin()

			if remaining == 0 or GAMESTATE:PlayersCanJoin() then
				GAMESTATE:JoinPlayer(self.pn)
			end
		else
			GAMESTATE:SetCurrentStyle( "single" )
			SCREENMAN:GetTopScreen():StartTransitioningScreen( "SM_GoToNextScreen" )
		end
	end,
	BackCommand=function(self)
		SCREENMAN:GetTopScreen():StartTransitioningScreen( "SM_GoToPrevScreen" )
	end
}

-- t[#t+1] = LoadActor("_shared underlay arrows")

t[#t+1] = Def.Quad{
	OnCommand=function(self)
		self:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y-80 ):diffuse(Color.Black):zoomto(264,210)
	end
}

t[#t+1] = Def.Sprite{
	Name="VideoLoader",
	InitCommand=function(self)
		self:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y-76 )
		:z(-100):zoomto( 0.85,0.85 )
	end,
	NewVidCommand=function(self,param)
		self:finishtweening():glow(color("1,1,1,0.5")):linear(0.3):glow(color("1,1,1,0")):Load( param.Video )
	end
}

-- Scroller time
local Scroller = Def.ActorFrame{ Name="Scroller", InitCommand=function(self) self:xy( SCREEN_CENTER_X,SCREEN_CENTER_Y+12+70 ) end }

for k,v in pairs( Choices ) do
	Scroller[#Scroller+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:zoom(0.5):x(scale( k, 1 , #Choices, -(640*.325), (640*.325) ))
			self:GetChild("Lock"):zoom(1)
		end,
		UpdateCurCommand=function(self)
			self:stoptweening():tween(0.3,"easeoutcubic"):zoom( curchoice == k and 0.6 or 0.5 )
		end,
		Def.Sprite{
			Name="ModeGraphic", Texture=THEME:GetPathG("Select","Style/".. v.Video),
			UpdateCurCommand=function(self)
				self:stoptweening():tween(0.1,"linear"):diffuse( v.Available() and Color.White or ColorDarkTone(Color.White) )
			end
		},
		Def.Sprite{
			Name="Lock", Texture=THEME:GetPathG("Select","Style/Lock"),
			UpdateCurCommand=function(self)
				self:stoptweening():tween(0.5,"easeoutelastic"):zoom(1):diffusealpha( v.Available() and 0 or 1 )
			end
		},
	}
end

t[#t+1] = Scroller

t[#t+1] = Def.Sprite{
	Texture="previewframe",
	OnCommand=function(self)
		self:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y ):diffuse( color("#1C2C3C") )
	end
}

t[#t+1] = Def.Sprite{
	Texture="explanation frame B",
	OnCommand=function(self)
		self:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y-11 ):diffuse( color("#060A0E") )
	end
}

t[#t+1] = Def.Sprite{
	Texture="explanation frame F",
	OnCommand=function(self)
		self:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y-11 ):diffuse( color("#1C2C3C") )
	end
}

t[#t+1] = Def.BitmapText{
	Font="novamono/36/_novamono 36px",
	Name="Description",
	OnCommand=function(self)
		self:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y+142 ):strokecolor(Color.Black)
	end
}

t[#t+1] = Def.HelpDisplay {
	File="novamono/36/_novamono 36px",
	OnCommand=function(s)
        s:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y+198):zoom(0.75):diffuseblink()
	end,
    InitCommand=function(s)
		s:SetSecsBetweenSwitches(THEME:GetMetric("HelpDisplay","TipSwitchTime"))
		:SetTipsColonSeparated( LoadModule("Text.GenerateHelpText.lua")( {"HelpTextNormal"} ) )
	end,
	SetHelpTextCommand=function(s, params) s:SetTipsColonSeparated( params.Text ) end,
	SelectMenuOpenedMessageCommand=function(s) s:stoptweening():decelerate(0.2):zoomy(0) end,
	SelectMenuClosedMessageCommand=function(s) s:stoptweening():bouncebegin(0.2):zoomy(0.75) end
}

return t