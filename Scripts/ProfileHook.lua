-- Default settings.
-- Used for the TEMP file for regeneration for a new player.
local OptionStrings = {
	["DefaultJudgmentSize"] = 1,
	["DefaultJudgmentOpacity"] = 1,
	["DefaultComboSize"] = 1,
	["ToggleComboBounce"] = true,
	["ToggleJudgmentBounce"] = true,
	["ToggleComboExplosion"] = true,
	["ScoringFormat"] = 0,
}
local filename = "GrooveNights.save"
-- Hook called during profile load
local function LoadContents(path)
	local file = RageFileUtil.CreateRageFile()
	if not file:Open(path, 1) then
		file:destroy()
		return nil
	end
	local contents = file:Read()
	file:Close()
	file:destroy()
	return contents
end

function LoadProfileCustom(profile, dir)
	
	local path = dir .. filename
	local pn

	-- we've been passed a profile object as the variable "profile"
	-- see if it matches against anything returned by PROFILEMAN:GetProfile(player)
	for player in ivalues( GAMESTATE:GetHumanPlayers() ) do
		if profile == PROFILEMAN:GetProfile(player) then
			pn = player
			break
		end
	end

	-- Reset all temporary options.
	if pn then
		for k,v in pairs( OptionStrings ) do
			LoadModule("Config.Save.lua")( k, tostring(v) , "Save/TEMP"..pn )
		end
	end

	-- Load any possible registered settings into a temporary base file saved on the Machine's save folder.
	if pn then
		if FILEMAN:DoesFileExist(path) then
			local data = LoadContents(path)
			for line in string.gmatch(data.."\n", "(.-)\n") do	
				for KeyVal, Val in string.gmatch(line, "(.-)=(.+)") do
					LoadModule("Config.Save.lua")( KeyVal, tostring(Val) , "Save/TEMP"..pn )
				end
			end
		-- If the file to save contents is not found on the player's Memory card, then generate it before
		-- continuing, because if we don't generate it, then it won't even try to save data if it doesn't exist.
		else
			SCREENMAN:SystemMessage("GrooveNights Save file for ".. PROFILEMAN:GetProfile(pn):GetDisplayName() .." is not generated. Creating...")
			local isRealProf = LoadModule("Profile.IsMachine.lua")(pn)
			local Location = isRealProf and CheckIfUserOrMachineProfile(string.sub(pn,-1)-1) .."/".. filename or path
			for k,v in pairs( OptionStrings ) do
				LoadModule("Config.Save.lua")( k, tostring(v) , Location )
			end
		end
	end

	return true
end

-- Hook called during profile save
function SaveProfileCustom(profile, dir)
	local path = dir .. filename

	for player in ivalues( GAMESTATE:GetHumanPlayers() ) do
		if profile == PROFILEMAN:GetProfile(player) and FILEMAN:DoesFileExist(path) then
			local output = {}
			for k,v in pairs( OptionStrings ) do
				-- Use the contents we saved temporarily from ProfileLoad and save
				local res = LoadModule("Config.Load.lua")( k,"Save/TEMP"..player )
				LoadModule("Config.Save.lua")( k, tostring(res) , path )
			end
			break
		end
	end

	return true
end