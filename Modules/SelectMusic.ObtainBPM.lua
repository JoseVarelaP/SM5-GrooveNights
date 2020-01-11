return function(Steps)
    -- local Steps = GAMESTATE:GetCurrentSteps(pn)
	local val = ""
	if Steps then
		local bpms = Steps:GetDisplayBpms()
		if bpms[1] == bpms[2] then
			val = string.format("%i", math.floor(bpms[1]) )
		else
			val = string.format("%i-%i",math.floor(bpms[1]),math.floor(bpms[2]))
		end
	end
	return val
end