local ExitSelect = {
	[PLAYER_1] = false,
	[PLAYER_2] = false
}
local t = Def.ActorFrame{
	BeginCommand=function(s)
		local screen = SCREENMAN:GetTopScreen():GetName()
		s:y( THEME:GetMetric(screen,"SeparateExitRowY") )
	end;
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
		end;
		["ExitUnselected".. ToEnumShortString(player) .."Command"]=function(s)
			if GAMESTATE:IsPlayerEnabled(player) then
				ExitSelect[ player ] = false
				MESSAGEMAN:Broadcast("ExitUnselected".. ToEnumShortString(player) )
				MESSAGEMAN:Broadcast("TweenCheck")
			end
		end;
	};
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
		InitCommand=function(self) self:halign(0):strokecolor(Color.Black):diffuse(color("#89B7D7")):y( 4 ):zoom(0.6) end
	},

	Def.BitmapText{
		Font="journey/40/_journey 40",
		Name="DONE",
		Text=THEME:GetString("ScreenOptions","DONE"),
		InitCommand=function(self) self:halign(0):strokecolor(Color.Black):y( 24 ):zoom(0.6) end
	}
}

t[#t+1] = Def.ActorFrameTexture{
	InitCommand=function(self)
		self:SetTextureName("MoreDoneText"):SetWidth( 76*2 ):SetHeight( 18 ):EnableAlphaBuffer(true):Create()
	end,

	Choices
}

-- t[#t+1] = LoadActor("moreexit")..{
t[#t+1] = Def.Sprite{
	Texture="MoreDoneText",
	OnCommand=function(s)
		s:xy(72*.25, 0)
	end,
	ToEndCommand=function(s) chcontroller:stoptweening():decelerate(0.2):y(-20) end,
	ToMoreCommand=function(s) chcontroller:stoptweening():decelerate(0.2):y(0) end,
	AllReadyMessageCommand=function(self)
		if GAMESTATE:IsPlayerEnabled(1) then
			-- If we're dealing with player 2, there could be the possibility of the translated More/Done text
			-- to be longer than it's current x ending position, so fix that.
			SCREENMAN:GetTopScreen():GetChild("Container"):GetChild("Cursor")[2]:addx( chcontroller:GetChild("DONE"):GetZoomedWidth()-50 )
		end
	end,
	TweenCheckMessageCommand=function(s)
		s:stoptweening():linear(.15)
		if GAMESTATE:GetNumPlayersEnabled() == 2 then
			if ExitSelect[PLAYER_1] and ExitSelect[PLAYER_2] then
				s:playcommand("ToEnd")
				MESSAGEMAN:Broadcast("AllReady")
			else
				s:playcommand("ToMore")
			end
		else
			if ExitSelect[GAMESTATE:GetMasterPlayerNumber()] then
				s:playcommand("ToEnd")
				MESSAGEMAN:Broadcast("AllReady")
			else
				s:playcommand("ToMore")
			end
		end
	end;
};

return t;
