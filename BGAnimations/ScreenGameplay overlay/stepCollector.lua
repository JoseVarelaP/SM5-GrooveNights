local t = Def.ActorFrame {};

------------------------
-- Begin TapNote Collection
local judgments,offsetdata = {},{}

-- Begin by seting up the table with player values
for pla in ivalues(PlayerNumber) do
	judgments[pla] = {};
	offsetdata[pla] = { Early=0, Late=0, OffTimings={} };
	-- Now fill by how many columns are available on the current style
	for i=1,GAMESTATE:GetCurrentStyle():ColumnsPerPlayer() do
		-- On each, judgments will be inserted.
		judgments[pla][i] = { W1=0, W2=0, W3=0, W4=0, W5=0, Miss=0 };
		-- Disabling Fantastic tmiming won't affect the table, as scores will go
		-- to W2 instead.
	end
end
local PauseTimeTable = {};

t[#t+1] = Def.Actor{
	JudgmentMessageCommand=function(self, params)
		-- Do we have the player and their notes?
		if params.Player == params.Player and params.Notes then
			local p = params.Player;
			-- Let´s check what column was just hit
			for i,col in pairs(params.Notes) do
				-- Alright, time to add it to the appropiate table.
				local tns = ToEnumShortString(params.TapNoteScore)
				judgments[p][i][tns] = judgments[p][i][tns] + 1
			end
			if params.TapNoteOffset and params.TapNoteScore ~= "TapNoteScore_CheckpointHit" and params.TapNoteScore ~= "TapNoteScore_CheckpointMiss" then
				offsetdata[p].OffTimings[#offsetdata[p].OffTimings+1] = params.TapNoteOffset
				if params.TapNoteScore ~= "TapNoteScore_W1" then
					if params.Early then
						offsetdata[p].Early = offsetdata[p].Early + 1
					else
						offsetdata[p].Late = offsetdata[p].Late + 1
					end
				end
			end
		end
	end,
	OffCommand=function(self)
		-- Song has finished, and now we need to save the table somewhere
		-- so we can use it outside of gameplay.
		setenv( "perColJudgeData", judgments )
		setenv( "OffsetTable", offsetdata )
	end;
};

------------------------	
-- End TapNote Collection
return t