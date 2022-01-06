-- If there are profiles, an animation must carry out.
if PROFILEMAN:GetNumLocalProfiles() > 0 then
	return Def.ActorFrame{
		loadfile( THEME:GetPathB("Transitions/Arrow","Out") )()
	}
end

return Def.Quad{
	OnCommand=function(s)
		s:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT,0,0):diffuse(Color.Black):diffusealpha(0):linear(0.1)
		:diffusealpha(1):sleep(0.3)
	end
}