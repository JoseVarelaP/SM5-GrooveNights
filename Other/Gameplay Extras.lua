return Def.ActorFrame { 
	OnCommand=function(self)
		if LoadModule("Config.Load.lua")("UsePauseMenu","Save/GrooveNightsPrefs.ini") and (SCREENMAN:GetTopScreen():GetName() == "ScreenGameplay") then
			self:AddChildFromPath(GetModule("Gameplay.Pause.lua"))
		end
	end
}