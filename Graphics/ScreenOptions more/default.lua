local ExitSelect = {
	[PLAYER_1] = false,
	[PLAYER_2] = false
}
local t = Def.ActorFrame{
	BeginCommand=function(s)
		local screen = SCREENMAN:GetTopScreen():GetName()
		s:y( THEME:GetMetric(screen,"SeparateExitRowY") ):addx(-SCREEN_WIDTH):decelerate(0.3):addx(SCREEN_WIDTH)
	end;
	CancelMessageCommand=function(s) s:playcommand("Off") end;
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

t[#t+1] = LoadActor("moreexit")..{
	OnCommand=function(s)
		s:y(14):cropbottom(.57):croptop(.1)
	end;
	ToEndCommand=function(s) s:y(-18):croptop(.57):cropbottom(.1) end,
	ToMoreCommand=function(s) s:y(14):cropbottom(.57):croptop(.1) end,
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
