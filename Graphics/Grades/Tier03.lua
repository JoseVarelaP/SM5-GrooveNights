local starpos = {
	{-55,-60},
	{50,50}
}

local Data = ...

local t = Def.ActorFrame{
	OnCommand=function(self)
		self:zoom(0.2):xy(-1,-1):wag():effectmagnitude(0,0,2)
	end
}

for _,v in pairs(starpos) do
	t[#t+1] = Def.ActorFrame{
		OnCommand=function(self) self:hibernate(0.3*(_-1)):xy(v[1],v[2]):sleep(1.4):queuecommand("Update") end,
		UpdateCommand=function(self)
			self:decelerate(0.3):zoom(1.1):accelerate(0.3):zoom(1):decelerate(0.3):zoom(0.9):diffusealpha(0.9):accelerate(0.3):zoom(1):diffusealpha(1):queuecommand("Update")
		end,

		Def.Sound{
			Name = "GradeSound",
			File = THEME:GetPathS("gnGradeUp",_),
		},

		Def.Sprite{
			Texture=LoadModule("Score.CustomTierGraphic.lua")(Data[1],3),
			OnCommand=function(self) self:sleep(0.2) end,
			InitCommand=function(self)
				self:diffusealpha(0)
				:sleep(0.2)
				:queuecommand("GradeSound"):decelerate(0.6):zoom(1.7):diffusealpha(1):accelerate(0.4):zoom(1.3)
				:decelerate(0.1):zoom(1.1):diffusealpha(0.8):accelerate(0.1):zoom(1.3):diffusealpha(1)
			end,
			GradeSoundCommand=function(self)
				self:GetParent():GetChild("GradeSound"):play()
			end
		}
	}
end

return t