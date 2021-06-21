local Data = ...
local t = Def.ActorFrame{
	OnCommand=function(s)
		s:zoom(0.28):xy(-1,-1):wag():effectmagnitude(0,0,2)
	end,
	Def.ActorFrame{
		OnCommand=function(s) s:sleep(1.4):queuecommand("Update") end,
		UpdateCommand=function(s)
			s:decelerate(0.3):zoom(1.1):accelerate(0.3):zoom(1):decelerate(0.3):zoom(0.9):diffusealpha(0.9):accelerate(0.3):zoom(1):diffusealpha(1):queuecommand("Update")
		end,

		Def.Sprite{
			Texture="GradeTier"..string.format( "%04i", Data[2] ),
			OnCommand=function(s) s:sleep(0.2) end,
			InitCommand=function(s)
				s:diffusealpha(0)
				:sleep(0.2)
				:queuecommand("GradeSound"):decelerate(0.6):zoom(1.7):diffusealpha(1):accelerate(0.4):zoom(1.3)
				:decelerate(0.1):zoom(1.1):diffusealpha(0.8):accelerate(0.1):zoom(1.3):diffusealpha(1)
			end,
			GradeSoundCommand=function(s)
				SOUND:PlayOnce( THEME:GetPathS("gnGradeUp","0") )
			end
		}
	}
}

return t