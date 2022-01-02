local Strings = {
	UsingCard = Screen.String("UsingCard"),
	JoinText = Screen.String("JoinText"),
	ConfirmText = Screen.String("ConfirmText"),
}

function GetLocalProfiles()
	local t = {}

	local function GetSongsPlayedString(numSongs)
		return numSongs == 1 and Screen.String("SingularSongPlayed") or Screen.String("SeveralSongsPlayed")
	end

	for p = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
		local profile=PROFILEMAN:GetLocalProfileFromIndex(p)
		local ProfileCard = Def.ActorFrame {
			LoadFont("Common Normal") .. {
				Text=profile:GetDisplayName(),
				InitCommand= function (self)
					self:y(0):zoom(0.8):ztest(true):maxwidth(160)
				end
			}
		}
		t[#t+1]=ProfileCard
	end

	return t
end

function LoadPlayerStuff(Player)
	local t = {}

	local pn = (Player == PLAYER_1) and 1 or 2

	t[#t+1] = Def.Sprite{
		Name="FrameB",
		Texture=THEME:GetPathG("ScreenEvaluation grade frame/base frame","B"),
		OnCommand=function(self)
			self:diffuse(color("#060A0E")):fadebottom(.2)
		end
	}
	t[#t+1] = Def.Sprite{
		Name="FrameF",
		Texture=THEME:GetPathG("ScreenEvaluation grade frame/base frame","F"),
		OnCommand=function(self)
			self:diffuse(color("#1C2C3C")):fadebottom(.2)
		end
	}

	t[#t+1] = Def.ActorFrame {
		Name = 'JoinFrame',

		LoadFont("Common Normal") .. {
			Name="JoinText",
			InitCommand= function (self)
				self:shadowlength(1)
			end,
			OnCommand= function (self)
				self:diffuseshift():effectcolor1(Color('White')):effectcolor2(color("0.5,0.5,0.5"))
			end
		}
	}
	
	t[#t+1] = Def.ActorFrame {
		Name = 'SmallFrame',
		InitCommand= function (self)
			self:xy(68,-20):zoom(0.74)
		end,
		Def.Quad {
			InitCommand= function (self)
				self:zoomto(190, 42)
			end,
			OnCommand= function (self)
				self:diffuse(Color('Black')):diffusealpha(0.5)
			end
		},
		Def.Quad {
			InitCommand= function (self)
				self:zoomto(190, 40)
			end,
			OnCommand= function (self)
				self:diffuse(PlayerColor(Player)):fadeleft(0.25):faderight(0.25):glow(color("1,1,1,0.25"))
			end
		},
		Def.Quad {
			InitCommand= function (self)
				self:zoomto(190, 40):y(0)
			end,
			OnCommand= function (self)
				self:diffuse(Color("Black")):fadebottom(1):diffusealpha(0.35)
			end
		},
		Def.Quad {
			InitCommand= function (self)
				self:zoomto(190, 1):y(-19)
			end,
			OnCommand= function (self)
				self:diffuse(PlayerColor(Player)):glow(color("1,1,1,0.25"))
			end
		}
	}

	t[#t+1] = Def.ActorFrame{
		Name = "MemoryCardIcon",
		InitCommand=function(self)
			self:xy( -80, 80 ):zoom(1.4):diffusealpha(0)
		end,
		Def.Sprite{
			Name = "Graphic",
			Texture = THEME:GetPathG("MemoryCardDisplay ready", string.sub(Player, -2) ),
			InitCommand=function(self)
				self:rotationz( math.random(40) )
			end
		}
	}

	t[#t+1] = Def.ActorScroller{
		Name = 'Scroller',
		NumItemsToDraw=6,
		OnCommand= function (self)
			self:xy(68,-26):SetFastCatchup(true):SetMask(200, 80):SetSecondsPerItem(0.15)
		end,
		TransformFunction=function(self, offset, itemIndex, numItems)
			self:y(math.floor( offset*40 ))
		end,
		children = GetLocalProfiles()
	}
	
	t[#t+1] = LoadFont("Common Normal") .. {
		Name = 'SelectedProfileText',
		InitCommand= function (self)
			self:y(100):shadowlength(1)
		end
	}

	return t
end

function UpdateInternal3(self, Player)
	local pn = tonumber( string.sub( Player, -1 ) )
	local frame = self:GetChild(string.format('P%uFrame', pn))
	local scroller = frame:GetChild('Scroller')
	local seltext = frame:GetChild('SelectedProfileText')
	local joinframe = frame:GetChild('JoinFrame')
	local smallframe = frame:GetChild('SmallFrame')

	local isHuman = GAMESTATE:IsHumanPlayer(Player)
	local isUsingCard = MEMCARDMAN:GetCardState(Player) ~= 'MemoryCardState_none'

	if isHuman and isUsingCard then
		--self:GetChild("CardAvailable"):play()
		frame:GetChild("FrameB"):stoptweening():easeoutexpo(0.4):croptop(0.77)
		frame:GetChild("FrameF"):stoptweening():easeoutexpo(0.4):croptop(0.77)
		seltext:stoptweening():easeoutexpo(0.4):x(50):zoom(0.8)
	end

	frame:stoptweening():easeoutexpo(0.4):y( SCREEN_CENTER_Y + ((isHuman and isUsingCard) and -60 or 0) )
	--frame:visible( isHuman )

	joinframe:visible( not isHuman or isUsingCard )
	smallframe:visible( isHuman and not isUsingCard )
	seltext:visible( isHuman )
	scroller:visible( isHuman and not isUsingCard )
	joinframe:GetChild("JoinText"):settext( Strings.JoinText )

	if GAMESTATE:IsHumanPlayer(Player) then
		if MEMCARDMAN:GetCardState(Player) == 'MemoryCardState_none' then
			local ind = SCREENMAN:GetTopScreen():GetProfileIndex(Player)
			if ind > 0 then
				scroller:SetDestinationItem(ind-1)
				seltext:settext(PROFILEMAN:GetLocalProfileFromIndex(ind-1):GetDisplayName())
			else
				if SCREENMAN:GetTopScreen():SetProfileIndex(Player, 1) then
					scroller:SetDestinationItem(0)
					self:queuecommand('UpdateInternal2')
				else
					seltext:settext('No profile')
				end
			end
		else
			joinframe:GetChild("JoinText"):settext( Strings.ConfirmText )
			seltext:settext( Strings.UsingCard )
			SCREENMAN:GetTopScreen():SetProfileIndex(Player, 0)
		end
	end
end

local PlayerFrames = Def.ActorFrame{}

local t = Def.ActorFrame {

	StorageDevicesChangedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2')
	end,

	CodeMessageCommand = function(self, params)
		if params.Name == 'Start' or params.Name == 'Center' then
			MESSAGEMAN:Broadcast("StartButton")
			if not GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, -1)

				local isHuman = GAMESTATE:IsHumanPlayer(params.PlayerNumber)
				local isUsingCard = MEMCARDMAN:GetCardState(params.PlayerNumber) ~= 'MemoryCardState_none'

				if isHuman and isUsingCard then
					local pn = tonumber( string.sub( params.PlayerNumber, -1 ) )
					local frame = self:GetChild(string.format('P%uFrame', pn))
					local seltext = frame:GetChild('SelectedProfileText')
					self:GetChild("CardAvailable"):play()
					frame:GetChild("FrameB"):stoptweening():easeoutexpo(0.4):croptop(0.77)
					frame:GetChild("FrameF"):stoptweening():easeoutexpo(0.4):croptop(0.77)
					seltext:stoptweening():easeoutexpo(0.4):x(50):zoom(0.8)
					frame:GetChild("MemoryCardIcon"):stoptweening():y(80):easeoutbounce(0.8):diffusealpha(1):y( 106 )
					frame:GetChild("MemoryCardIcon"):GetChild("Graphic"):stoptweening():easeoutbounce(0.8):rotationz( 0 )
				end
			else
				SCREENMAN:GetTopScreen():Finish()
			end
		end
		if params.Name == 'Up' or params.Name == 'Up2' or params.Name == 'DownLeft' then
			if GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(params.PlayerNumber)
				if ind > 1 then
					if SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, ind - 1 ) then
						MESSAGEMAN:Broadcast("DirectionButton")
						self:queuecommand('UpdateInternal2')
					end
				end
			end
		end
		if params.Name == 'Down' or params.Name == 'Down2' or params.Name == 'DownRight' then
			if GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(params.PlayerNumber)
				if ind > 0 then
					if SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, ind + 1 ) then
						MESSAGEMAN:Broadcast("DirectionButton")
						self:queuecommand('UpdateInternal2')
					end
				end
			end
		end
		if params.Name == 'Back' then
			if GAMESTATE:GetNumPlayersEnabled()==0 then
				SCREENMAN:GetTopScreen():Cancel()
			else
				MESSAGEMAN:Broadcast("BackButton")
				local pn = tonumber( string.sub( params.PlayerNumber, -1 ) )
				local frame = self:GetChild(string.format('P%uFrame', pn))
				frame:GetChild("FrameB"):stoptweening():easeinoutexpo(0.4):croptop(0)
				frame:GetChild("FrameF"):stoptweening():easeinoutexpo(0.4):croptop(0)
				frame:GetChild("MemoryCardIcon"):stoptweening():easeoutexpo(0.8):diffusealpha(1):y( 120 ):diffusealpha(0)
				frame:GetChild("MemoryCardIcon"):GetChild("Graphic"):stoptweening():easeoutexpo(0.8):rotationz( math.random(20) )
				SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, -2)
			end
		end
	end,

	PlayerJoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2')
	end,
	PlayerUnjoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2')
	end,
	OnCommand=function(self, params)
		self:queuecommand('UpdateInternal2')
	end,
	UpdateInternal2Command=function(self)
		UpdateInternal3(self, PLAYER_1)
		UpdateInternal3(self, PLAYER_2)
	end,

	children = {
		-- sounds
		LoadActor( THEME:GetPathS("Common","start") )..{ StartButtonMessageCommand=function (self) self:play() end },
		LoadActor( THEME:GetPathS("MemoryCardManager","ready") )..{ Name="CardAvailable" },
		LoadActor( THEME:GetPathS("MemoryCardManager","disconnect") )..{ BackButtonMessageCommand= function (self) self:play() end },
		LoadActor( THEME:GetPathS("_change","value") )..{ DirectionButtonMessageCommand= function (self) self:play() end }
	}
}

