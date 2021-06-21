local ExitSelect = {
	[PLAYER_1] = false,
	[PLAYER_2] = false
}
local t = Def.ActorFrame{
	BeginCommand=function(s)
		local screen = SCREENMAN:GetTopScreen():GetName()
		s:y( THEME:GetMetric(screen,"SeparateExitRowY") )
	end
	--CancelMessageCommand=function(s) s:playcommand("Off") end;
}

for player in ivalues(PlayerNumber) do
	t[#t+1] = Def.Actor{
		["ExitSelected".. ToEnumShortString(player) .."Command"]=function(s)
			if GAMESTATE:IsPlayerEnabled(player) then
				ExitSelect[ player ] = true
				MESSAGEMAN:Broadcast("ExitSelected".. ToEnumShortString(player) )
				MESSAGEMAN:Broadcast("TweenCheck")
			end
		end,
		["ExitUnselected".. ToEnumShortString(player) .."Command"]=function(s)
			if GAMESTATE:IsPlayerEnabled(player) then
				ExitSelect[ player ] = false
				MESSAGEMAN:Broadcast("ExitUnselected".. ToEnumShortString(player) )
				MESSAGEMAN:Broadcast("TweenCheck")
			end
		end
	}
end

local chcontroller
local Choices = Def.ActorFrame{
	Name="ChoicesAC",
	InitCommand=function(self)
		self:x( 76*0.5 )
		chcontroller = self
	end,
	Def.BitmapText{
		Font="journey/40/_journey 40",
		Name="MORE",
		Text=THEME:GetString("ScreenOptions","MORE"),
		InitCommand=function(self) self:halign(0):strokecolor(Color.Black):diffuse(color("#89B7D7")):y( 4 ):zoom(1.4) end
	},

	Def.BitmapText{
		Font="journey/40/_journey 40",
		Name="DONE",
		Text=THEME:GetString("ScreenOptions","DONE"),
		InitCommand=function(self) self:halign(0):strokecolor(Color.Black):y( 56 ):zoom(1.4) end
	}
}

t[#t+1] = Def.ActorFrameTexture{
	InitCommand=function(self)
		self:SetTextureName("MoreDoneText"):SetWidth( 76*4 ):SetHeight( 18*4 ):EnableAlphaBuffer(true):Create()
	end,

	Choices
}

-- t[#t+1] = LoadActor("moreexit")..{
t[#t+1] = Def.Sprite{
	Texture="MoreDoneText",
	OnCommand=function(self)
		self:xy(72*.35, 0):zoom(0.45):cropbottom(0.2):croptop(0.2)
		chcontroller:y(20)
	end,
	ToEndCommand=function(self) chcontroller:stoptweening():easeoutsine(0.2):y(-30) end,
	ToMoreCommand=function(self) chcontroller:stoptweening():easeinsine(0.2):y(20) end,
	AllReadyMessageCommand=function(self)
		-- If we're dealing with players, there could be the possibility of the translated More/Done text
		-- to be longer than it's current x ending position, so fix that.
		if GAMESTATE:IsPlayerEnabled(0) then
			-- With player 1, it's simple because the text is aligned to the left.
			SCREENMAN:GetTopScreen():GetChild("Container"):GetChild("Cursor")[1]:addx( -5 )
		end
		if GAMESTATE:IsPlayerEnabled(1) then
			-- Player 2, we need to calculate the size of the text.	
			SCREENMAN:GetTopScreen():GetChild("Container"):GetChild("Cursor")[2]:addx( (chcontroller:GetChild("DONE"):GetZoomedWidth()*0.5)-60 )
		end
	end,
	TweenCheckMessageCommand=function(self)
		self:stoptweening():linear(.15)
		if GAMESTATE:GetNumPlayersEnabled() == 2 then
			if ExitSelect[PLAYER_1] and ExitSelect[PLAYER_2] then
				self:playcommand("ToEnd")
				MESSAGEMAN:Broadcast("AllReady")
			else
				self:playcommand("ToMore")
			end
		else
			if ExitSelect[GAMESTATE:GetMasterPlayerNumber()] then
				self:playcommand("ToEnd")
				MESSAGEMAN:Broadcast("AllReady")
			else
				self:playcommand("ToMore")
			end
		end
	end
}

return t