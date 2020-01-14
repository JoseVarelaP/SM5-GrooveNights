local OptionStrings = {
	["DefaultJudgmentSize"] = 1,
	["DefaultJudgmentOpacity"] = 1,
	["DefaultComboSize"] = 1,
	["ToggleComboBounce"] = true,
	["ToggleJudgmentBounce"] = true,
	["ToggleComboExplosion"] = true,
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

	if pn and FILEMAN:DoesFileExist(path) then
		local data = LoadContents(path)
		for line in string.gmatch(data.."\n", "(.-)\n") do	
			for KeyVal, Val in string.gmatch(line, "(.-)=(.+)") do
				LoadModule("Config.Save.lua")( KeyVal, tostring(Val) , "Save/TEMP"..pn )
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
				local res = LoadModule("Config.Load.lua")( k,"Save/TEMP"..player )
				LoadModule("Config.Save.lua")( k, tostring(res) , path )
			end
			break
		end
	end

	return true
end