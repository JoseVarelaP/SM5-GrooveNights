-- If there are profiles, an animation must carry out.
if PROFILEMAN:GetNumLocalProfiles() > 0 then
	return Def.ActorFrame{
		loadfile( THEME:GetPathB("Transitions/Arrow","Out") )()
	}
end

return Def.ActorFrame{}