local t = Def.ActorFrame{	
	Def.Quad{
	InitCommand=function(self)
		self:diffuse(0,0,0,1)
	end;
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y):FullScreen()
	end;
	},
};

GAMESTATE:Env()["gnNextScreen"] = "ScreenPlayerOptions"
if not GAMESTATE:IsCourseMode() then
t[#t+1] = LoadActor("../_song credit display")..{
	OnCommand=function(self)
		self:diffusealpha(0):linear(0.2):diffusealpha(1)
	end;
};
t[#t+1] = Def.ActorFrame{
		InitCommand=function(s) s:hibernate(0.199):xy( SCREEN_CENTER_X,SCREEN_BOTTOM+100 ):bounceend(0.5):y( SCREEN_CENTER_Y ) end,
		Def.Sprite{ Texture=THEME:GetPathG("Stages/ScreenGameplay","stage ".. ToEnumShortString(GAMESTATE:GetCurrentStage())) },
};
end

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","TransitionArrow"),
    OnCommand=function(s)
		s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):accelerate(0.2):y(-60)
		SOUND:PlayOnce( THEME:GetPathS("gnScreenTransition whoosh", "long") )
    end,
}

if GAMESTATE:IsCourseMode() then
t[#t+1] = Def.ActorFrame{
		Def.Sprite{
			Texture=THEME:GetPathG("Stages/ScreenGameplay course song","1" ),
			OnCommand=function(self)
				self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y):cropright(1.3):linear(1):cropright(-0.3)
			end;
		},

		Def.Sprite{
			Texture="_white ScreenGameplay course song 1",
			OnCommand=function(self)
				self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y):zoom(1.05):cropleft(-0.3):cropright(1):faderight(.1):fadeleft(.1):linear(1):cropleft(1):cropright(-0.3)
			end;
		},

};
end

return t;