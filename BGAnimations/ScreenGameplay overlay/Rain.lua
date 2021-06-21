-- Summer Rain, I made this chart so I don't need to credit myself (oops)
return Def.ActorFrame{
	OnCommand=function(self)
		self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom( (SCREEN_WIDTH/640) )
	end,
	Def.Sprite{
		Texture="easter_eggs/rainnear",
		OnCommand=function(self)
			self:customtexturerect(0,0,1,1):texcoordvelocity(0,-1)
			:stretchto( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT ):align(1,1)
			:diffusealpha(0):linear(1):diffusealpha(1)
		end
	},

	Def.Sprite{
		Texture="easter_eggs/rainmed",
		OnCommand=function(self)
			self:customtexturerect(0,0,1,1):texcoordvelocity(0,-0.8)
			:stretchto( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT ):align(1,1):rotationz(5)
			:diffusealpha(0):linear(1):diffusealpha(1)
		end
	},

	Def.Sprite{
		Texture="easter_eggs/rainfar",
		OnCommand=function(self)
			self:customtexturerect(0,0,1,1):texcoordvelocity(0,-0.6)
			:stretchto( 0,0,SCREEN_WIDTH,SCREEN_HEIGHT ):align(1,1):rotationz(-5)
			:diffusealpha(0):linear(1):diffusealpha(1)
		end
	},

	Def.Sprite{
		Texture="easter_eggs/rainClouds",
		OnCommand=function(self)
			self:diffusealpha(0):linear(1):diffusealpha(1)
		end
	},
}