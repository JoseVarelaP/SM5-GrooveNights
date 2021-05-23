local requirescount = ...

local tpt = THEME:GetString("PlayTime","Label")
local s1 = THEME:GetString("PlayTime","Song")
local s2 = THEME:GetString("PlayTime","Songs")
local masterplayer = GAMESTATE:GetMasterPlayerNumber()
local curseconds = 0
local count = STATSMAN:GetStagesPlayed()

return Def.BitmapText{
    Condition=tobool(LoadModule("Config.Load.lua")("ToggleTotalPlayTime","Save/GrooveNightsPrefs.ini")),
    Font="novamono/36/_novamono 36px",
    InitCommand=function(s)
		curseconds = STATSMAN:GetAccumPlayedStageStats(masterplayer):GetGameplaySeconds()
        s:xy( SCREEN_CENTER_X, SCREEN_BOTTOM-14 ):zoom(0.6):strokecolor(Color.Black):playcommand("Update")
    end,
    UpdateCommand=function(s)
        local Comtp = SecondsToHHMMSS(
            curseconds
            +
            (
				requirescount and STATSMAN:GetCurStageStats(masterplayer):GetPlayerStageStats(masterplayer):GetAliveSeconds()
				or 0
			)
        )
        local SongsCount = " ("..count.." ".. ( count == 1 and s1 or s2 ) ..")"
        s:finishtweening()
        :settext( tpt .." ".. Comtp ..  SongsCount  )
        :AddAttribute(0, {
            Length=string.len(s:GetText())-(string.len(Comtp)+string.len(SongsCount)),
			Diffuse=color("#FFA314") }
		)
        if requirescount then
            s:sleep(1):queuecommand("Update")
        end
    end
}