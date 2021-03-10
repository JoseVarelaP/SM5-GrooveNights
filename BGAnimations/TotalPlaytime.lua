local requirescount = ...
return Def.BitmapText{
    Condition=tobool(LoadModule("Config.Load.lua")("ToggleTotalPlayTime","Save/GrooveNightsPrefs.ini")),
    Font="novamono/36/_novamono 36px",
    InitCommand=function(s)
        s:xy( SCREEN_CENTER_X, SCREEN_BOTTOM-14 ):zoom(0.6):strokecolor(Color.Black):playcommand("Update")
    end,
    UpdateCommand=function(s)
        local Comtp = SecondsToHHMMSS(
            STATSMAN:GetAccumPlayedStageStats(GAMESTATE:GetMasterPlayerNumber()):GetGameplaySeconds()
            +
            STATSMAN:GetCurStageStats(GAMESTATE:GetMasterPlayerNumber()):GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber()):GetAliveSeconds()
        )
        local SongsCount = " ("..STATSMAN:GetStagesPlayed().." songs)"
        s:finishtweening()
        s:settext( "Total PlayTime: ".. Comtp ..  SongsCount  )
        s:AddAttribute(0, {
            Length=string.len(s:GetText())-(string.len(Comtp)+string.len(SongsCount));
			Diffuse=color("#FFA314") }
		)
        if requirescount then
            s:sleep(1):queuecommand("Update")
        end
    end,
}