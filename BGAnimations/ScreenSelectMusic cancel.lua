return Def.ActorFrame{
    StartTransitioningCommand=function(s)
        if GAMESTATE:Env()["OriginalOffset"] and (GAMESTATE:Env()["OriginalOffset"] ~= string.format( "%.2f", PREFSMAN:GetPreference( "GlobalOffsetSeconds" ) )) then
			SCREENMAN:SystemMessage("Offset has been reset to machine standard. (".. GAMESTATE:Env()["OriginalOffset"] .. ")")
			PREFSMAN:SetPreference( "GlobalOffsetSeconds", GAMESTATE:Env()["OriginalOffset"] )
			GAMESTATE:Env()["OriginalOffset"] = string.format( "%.2f", PREFSMAN:GetPreference( "GlobalOffsetSeconds" ) )
		end
    end,
}