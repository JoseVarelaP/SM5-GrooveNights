return Def.ActorFrame{
    Def.Sprite{
        Texture="WheelItems/Song",
        OnCommand=function(self) self:diffuse( color("#1C2C3C") ):zoomto(320,32) end
    }
}