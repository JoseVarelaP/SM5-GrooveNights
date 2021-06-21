return Def.ActorFrame{
	Def.Sprite{
		Texture="WheelItems/SectionCollapsed",
		OnCommand=function(self) self:diffuse( color("#060A0E") ):zoomto(320,32) end
	}
}