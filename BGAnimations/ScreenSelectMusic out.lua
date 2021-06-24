local t = Def.ActorFrame{}

t[#t+1] = Def.Quad{
	OnCommand=function(s) s:stretchto(SCREEN_WIDTH*1.2,SCREEN_HEIGHT,0,0):diffuse( Alpha(Color.Black,1) ):cropleft(1):fadeleft(0) end,
	ShowPressStartForOptionsCommand=function(s) s:fadeleft(0.1):linear(0.1):cropleft(0) end,
}

local enteroptions = Screen.String("EnteringOptions")
t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		self:xy( SCREEN_CENTER_X, SCREEN_CENTER_Y+78 )

		local textwidth = self:GetChild("MainText"):GetZoomedWidth()

		self:zoom( LoadModule("Lua.Resize.lua")( textwidth, self:GetChild("MainText"):GetZoomedHeight(), SCREEN_WIDTH*0.6, SCREEN_HEIGHT*0.6 ) )

		self:GetChild("Cover"):zoomto( textwidth+8, self:GetChild("MainText"):GetZoomedHeight()+10 )
		--self:GetChild("Button"):x( -textwidth*.09 )
	end,
	ShowEnteringOptionsCommand=function(self)
		self:GetChild("MainText"):settext( enteroptions )
		local textwidth = self:GetChild("MainText"):GetZoomedWidth()
		self:zoom( LoadModule("Lua.Resize.lua")( textwidth, self:GetChild("MainText"):GetZoomedHeight(), SCREEN_WIDTH*0.6, SCREEN_HEIGHT*0.6 ) )
	end,
	
	Def.BitmapText{
		Font="journey/40/_journey 40",
		Name="MainText",
		Text=Screen.String("PressStartOptions"),
		InitCommand=function(self) self:strokecolor(Color.Black):zoom(1.4) end,
	},
	
	Def.Quad{
		Name="Cover",
		InitCommand=function(self) self:y( 6 ):diffuse(Color.Black) end,
		ShowPressStartForOptionsCommand=function(self)
			self:diffusealpha(1):faderight(.3):fadeleft(.3):cropright(-0.3):cropleft(-0.3):linear(0.3):cropleft(1.3)
			-- Ending fade is here because the HideMessageCommand happens too late.
			:sleep(1.5):cropright(1.3):cropleft(-0.3):linear(0.3):cropright(-0.3)
		end,
		ShowEnteringOptionsCommand=function(self)
			-- When the player needs to go to the menu, force the crop to the end state.
			self:stoptweening():cropleft(1.3)
		end
	}
}

t[#t+1] = Def.Sound{
	IsAction = true,
	File = THEME:GetPathS("gnScreenTransition whoosh", "short"),
	ShowPressStartForOptionsCommand = function(self)
		self:play()
	end
}

t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathG("","TransitionArrow"),
	OnCommand=function(self)
		self:visible(false)
	end,
	ShowPressStartForOptionsCommand=function(self)
		self:visible(true):xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100):decelerate(0.2):y( SCREEN_CENTER_Y )
		:vibrate():effectmagnitude(1,1,0):sleep(0.3)
	end,
}

return t;
