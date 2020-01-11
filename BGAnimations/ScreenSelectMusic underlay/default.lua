local t = Def.ActorFrame{}
t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenSelectMusic divider","F"),
    InitCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):diffuse( color("#1C2C3C") )
    end,
    SelectMenuOpenedMessageCommand=function()
        SOUND:PlayOnce( THEME:GetPathS("gnJudgeBar","1.ogg") )
    end,
}

for pn in ivalues( PlayerNumber ) do
    t[#t+1] = loadfile( THEME:GetPathB("ScreenSelectMusic","underlay/MusicPaneDisplay.lua") )(pn)
end

-- Time To Write song info
local Labels = {
    {"ARTIST", "BPM", "FOLDER"},
    {"RANK", "LENGTH"}
}

local function GetOrdinalSongRank()
    local sufixes = {"th","st","nd","rd"}
	local song = GAMESTATE:GetCurrentSong()
	local val = ""
	if song and SONGMAN:GetSongRank(song) then
		local ord = SONGMAN:GetSongRank(song) % 100
		if (ord / 10 == 1) then ord = 0 end
		ord = ord % 10
		if (ord > 3) then ord = 0 end
        val = SONGMAN:GetSongRank(song) .. THEME:GetString("OrdinalNumbers",sufixes[ord+1])
        return val
	end
end

for _,v in pairs(Labels) do
    for a,e in ipairs(v) do
        t[#t+1] = Def.BitmapText{
            Font="_eurostile normal",
            Text=e..":",
            OnCommand=function(s)
                s:halign(1):xy( SCREEN_CENTER_X-48+(310*(_-1)), SCREEN_CENTER_Y-56+(16*a) ):diffuse(color("#FFA314"))
                :zoom(0.6)
            end,
        }

        t[#t+1] = Def.BitmapText{
            Font="_eurostile normal",
            OnCommand=function(s)
                s:halign(0):xy( SCREEN_CENTER_X-48+(310*(_-1)), SCREEN_CENTER_Y-56+(16*a) )
                :zoom(0.6):playcommand("Update")
            end,
            CurrentSongChangedMessageCommand=function(s) s:playcommand("Update") end,
            CurrentStepsP1ChangedMessageCommand=function(s) s:playcommand("Update") end,
            CurrentStepsP2ChangedMessageCommand=function(s) s:playcommand("Update") end,
            UpdateCommand=function(s)
                s:settext("")
                local Steps = GAMESTATE:GetCurrentSteps( GAMESTATE:GetMasterPlayerNumber() )
                if GAMESTATE:GetCurrentSong() then
                    local data = {
                        { GAMESTATE:GetCurrentSong():GetDisplayArtist(), LoadModule("SelectMusic.ObtainBPM.lua")( Steps ), GAMESTATE:GetCurrentSong():GetSongDir() },
                        { GetOrdinalSongRank(),
                        math.floor(GAMESTATE:GetCurrentSong():MusicLengthSeconds()) == 105 and "Patched" or  SecondsToMMSS( math.floor(GAMESTATE:GetCurrentSong():MusicLengthSeconds()) )
                        },
                        Widths = { 240,240,600,80,80 }
                    }
                    data[1][2] = LoadModule("SelectMusic.ObtainBPM.lua")( Steps )
                    s:settext( " ".. data[_][a] ):maxwidth( data.Widths[ _*a ] )
                end
            end,
        }
    end
end

t[#t+1] = Def.BitmapText{
    Font="_eurostile normal",
    Condition=LoadModule("Config.Load.lua")("ToggleTotalPlayTime","Save/GrooveNightsPrefs.ini"),
    InitCommand=function(s)
        s:xy( SCREEN_CENTER_X, SCREEN_BOTTOM-10 ):zoom(0.6):playcommand("Update")
    end,
    UpdateCommand=function(s)
        local pn = GAMESTATE:GetMasterPlayerNumber()
        local TotalTime = STATSMAN:GetAccumPlayedStageStats(pn):GetGameplaySeconds()
        local TimeRightNow = STATSMAN:GetCurStageStats(pn):GetPlayerStageStats(pn):GetAliveSeconds()
        local Comtp = SecondsToHHMMSS(TotalTime+TimeRightNow)
        local SongsCount = " ("..STATSMAN:GetStagesPlayed().." songs)"
        s:finishtweening()
        s:settext( "Total PlayTime: ".. Comtp ..  SongsCount  )
        s:AddAttribute(0, {
            Length=string.len(s:GetText())-(string.len(Comtp)+string.len(SongsCount));
			Diffuse=color("#FFA314") }
		)
    end,
}

return t;