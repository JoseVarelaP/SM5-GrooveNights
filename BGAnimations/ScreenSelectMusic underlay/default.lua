local t = Def.ActorFrame{}
t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenSelectMusic divider","frame"),
    InitCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
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
                s:halign(1):xy( SCREEN_CENTER_X-248+(200*_), SCREEN_CENTER_Y-70+(16*a) ):diffuse(color("0.6,0.8,0.9,1"))
                :zoom(0.6)
            end,
        }

        t[#t+1] = Def.BitmapText{
            Font="_eurostile normal",
            OnCommand=function(s)
                s:halign(0):xy( SCREEN_CENTER_X-248+(200*_), SCREEN_CENTER_Y-70+(16*a) )
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
                        { GetOrdinalSongRank(), SecondsToMMSS( GAMESTATE:GetCurrentSong():MusicLengthSeconds() ) },
                        Widths = { 240,240,400,80,80 }
                    }
                    data[1][2] = LoadModule("SelectMusic.ObtainBPM.lua")( Steps )
                    s:settext( " ".. data[_][a] ):maxwidth( data.Widths[ _*a ] )
                end
            end,
        }
    end
end

-- CDTitles --
local CDTitleMan = Def.ActorFrame{
    InitCommand=function(s)
        s:xy( SCREEN_CENTER_X+264, SCREEN_CENTER_Y-46 )
    end,
}
CDTitleMan[#CDTitleMan+1] = Def.Sprite{ Texture=THEME:GetPathG("CDTitle","Frame") }

CDTitleMan[#CDTitleMan+1] = Def.Sprite{
    CurrentSongChangedMessageCommand=function(s)
        local tex = THEME:GetPathG("CDTitle","Fallback")
        if GAMESTATE:GetCurrentSong() then
            if GAMESTATE:GetCurrentSong():GetCDTitlePath() and GAMESTATE:GetCurrentSong():GetCDTitlePath() ~= "" then
                tex = GAMESTATE:GetCurrentSong():GetCDTitlePath()
            end
        end
        s:Load( tex ):setsize( 60,16 )
    end
}
CDTitleMan[#CDTitleMan+1] = Def.Sprite{ Texture=THEME:GetPathG("CDTitle","OverFrame") }

t[#t+1] = CDTitleMan

t[#t+1] = Def.BitmapText{
    Font="_eurostile normal",
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