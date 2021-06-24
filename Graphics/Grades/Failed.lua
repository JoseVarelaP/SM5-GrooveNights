return Def.ActorFrame{
	OnCommand=function(self)
		self:zoom(.3):xy(-1,1):wag():effectmagnitude(0,0,2)
	end,
	
	Def.Sound{
		Name = "GradeSound",
		File = THEME:GetPathS("gnGradeUp","0"),
	},
	
	Def.Sprite{
		Texture="GradeTier0018",
		InitCommand=function(self)
			self:diffusealpha(0):y(24):sleep(0.2):queuecommand("GradeSound")
			:decelerate(0.6):zoom(1.5):diffusealpha(1):accelerate(0.4):zoom(1)
			:decelerate(0.1):zoom(0.9):diffusealpha(0.8):accelerate(0.1):zoom(1):diffusealpha(1)
		end,
		GradeSoundCommand=function(self)
			self:GetParent():GetChild("GradeSound"):play()
		end,
		OnCommand=function(self) self:sleep(0.2) end
	}
}