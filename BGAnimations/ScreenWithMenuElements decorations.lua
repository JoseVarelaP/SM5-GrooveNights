local t = Def.ActorFrame{}

local Months = {"January","February","March","April","May","June","July","August","September","October","November","December"}
-- Cache translated strings of the months to avoid having to check strings every time.
local translatedmonths = {}
for k,v in pairs(Months) do
	translatedmonths[#translatedmonths+1] = THEME:GetString("Months",v)
end
t[#t+1] = Def.BitmapText{
    Font="Common Normal",
    Condition=LoadModule("Config.Load.lua")("ToggleSystemClock","Save/GrooveNightsPrefs.ini"),
    OnCommand=function(s)
        s:align(.5,1):xy( SCREEN_CENTER_X, (SCREENMAN:GetTopScreen():GetName() == "ScreenGameplay" or GAMESTATE:IsDemonstration()) and SCREEN_BOTTOM-20 or 23  ):zoom(0.5):diffusealpha( 0.8 ):vertspacing( -10 )
        :playcommand("Update")
    end,
    UpdateCommand=function(s)
        local isPM = Hour() > 12
        local CurHour = isPM and (Hour()-12) or Hour()
        s:settext( DayOfMonth() .."/".. translatedmonths[MonthOfYear()+1] .."/".. Year() .."\n"..CurHour ..":".. string.format("%02i", Minute()).. (isPM and " PM" or " AM")  )
        :sleep(30/60):queuecommand("Update")
    end,
}

return t