local t = Def.ActorFrame{	
	Def.Quad{
	InitCommand=function(self)
		self:diffuse(0,0,0,1)
	end,
	OnCommand=function(self)
		self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y):FullScreen()
	end
	},
};

GAMESTATE:Env()["gnNextScreen"] = "ScreenPlayerOptions"
PREFSMAN:SetPreference( "GlobalOffsetSeconds", GAMESTATE:Env()["NewOffset"] )

local function LoadStageOrCourse()
	local sides = { "Stages/ScreenGameplay","stage ".. ToEnumShortString(GAMESTATE:GetCurrentStage()) }
	if GAMESTATE:IsCourseMode() then
		sides[1] = "Stages/ScreenGameplay course"
		sides[2] = "song 1"
	end

	return sides[1],sides[2]
end

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s)
		s:xy( SCREEN_CENTER_X,SCREEN_BOTTOM+50 ):sleep(0.333):tween(0.5,"easeoutback"):y( SCREEN_CENTER_Y )
	end,
	Def.Sprite{
		Texture=THEME:GetPathG(LoadStageOrCourse())
	},
};

t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("","TransitionArrow"),
    OnCommand=function(s)
		s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):accelerate(0.2):y(-60)
		SOUND:PlayOnce( THEME:GetPathS("gnScreenTransition whoosh", "long") )
    end,
}

return t;