return function(PData)
	local profile = PROFILEMAN:GetProfile(PData) or PROFILEMAN:GetMachineProfile()
	local playerString = string.find(PData, "P1") and "Player 1" or "Player 2"
	local Pslot = string.find(PData, "P1") and 1 or 2
	local Info = {
		[PData] = {}
	};
	Info.PData = { Name="", Image="" };
	
	Info[PData].Image = THEME:GetPathG("","NoAvatar/".. (string.find(PData, "P1") and "P1" or "P2") .."noavatar" )
	Info[PData].Name = "No Card"
	if profile and profile:GetDisplayName() ~= "" then
		Info[PData].Name = profile:GetDisplayName()
		local Dir = FILEMAN:GetDirListing("/Appearance/Avatars/")
		for _,v in ipairs(Dir) do
			if string.match(v, "(%w+)") == profile:GetDisplayName() then Info[PData].Image = "/Appearance/Avatars/"..v end
		end
		-- Is the image still generic? Let's try chceking the built in avatars.
		Dir = FILEMAN:GetDirListing( THEME:GetCurrentThemeDirectory().."/Graphics/NoAvatar/" )
		for _,v in ipairs(Dir) do
			if string.match(v, "(%w+)Avatar") == profile:GetDisplayName() then Info[PData].Image = THEME:GetPathG("","NoAvatar/"..v) end
		end
	end
	if GAMESTATE:Env()["Konami"] then
		Info[PData].Image = THEME:GetPathG("","NoAvatar/KonamiAvatar")
	end
	return Info[PData]
end