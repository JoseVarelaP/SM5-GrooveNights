local t = Def.ActorFrame{
	-- todo: make this less stupid
	Def.BitmapText{
		Font="Common Normal",
		InitCommand=function(s) s:x(154):halign(1):zoom(0.6):diffusealpha(0.6) end,
		SetMessageCommand=function(s,param)
			if param.StepsType then
				s:settext( THEME:GetString("StepsType",ToEnumShortString(param.StepsType) ) )
			end
		end
	}

};

return t;
