return function(pn,param)
    local function format_bpm(bpm)
	    return ("%.0f"):format(bpm)
    end
    local Steps = GAMESTATE:GetCurrentSteps(pn)
    local song_bpms = Steps:GetDisplayBpms()
	local text= ""
	local no_change= true
	if param.mode == "x" then
		if not song_bpms[1] then
			text= "??? - ???"
		elseif song_bpms[1] == song_bpms[2] then
			text= "x".. param.speed*.01 .." (" .. format_bpm(song_bpms[1] * param.speed*.01) .. ")"
		else
			text= "x".. param.speed*.01 .." (".. format_bpm(song_bpms[1] * param.speed*.01) .. "-" ..
				format_bpm(song_bpms[2] * param.speed*.01) .. ")"
		end
		no_change= param.speed == 100
	elseif param.mode == "C" or param.mode == "m" or param.mode == "a" then
		text= string.upper(param.mode) .. param.speed
		no_change= param.speed == song_bpms[2] and song_bpms[1] == song_bpms[2]
	else
		no_change= param.speed == song_bpms[2]
		if song_bpms[1] == song_bpms[2] then
			text= param.mode .. param.speed
		else
			local factor= song_bpms[1] / song_bpms[2]
			text= param.mode .. format_bpm(param.speed * factor) .. "-"
				.. param.mode .. param.speed
		end
    end
    return text
end