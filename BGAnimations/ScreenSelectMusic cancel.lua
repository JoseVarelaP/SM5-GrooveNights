return Def.ActorFrame{
	loadfile( THEME:GetPathB("Transitions/Arrow","Out") )(),
	StartTransitioningCommand=function(s)
		if SOUND.Volume then
			SOUND:Volume(0,0.4)
		end
		if GAMESTATE:Env()["OriginalOffset"] and (GAMESTATE:Env()["OriginalOffset"] ~= string.format( "%.2f", PREFSMAN:GetPreference( "GlobalOffsetSeconds" ) )) then
			SCREENMAN:SystemMessage("Offset has been reset to machine standard. (".. GAMESTATE:Env()["OriginalOffset"] .. ")")
			PREFSMAN:SetPreference( "GlobalOffsetSeconds", GAMESTATE:Env()["OriginalOffset"] )
			GAMESTATE:Env()["OriginalOffset"] = string.format( "%.2f", PREFSMAN:GetPreference( "GlobalOffsetSeconds" ) )
		end
	end
}