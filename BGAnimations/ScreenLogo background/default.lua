local t = Def.ActorFrame{}
local gnZoomRatio = (SCREEN_WIDTH/640)
local Codes = {"Santa","Frost","Blizzard","Rain","Wag","AngryGrandpa","Konami"}

t[#t+1] = Def.Sprite{
	Texture="BGVid.avi",
	OnCommand=function(s)
		s:diffusealpha(0.3):blend("BlendMode_Add"):xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom(1.1*gnZoomRatio)
	end,
}

t[#t+1] = Def.ActorFrame{
	Condition=GAMESTATE:GetCoinMode() == "CoinMode_Home",
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
	Texture="BGVid.avi",
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
--[[
<ActorFrame InitCommand="sleep,0.1;queuecommand,loop;"
loopCommand="%function(self)
self:stoptweening();
if GAMESTATE:GetEnv('Santa') == 'Turn' then
	SCREENMAN:SystemMessage('Santa Code Activated');
	GAMESTATE:SetEnv('Santa','On');
	end
if GAMESTATE:GetEnv('Frost') == 'Turn' then
	SCREENMAN:SystemMessage('Frost Code Activated');
	GAMESTATE:SetEnv('Frost','On');
	end
if GAMESTATE:GetEnv('Blizzard') == 'Turn' then
	SCREENMAN:SystemMessage('Blizzard Code Activated');
	GAMESTATE:SetEnv('Blizzard','On');
	end
if GAMESTATE:GetEnv('Rain') == 'Turn' then
	SCREENMAN:SystemMessage('Rain Code Activated');
	GAMESTATE:SetEnv('Rain','On');
	end
if GAMESTATE:GetEnv('Wag') == 'Turn' then
	SCREENMAN:SystemMessage('Wag Code Activated');
	GAMESTATE:SetEnv('Wag','On');
	end
if GAMESTATE:GetEnv('AngryGrandpa') == 'Turn' then
	SCREENMAN:SystemMessage('Angry Grandpa Code Activated');
	GAMESTATE:SetEnv('AngryGrandpa','On');
	end
if GAMESTATE:GetEnv('Konami') == 'Turn' then
	SCREENMAN:SystemMessage('Konami Code Activated');
	GAMESTATE:SetEnv('Konami','On');
	end
self:sleep(0.1);
self:queuecommand('loop');
end"><children>
	<Layer
		File="BGVid.avi"
		OnCommand="diffusealpha,0.3;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoom,1.1*gnZoomRatio;queuecommand,Authenticate;"
		AuthenticateCommand="%function(self)
		GAMESTATE:SetEnv('Santa','Off');
		GAMESTATE:SetEnv('Frost','Off');
		GAMESTATE:SetEnv('Blizzard','Off');
		GAMESTATE:SetEnv('Rain','Off');
		GAMESTATE:SetEnv('Wag','Off');
		GAMESTATE:SetEnv('AngryGrandpa','Off');
		GAMESTATE:SetEnv('Konami','Off');
		gnScreenEdit = false;
		gnScreenEnd = true;
		gnDummy = MachineIsUsingGrooveNights();
		gnP1Ready = 0;
		gnP2Ready = 0;
			gnPlaySec = 0;
			gnPlayMin = 0;
			gnPlayHour = 0;
			gnSongCount = 0;
			gnOldPlaySec = 0;
			gnOldPlayMin = 0;
			gnOldPlayHour = 0;
			gnOldSongCount = 0;
		gnStatFrequencyP1 = getMaxStatFrequency();
		gnStatFrequencyP2 = getMaxStatFrequency();
		end"
	/>
	
		<Layer
		File="TitleScreen0004.png"
		OnCommand="x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoom,1*gnZoomRatio;"
	/>
	
	<!-- Home Mode Interface -->
	<Layer Class="ActorFrame" Condition="GAMESTATE:GetCoinMode()==COIN_MODE_HOME"><children>
		<Layer
		File="TitleScreen0002.png"
		OnCommand="x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;addy,460;diffusealpha,1;sleep,1.7;zoom,1.7;diffusealpha,1;accelerate,0.5;addy,-510;zoom,0.8;decelerate,2;diffusealpha,1;addy,10;"
	/>
		<Layer
		File="TitleScreen0003.png"
		OnCommand="x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,0;decelerate,0.12;rotationz,2;diffusealpha,1;zoom,1.1;accelerate,0.18;rotationz,0;zoom,1;decelerate,0.12;zoom,0.9;accelerate,0.08;rotationz,-2;zoom,1;decelerate,0.12;diffusealpha,1;zoom,1.1;accelerate,0.18;rotationz,0;zoom,1;linear,1.4;addy,-30;decelerate,0.2;addy,-20;"
	/>
		<Layer
		File="TitleScreen0001.png"
		OnCommand="x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,0;decelerate,0.1;rotationz,4;diffusealpha,1;zoom,1.1;accelerate,0.2;rotationz,0;zoom,1;decelerate,0.1;zoom,0.9;accelerate,0.1;rotationz,-4;zoom,1;decelerate,0.1;diffusealpha,1;zoom,1.1;accelerate,0.2;rotationz,0;zoom,1;linear,1.4;addy,-30;decelerate,0.2;addy,-40;accelerate,0.2;addy,20;"
	/>
	</children></Layer>

	<!-- All Other Mode Interface -->
	<Layer Class="ActorFrame" Condition="GAMESTATE:GetCoinMode()~=COIN_MODE_HOME" InitCommand="y,60;"><children>
		<Layer
		File="TitleScreen0002.png"
		OnCommand="x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;addy,460;diffusealpha,1;sleep,1.7;zoom,1.7;diffusealpha,1;accelerate,0.5;addy,-510;zoom,0.8;decelerate,2;diffusealpha,1;addy,10;"
	/>
		<Layer
		File="TitleScreen0003.png"
		OnCommand="x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,0;decelerate,0.12;rotationz,2;diffusealpha,1;zoom,1.1;accelerate,0.18;rotationz,0;zoom,1;decelerate,0.12;zoom,0.9;accelerate,0.08;rotationz,-2;zoom,1;decelerate,0.12;diffusealpha,1;zoom,1.1;accelerate,0.18;rotationz,0;zoom,1;linear,1.4;addy,-30;decelerate,0.2;addy,-20;"
	/>
		<Layer
		File="TitleScreen0001.png"
		OnCommand="x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,0;decelerate,0.1;rotationz,4;diffusealpha,1;zoom,1.1;accelerate,0.2;rotationz,0;zoom,1;decelerate,0.1;zoom,0.9;accelerate,0.1;rotationz,-4;zoom,1;decelerate,0.1;diffusealpha,1;zoom,1.1;accelerate,0.2;rotationz,0;zoom,1;linear,1.4;addy,-30;decelerate,0.2;addy,-40;accelerate,0.2;addy,20;"
	/>
	</children></Layer>
	
	<Layer Class="ActorFrame"><children>
		<Layer
		File="BGVid.avi"
		OnCommand="diffusealpha,0.4;blend,add;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoom,1.1*gnZoomRatio;"
	/>
	</children></Layer>
											
	<Layer
		Class="Quad"
		OnCommand="stretchto,SCREEN_LEFT,SCREEN_TOP,SCREEN_RIGHT,SCREEN_BOTTOM;diffuse,#FFFFFF;diffusealpha,0;sleep,0.1;accelerate,0.5;diffusealpha,0.3;sleep,0.2;decelerate,0.5;diffusealpha,0"
	/>
</children></ActorFrame>
]]