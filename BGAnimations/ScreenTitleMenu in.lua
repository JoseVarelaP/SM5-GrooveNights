return Def.ActorFrame{
	Condition = GAMESTATE:Env()["NeedsTransition"],
	loadfile( THEME:GetPathB("Transitions/Arrow","In") )()
}