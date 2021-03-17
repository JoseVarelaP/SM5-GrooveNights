local t = Def.ActorFrame{}
local CurDir = {}

t[#t+1] = Def.Actor{
	OnCommand=function(s)
		local OpRow = s:GetParent():GetParent():GetParent()
		if OpRow then
			if OpRow:GetName() == "Steps" then
				for pn in ivalues( GAMESTATE:GetEnabledPlayers() ) do
					CurDir[pn] = OpRow:GetChoiceInRowWithFocus(pn)
				end
				s:queuecommand("Update")
			end
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

local TKN = PREFSMAN:GetPreference("ThreeKeyNavigation")
t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		local name = self:GetParent():GetParent():GetParent():GetName()
		self:xy( TKN and 298 or 276, 6 )
		if name == "gnGlobalOffset" or name == "OPERATORGlobalOffset" then
			self:AddChildFromPath( THEME:GetPathG("","TemporaryOffset.lua") )
		end
	end
}

return t;