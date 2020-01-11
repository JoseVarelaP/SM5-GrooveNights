return Def.ActorFrame{
    Def.Sprite{
        Texture="WheelItems/SectionCollapsed",
        OnCommand=function(s) s:diffuse( color("#1C2C3C") ):zoomto(320,32) end,
    }
}