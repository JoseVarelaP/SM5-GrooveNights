return Def.ActorFrame{
    Def.Sprite{
    Texture="HomeFrame",
    OnCommand=function(s)
        s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+130)
        :diffusealpha(0):linear(0.3):diffusealpha(0.8)
        :zoomx(1.1)

        local ogfall = LoadModule("Config.Load.lua")("MachineOffset","Save/GrooveNightsPrefs.ini")

        if ogfall then
            local curoffset = string.format( "%.3f", PREFSMAN:GetPreference( "GlobalOffsetSeconds" ) )
            --lua.ReportScriptError( tostring(ogfall) .. " - " .. tostring(curoffset) )
            if ogfall ~= curoffset then
                SCREENMAN:SystemMessage("Diverging offset detected, resetting to last known original state. (" .. ogfall .. ")")
                PREFSMAN:SetPreference( "GlobalOffsetSeconds", ogfall )
            end
        end
    end,
    CodeMessageCommand=function(s,param)
        SCREENMAN:SystemMessage( param.Name .." code Activated" )
        GAMESTATE:Env()[param.Name] = true
    end;
    }
}