for i,Player in pairs( PlayerNumber ) do
	local pn = tonumber( string.sub( Player, -1 ) )
	t.children[#t.children+1] = Def.ActorFrame {
		Name = string.format('P%uFrame', pn),
		InitCommand= function (self)
			self:xy(SCREEN_CENTER_X + (160 * (Player == PLAYER_2 and 1 or -1)), SCREEN_CENTER_Y)
		end,
		OnCommand= function (self)
			local isHuman = GAMESTATE:IsHumanPlayer(Player)
			local isUsingCard = MEMCARDMAN:GetCardState(Player) ~= 'MemoryCardState_none'
			local pn = tonumber( string.sub( Player, -1 ) )
			local seltext = self:GetChild('SelectedProfileText')
			self:GetChild('Scroller'):visible( isHuman and not isUsingCard )
			self:GetChild('SmallFrame'):visible( isHuman and not isUsingCard )
			if isHuman and isUsingCard then
				--self:GetChild("CardAvailable"):play()
				seltext:stoptweening():easeoutexpo(0.4):x(50):zoom(0.8)
				self:GetChild("MemoryCardIcon"):stoptweening():y(80):easeoutbounce(0.8):diffusealpha(1):y( 106 )
				self:GetChild("MemoryCardIcon"):GetChild("Graphic"):stoptweening():easeoutbounce(0.8):rotationz( 0 )
			end
		end,
		OffCommand= function (self)
			self:bouncebegin(0.35):zoom(0)
		end,
		PlayerJoinedMessageCommand=function(self,param)
		end,
		children = LoadPlayerStuff(Player)
	}
end

return t
