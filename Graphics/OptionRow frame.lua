local t = Def.ActorFrame{}
local CurDir = {}

t[#t+1] = Def.Actor{
	OnCommand=function(s)
		s:visible(false)
		local OpRow = s:GetParent():GetParent():GetParent()
		if OpRow:GetName() == "Steps" then
			s:visible(true)
			for pn in ivalues( GAMESTATE:GetEnabledPlayers() ) do
				CurDir[pn] = OpRow:GetChoiceInRowWithFocus(pn)
			end
			s:queuecommand("Update")
		end
	end,
	UpdateCommand=function(s)
		local OpRow = s:GetParent():GetParent():GetParent()
		for pn in ivalues( GAMESTATE:GetEnabledPlayers() ) do
			if OpRow:GetChoiceInRowWithFocus(pn) ~= CurDir[pn] then
				MESSAGEMAN:Broadcast("OptionRowSteps"..ToEnumShortString(pn).."Changed",{Index=OpRow:GetChoiceInRowWithFocus(pn)+1})
				CurDir[pn] = OpRow:GetChoiceInRowWithFocus(pn)
			end
		end
		s:sleep(4/60):queuecommand("Update")
	end,
}

return t;