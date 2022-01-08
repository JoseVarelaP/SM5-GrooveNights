local t = Def.ActorFrame{}
local curScreen = Var "LoadingScreen"
local gnZoomRatio = (SCREEN_WIDTH/640)
local isArcadeSetting = GAMESTATE:GetCoinMode() ~= "CoinMode_Home"

t[#t+1] = Def.Sprite{
	Texture="BGVid.mkv",
	OnCommand=function(self)
		self:diffusealpha(0.3):blend("BlendMode_Add"):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom(1.1*gnZoomRatio)
	end
}

t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:vibrate():effectmagnitude(0.5,0.5,0.1)
		:Center():zoom(0.8)
		if GAMESTATE:GetCoinMode() ~= "CoinMode_Home" then
			self:y( SCREEN_CENTER_Y + 60):zoom(1)
		end
	end,
	UpdateTitleImageMessageCommand=function(self) self:playcommand("TweakArea") end,
	CoinModeChangedMessageCommand=function(self) self:playcommand("TweakArea") end,
	TweakAreaCommand=function(self)
		isArcadeSetting = GAMESTATE:GetCoinMode() ~= "CoinMode_Home"
		self:stoptweening():tween(0.25,"decelerate")
		:y( SCREEN_CENTER_Y + (isArcadeSetting and 60 or 0) )
		:zoom( isArcadeSetting and 1 or 0.8)
	end,
	Def.Sprite{
		Texture="TitleScreen0002",
		OnCommand=function(self)
			self:addy(460):diffusealpha(1):sleep(1.7):zoom(1.7):
			diffusealpha(1):accelerate(0.5):addy(-510):zoom(0.8):decelerate(2):diffusealpha(1):addy(10)
		end
	},
	Def.Sprite{ Texture="TitleScreen0003",
		OnCommand=function(self)
			self:diffusealpha(0):decelerate(0.12):rotationz(2)
			:diffusealpha(1):zoom(1.1):accelerate(0.18):rotationz(0):zoom(1):decelerate(0.12):zoom(0.9):accelerate(0.08):rotationz(-2):
			zoom(1):decelerate(0.12):diffusealpha(1):zoom(1.1):accelerate(0.18):rotationz(0)
			:zoom(1):linear(1.4):addy(-30):decelerate(0.2):addy(-20)
		end
	},
	Def.Sprite{ Texture="TitleScreen0001",
		OnCommand=function(self)
			self:diffusealpha(0):decelerate(0.1):rotationz(4)
			:diffusealpha(1):zoom(1.1):accelerate(0.2):rotationz(0):zoom(1):decelerate(0.1):zoom(0.9)
			:accelerate(0.1):rotationz(-4):zoom(1):decelerate(0.1):diffusealpha(1):zoom(1.1)
			:accelerate(0.2):rotationz(0):zoom(1):linear(1.4):addy(-30):decelerate(0.2):addy(-40)
			:accelerate(0.2):addy(20)
		end
	},

	Def.BitmapText{
		Font="Common Normal",
		Text=string.format("%s %s",ProductID(),VersionDate()),
		InitCommand=function(self)
			self:y(-230):zoom(0.6):diffusealpha(0):strokecolor(color("0,0,0,0"))
			:sleep(1):linear(0.3):diffusealpha(0.6)
		end
	}
}

t[#t+1] = Def.Sprite{
	Texture="BGVid.mkv",
	OnCommand=function(self)
		self:diffusealpha(0.4):blend("BlendMode_Add"):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom(1.1*gnZoomRatio)
	end
}

t[#t+1] = Def.Quad{
	OnCommand=function(self)
		self:stretchto(SCREEN_LEFT,SCREEN_TOP,SCREEN_RIGHT,SCREEN_BOTTOM):
		diffuse(color("#FFFFFF")):diffusealpha(0):sleep(0.1):accelerate(0.5)
		:diffusealpha(0.3):sleep(0.2):decelerate(0.5):diffusealpha(0)
	end
}

return t