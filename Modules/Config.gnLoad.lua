return function(player, Config)
    local Location
    if (PROFILEMAN:GetProfile(player):GetDisplayName() ~= "" and MEMCARDMAN:GetCardState(player) == 'MemoryCardState_none') then
        Location = PROFILEMAN:GetProfileDir(string.sub(player,-1)-1).."GrooveNights.save"
    else
        Location = "Save/TEMP"..player
    end

    -- If the profile is a valid player with a save location, then use the Config Load module.
    local isRealProf = LoadModule("Profile.IsMachine.lua")(player)
    local CLocSet
    if isRealProf then
		CLocSet = LoadModule("Config.Load.lua")(Config, Location)
	-- If not, then we'll use the temporary set for regular players.
	else
		CLocSet = GAMESTATE:Env()[Config.."Machinetemp"..player]
    end
    return {CLocSet, not isRealProf, Location}
end