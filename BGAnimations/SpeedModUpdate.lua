-- Speed Mod Updater
local pn = ...

local speed = {0,""}
local isPlayerOptions = GAMESTATE:Env()["gnNextScreen"] == "ScreenPlayerOptions"
local col = pn == PLAYER_2 and 2 or 1
local Speedmargin = LoadModule("Config.Load.lua")("SpeedMargin","Save/OutFoxPrefs.ini") and LoadModule("Config.Load.lua")("SpeedMargin","Save/OutFoxPrefs.ini")*100 or 25
local ORNum = 1

local speedtypes = {
	["x"] = function(playeroptions) playeroptions:XMod(speed[1]*0.01) end,
	["c"] = function(playeroptions) playeroptions:CMod(speed[1]) end,
	["m"] = function(playeroptions) playeroptions:MMod(speed[1]) end,
	["a"] = function(playeroptions) playeroptions:AMod(speed[1]) end,
}

local speedset = setmetatable(speedtypes,{
	__index = function(this, key)
		if this[key] then
			this[key]()
		end
	end
})

local calculateNewMargin = function(curSpeed, speedMargin)
	-- Left is lowest posible, right is highest.
	local marginarea = {}
	-- calculate the current offset of the current speeed to the allowed margin.
	local speedOffset = math.mod( curSpeed, speedMargin )

	local marginHalve = speedMargin*.5
	local newval = curSpeed
	if speedOffset < marginHalve then
		newval = curSpeed - speedOffset
	else
		newval = (curSpeed + Speedmargin) - speedOffset
	end

	return newval
end

return Def.ActorFrame{
	Def.Sound{
		Name = "value",
		IsAction = true,
		File = THEME:GetPathS("_change","value")
	},
	SpeedModTypeChangeMessageCommand=function(self,param)
		if param.pn == pn then
			speed[2] = param.choicename
			local text = ""
			if speed[2] == "x" then
				text = speed[1] * .01 .. "x"
			else
				text = string.upper(speed[2]) .. speed[1]
			end
			self:playcommand("UpdateString", {Speed=text} )
		end
	end,
	UpdateStringCommand=function(self)
		if speed[1] < Speedmargin then
			speed[1] = Speedmargin
		end

		speed[1] = calculateNewMargin(speed[1],Speedmargin)

		if isPlayerOptions and SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetOptionRow(ORNum) then
			local text = ""
			if speed[2] == "x" then
				text = speed[1] * .01 .. "x"
			else
				text = string.upper(speed[2]) .. speed[1]
			end
			SCREENMAN:GetTopScreen():GetOptionRow(ORNum):GetChild(""):GetChild("Item")[col]:settext( text )
			MESSAGEMAN:Broadcast("SpeedChoiceChanged",{pn=pn,mode=speed[2],speed=speed[1]})
		end
	end,
	OnCommand=function(self)
		local playeroptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
		if playeroptions:XMod() then speed[1] = math.floor(playeroptions:XMod()*100) speed[2] = "x" end
		if playeroptions:CMod() then speed[1] = math.floor(playeroptions:CMod()) speed[2] = "c" end
		if playeroptions:MMod() then speed[1] = math.floor(playeroptions:MMod()) speed[2] = "m" end
		if playeroptions:AMod() then speed[1] = math.floor(playeroptions:AMod()) speed[2] = "a" end
		if speed[1] > 1000*10 then
			speed[1] = 100
		end
		if SCREENMAN:GetTopScreen() then
			-- Automatic check for the optionrow that contains the speed mod.
			for i=0,SCREENMAN:GetTopScreen():GetNumRows()-1 do
				if SCREENMAN:GetTopScreen():GetOptionRow(i):GetName() == "SpeedModVal" then
					ORNum = i
					break
				end
			end
			local text = ""
			if speed[2] == "x" then
				text = speed[1] * .01 .. "x"
			else
				text = string.upper(speed[2]) .. speed[1]
			end
			MESSAGEMAN:Broadcast("SpeedChoiceChanged",{pn=pn,mode=speed[2],speed=speed[1]})
			self:queuecommand("UpdateString")
		end
	end,
	["MenuLeft"..ToEnumShortString(pn).."MessageCommand"]=function(self)
		local row_index = SCREENMAN:GetTopScreen():GetCurrentRowIndex(pn)
		if row_index == ORNum then
			self:GetChild("value"):play()
			speed[1] = speed[1] - Speedmargin
			self:playcommand("UpdateString")
		end
	end,
	["MenuRight"..ToEnumShortString(pn).."MessageCommand"]=function(self)
		local row_index = SCREENMAN:GetTopScreen():GetCurrentRowIndex(pn)
		if row_index == ORNum then
			self:GetChild("value"):play()
			speed[1] = speed[1] + Speedmargin
			self:playcommand("UpdateString")
		end
	end,
	OffCommand=function(self)
		local playeroptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
		playeroptions:XMod(1.00)

		-- Set the new speed to the player. This is handled by a metatable.
		speedset[speed[2]](playeroptions)
	end
}