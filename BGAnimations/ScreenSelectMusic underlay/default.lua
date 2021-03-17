local t = Def.ActorFrame{}
t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("ScreenSelectMusic divider","F"),
    InitCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):diffuse( color("#1C2C3C") )
    end
}

LoadModule("Row.Prefs.lua")(LoadModule("Options.Prefs.lua"))
THEME:ReloadMetrics()

t[#t+1] = Def.Sound{
	File=THEME:GetPathS("gnJudgeBar","1.ogg"),
	SelectMenuOpenedMessageCommand=function(self)
		self:play()
	end
}

for pn in ivalues( PlayerNumber ) do
    t[#t+1] = loadfile( THEME:GetPathB("ScreenSelectMusic","underlay/MusicPaneDisplay.lua") )(pn)
end

-- Time To Write song info
local Labels = {
    Normal = {{"ARTIST", "BPM", "FOLDER"}, {"RANK", "LENGTH"}},
    Grandpa = {{"music", "GO!", "where"}, {"like", "longer"}}
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

local data = {
    function() return GAMESTATE:GetCurrentSong():GetDisplayArtist() end,
    function(Steps) return LoadModule("SelectMusic.ObtainBPM.lua")( Steps ) end,
    function() return string.find( GAMESTATE:GetCurrentSong():GetSongDir(), "mem" ) and "Player Memory Card" or GAMESTATE:GetCurrentSong():GetSongDir() end,
    function() return string.find( GAMESTATE:GetCurrentSong():GetSongDir(), "mem" ) and "N/A" or GetOrdinalSongRank() end,
    function() return math.floor(GAMESTATE:GetCurrentSong():MusicLengthSeconds()) == 105 and "Patched" or  SecondsToMMSS( math.floor(GAMESTATE:GetCurrentSong():MusicLengthSeconds())) end,
    Widths = { 430,430,600,80,80 }
}
for _,v in pairs( GAMESTATE:Env()["AngryGrandpa"] and Labels.Grandpa or Labels.Normal ) do
    for a,e in pairs(v) do
        t[#t+1] = Def.BitmapText{
            Font="novamono/36/_novamono 36px",
            Text=THEME:GetString("SongInfo",e)..":",
            OnCommand=function(s)
                s:halign(1):xy( SCREEN_CENTER_X-48+(310*(_-1)), SCREEN_CENTER_Y-61+(16*a) ):diffuse(color("#FFA314"))
                :zoom(0.6):maxwidth(84)
            end,
        }

        t[#t+1] = Def.BitmapText{
            Font="novamono/36/_novamono 36px",
            OnCommand=function(s)
                s:halign(0):xy( SCREEN_CENTER_X-48+(310*(_-1)), SCREEN_CENTER_Y-61+(16*a) )
                :zoom(0.6):playcommand("Update")
            end,
            CurrentSongChangedMessageCommand=function(s) s:playcommand("Update") end,
            CurrentStepsP1ChangedMessageCommand=function(s) s:playcommand("Update") end,
            CurrentStepsP2ChangedMessageCommand=function(s) s:playcommand("Update") end,
            UpdateCommand=function(s)
                s:settext("")
                local index = a+(3*(_-1))
                local Steps = GAMESTATE:GetCurrentSteps( GAMESTATE:GetMasterPlayerNumber() )
                if GAMESTATE:GetCurrentSong() then
                    s:settext( " ".. data[index](Steps) ):maxwidth( data.Widths[ _*a ] )
                end
            end,
        }
    end
end

t[#t+1] = LoadActor("../TotalPlaytime.lua")

return t;