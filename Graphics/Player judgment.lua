local c;
local player = Var "Player";
local isRealProf = LoadModule("Profile.IsMachine.lua")(player)
local PDir = (
	(PROFILEMAN:GetProfile(player):GetDisplayName() ~= "" and MEMCARDMAN:GetCardState(player) == 'MemoryCardState_none')
	and PROFILEMAN:GetProfileDir(string.sub(player,-1)-1).."GrooveNights.save"
	or "Save/TEMP"..player
)
local settings = {"DefaultJudgmentSize","DefaultJudgmentOpacity","ToggleJudgmentBounce"}
for _,v in pairs(settings) do
	-- In case the profile is an actual profile or USB
	if isRealProf then
		settings[_] = LoadModule("Config.Load.lua")(v,PDir)
	-- If not, then we'll use the temporary set for regular players.
	else
		settings[_] = GAMESTATE:Env()[v.."Machinetemp"..player]
	end
end

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

local zoominit = settings[3] and ( settings[1] and 0.8*settings[1] or 0.8) or (settings[1] and 0.75*settings[1] or 0.75)

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
		c.Judgment:visible( true )
		c.Judgment:diffusealpha( settings[2] or 1 )
		c.Judgment:setstate( iFrame )
		c.Judgment:rotationz( RotTween[param.TapNoteScore][math.random(1,2)] );
		c.Judgment:zoom( zoominit )
		c.Judgment:decelerate( 0.1 )
		c.Judgment:zoom( settings[1] and 0.75*settings[1] or 0.75 )
	end;
};


return t;
