local t = Def.ActorFrame{}
local gnZoomRatio = (SCREEN_WIDTH/640)

t[#t+1] = Def.Sprite{
	Texture="BGVid.mkv",
	OnCommand=function(s)
		s:diffusealpha(0.3):blend("BlendMode_Add"):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom(1.1*gnZoomRatio)
	end,
}

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s)
		s:vibrate():effectmagnitude(0.5,0.5,0.1)
		if GAMESTATE:GetCoinMode() ~= "CoinMode_Home" then
			s:y(60)
		end
	end,
	Def.Sprite{ Texture="TitleScreen0002", OnCommand=function(s)
		s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):addy(460):diffusealpha(1):sleep(1.7):zoom(1.7):
		diffusealpha(1):accelerate(0.5):addy(-510):zoom(0.8):decelerate(2):diffusealpha(1):addy(10)
		end,
	},
	Def.Sprite{ Texture="TitleScreen0003", OnCommand=function(s)
		s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):diffusealpha(0):decelerate(0.12):rotationz(2)
		:diffusealpha(1):zoom(1.1):accelerate(0.18):rotationz(0):zoom(1):decelerate(0.12):zoom(0.9):accelerate(0.08):rotationz(-2):
		zoom(1):decelerate(0.12):diffusealpha(1):zoom(1.1):accelerate(0.18):rotationz(0)
		:zoom(1):linear(1.4):addy(-30):decelerate(0.2):addy(-20)
		end,
	},
	Def.Sprite{ Texture="TitleScreen0001", OnCommand=function(s)
		s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):diffusealpha(0):decelerate(0.1):rotationz(4)
		:diffusealpha(1):zoom(1.1):accelerate(0.2):rotationz(0):zoom(1):decelerate(0.1):zoom(0.9)
		:accelerate(0.1):rotationz(-4):zoom(1):decelerate(0.1):diffusealpha(1):zoom(1.1)
		:accelerate(0.2):rotationz(0):zoom(1):linear(1.4):addy(-30):decelerate(0.2):addy(-40)
		:accelerate(0.2):addy(20)
		end,
	}
}

t[#t+1] = Def.Sprite{
	Texture="BGVid.mkv",
	OnCommand=function(s)
		s:diffusealpha(0.4):blend("BlendMode_Add"):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom(1.1*gnZoomRatio)
	end,
}

t[#t+1] = Def.Quad{
	OnCommand=function(s)
		s:stretchto(SCREEN_LEFT,SCREEN_TOP,SCREEN_RIGHT,SCREEN_BOTTOM):
		diffuse(color("#FFFFFF")):diffusealpha(0):sleep(0.1):accelerate(0.5)
		:diffusealpha(0.3):sleep(0.2):decelerate(0.5):diffusealpha(0)
	end,
}

return t