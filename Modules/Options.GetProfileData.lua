return function(PData)
	local profile = PROFILEMAN:GetProfile(PData) or PROFILEMAN:GetMachineProfile()
	local playerString = string.find(PData, "P1") and "Player 1" or "Player 2"
	local Pslot = string.find(PData, "P1") and 1 or 2
	local Info = {
		[PData] = {}
	};
	Info.PData = { Name="", Image="" };

	local function FindPictureFromDirectory( Directory )
		local Dir = FILEMAN:GetDirListing(Directory)
		for _,v in ipairs(Dir) do
			if string.match(v, "(%w+)") == profile:GetDisplayName() then
				Info[PData].Image = Directory..v
			end
		end
	end
	
	Info[PData].Image = THEME:GetPathG("","NoAvatar/".. (string.find(PData, "P1") and "P1" or "P2") .."noavatar" )
	Info[PData].Name = "No Card"
	if profile and profile:GetDisplayName() ~= "" then
		Info[PData].Name = profile:GetDisplayName()

		-- Is it available on the profile itself?
		local Dir = FILEMAN:GetDirListing(PROFILEMAN:GetProfileDir(Pslot-1))
		for _,v in ipairs(Dir) do
			-- is there a avatar image?
			if string.find(v, "avatar") then
				Info[PData].Image = PROFILEMAN:GetProfileDir(Pslot-1)..v
			end
			-- or the name matches the profile name?
			if string.match(v, "(%w+)") == profile:GetDisplayName() then
				Info[PData].Image = PROFILEMAN:GetProfileDir(Pslot-1)..v
			end
		end
		-- Is it available on OutFox's avatars directory?
		FindPictureFromDirectory("/Appearance/Avatars/")
		-- Is the image still generic? Let's try chceking the built in avatars.
		FindPictureFromDirectory(THEME:GetCurrentThemeDirectory().."/Graphics/NoAvatar/")
	end
	if GAMESTATE:Env()["Konami"] then
		Info[PData].Image = THEME:GetPathG("","NoAvatar/KonamiAvatar")
	end
	return Info[PData]
end