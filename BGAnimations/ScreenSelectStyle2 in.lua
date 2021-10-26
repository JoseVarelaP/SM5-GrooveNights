local isArcadeSetting = GAMESTATE:GetCoinMode() ~= "CoinMode_Home"
return Def.ActorFrame{
	Def.Quad{
		OnCommand=function(self)
			self:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,SCREEN_HEIGHT):diffuse(Color.Black)
			:sleep(isArcadeSetting and 0.6 or 0):decelerate(0.2):addy( SCREEN_HEIGHT/2 )
		end
	},
	Def.Quad{
		OnCommand=function(self)
			self:stretchto(SCREEN_WIDTH,SCREEN_HEIGHT/2,0,0):diffuse(Color.Black)
			:sleep(isArcadeSetting and 0.6 or 0):decelerate(0.2):addy( -SCREEN_HEIGHT/2 )
		end
	},

	Def.ActorFrame{
		Condition=isArcadeSetting,
		Def.Sprite{
			Texture=THEME:GetPathG("","TransitionArrow"),
			OnCommand=function(s)
				s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom(1.9):decelerate(0.1):zoom(2.1):easeinoutquad(0.35):zoom(1)
				:sleep(0.1):accelerate(.2):y( -200 )
			end,
		},
	
		Def.BitmapText{
			Font="journey/40/_journey 40px",
			Text="GrooveNights",
			OnCommand=function(self)
				self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-10):zoom(1.4):sleep(0.05):decelerate(0.1):zoom(1.6):easeinoutquad(0.35):zoom(1)
				:sleep(0.05):accelerate(.2):y( SCREEN_HEIGHT+200 )
			end
		}
	}
}