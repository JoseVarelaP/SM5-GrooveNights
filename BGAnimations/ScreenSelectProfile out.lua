local isArcadeSetting = GAMESTATE:GetCoinMode() ~= "CoinMode_Home"

if isArcadeSetting then
	return Def.ActorFrame{
		Def.Quad{
			OnCommand=function(self)
				self:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,SCREEN_HEIGHT):diffuse(Color.Black)
				:addy( SCREEN_HEIGHT/2 ):decelerate(0.2):addy( -SCREEN_HEIGHT/2 )
			end
		},
		Def.Quad{
			OnCommand=function(self)
				self:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,0):diffuse(Color.Black)
				:addy( -SCREEN_HEIGHT/2 ):decelerate(0.2):addy( SCREEN_HEIGHT/2 )
			end
		},

		Def.Sound{
			IsAction = true,
			File = THEME:GetPathS("gnScreenTransition whoosh", "short"),
			StartTransitioningCommand = function(self)
				self:play()
			end
		},

		Def.Sprite{
			Texture=THEME:GetPathG("","TransitionArrow"),
			OnCommand=function(self)
				self:xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100):zoom(1.9):decelerate(0.2):y( SCREEN_CENTER_Y )
			end
		},

		Def.ActorFrame{
			Def.BitmapText{
				Font="journey/40/_journey 40px",
				Text="GrooveNights",
				OnCommand=function(self)
					self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-10):zoom(1.4)
					:diffusealpha(0):sleep(0.2):linear(0.2):diffusealpha(1)
				end
			}
		}
	}
end

return Def.ActorFrame{ loadfile( THEME:GetPathB("Transitions/Arrow","Out") )() }