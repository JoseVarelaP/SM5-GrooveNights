return Def.BitmapText{
	Font="novamono/36/_novamono 36px",
	InitCommand=function(self)
		local FinalText = ""
		local StepCharters = ""
		if not GAMESTATE:IsCourseMode() then
			local DataToPick = {
				Title = GAMESTATE:GetCurrentSong():GetDisplayMainTitle(),
				Artist = GAMESTATE:GetCurrentSong():GetDisplayArtist(),
			}
			FinalText = DataToPick.Title .. "\n" .. DataToPick.Artist
			for player in ivalues(PlayerNumber) do
				if GAMESTATE:IsPlayerEnabled(player) then 
					local steps = GAMESTATE:GetCurrentSteps(player)
					local StepCharter = steps and ( steps:GetAuthorCredit() and steps:GetAuthorCredit() or steps:GetDescription() ) or ""							
					-- Show each difficulty's stepcharter. If it exists anyway.
					if StepCharter ~= "" then
						StepCharters = StepCharters .. "\n"..  LoadModule("Gameplay.DifficultyName.lua")("Steps", player) .. " " .. THEME:GetString("EditMenuRow","Steps") .. ": ".. StepCharter
						-- Both difficulties are the same? Filter them to only show one.
						if GAMESTATE:GetCurrentSteps(0) == GAMESTATE:GetCurrentSteps(1) then
							StepCharters = "\n"..  LoadModule("Gameplay.DifficultyName.lua")("Steps", player) .. " " .. THEME:GetString("EditMenuRow","Steps") .. ": ".. StepCharter
						end
					end
				end
			end
			self:settext( FinalText .. StepCharters )
		end
	end,
	OnCommand=function(self)
		self:halign(0):xy(SCREEN_LEFT+60,SCREEN_BOTTOM-100):shadowlength(2):zoom(0.75)
	end
}