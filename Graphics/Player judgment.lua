local c;
local player = Var "Player";

local TNSFrames = {
	TapNoteScore_W1 = 0;
	TapNoteScore_W2 = 1;
	TapNoteScore_W3 = 2;
	TapNoteScore_W4 = 3;
	TapNoteScore_W5 = 4;
	TapNoteScore_Miss = 5;
};

local RotTween = {
	-- Even, Odd
	TapNoteScore_W1 = {0,0},
	TapNoteScore_W2 = {0,0},
	TapNoteScore_W3 = {-3,3},	
	TapNoteScore_W4 = {-5,5},
	TapNoteScore_W5 = {-10,10},
	TapNoteScore_Miss = {-30,30},
};

local t = Def.ActorFrame {};
t[#t+1] = Def.ActorFrame {
	LoadActor("Judgment label") .. {
		Name="Judgment";
		InitCommand=function(self)
			self:pause():visible(false)
		end;
		OnCommand=THEME:GetMetric("Judgment","JudgmentOnCommand");
		ResetCommand=function(self)
			self:finishtweening():stopeffect():visible(false)
		end;
	};
	
	InitCommand = function(self)
		c = self:GetChildren();
	end;

	JudgmentMessageCommand=function(self, param)
		if param.Player ~= player then return end;
		if param.HoldNoteScore then return end;

		local iNumStates = c.Judgment:GetNumStates();
		local iFrame = TNSFrames[param.TapNoteScore];
		
		local iTapNoteOffset = param.TapNoteOffset;
		
		if not iFrame then return end
		if iNumStates == 12 then
			iFrame = iFrame * 2;
			if not param.Early then
				iFrame = iFrame + 1;
			end
		end

		local pNum = (player == PLAYER_1) and 1 or 2
		
		self:playcommand("Reset");

		local DJS = LoadModule("Config.Load.lua")("DefaultJudgmentSize","Save/GrooveNightsPrefs.ini") or 1

		c.Judgment:visible( true )
		c.Judgment:diffusealpha( LoadModule("Config.Load.lua")("DefaultJudgmentOpacity","Save/GrooveNightsPrefs.ini") or 1 )
		c.Judgment:setstate( iFrame )
		c.Judgment:rotationz( RotTween[param.TapNoteScore][math.random(1,2)] );
		c.Judgment:zoom( LoadModule("Config.Load.lua")("ToggleJudgmentBounce","Save/GrooveNightsPrefs.ini") and 0.8*DJS or 0.75*DJS )
		c.Judgment:decelerate( 0.1 )
		c.Judgment:zoom( 0.75*DJS )
	end;
};


return t;
