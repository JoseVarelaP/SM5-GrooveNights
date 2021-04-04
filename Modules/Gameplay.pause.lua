local Paused = false
local CurSel = 1

local Choices = {
	{
		Name = "continue_playing",
		Action = function( screen )
			screen:PauseGame(false)
		end
	},
	{
		Name = "restart_song",
		Action = function( screen )
			screen:SetPrevScreenName('ScreenStageInformation'):begin_backing_out()
		end
	},
	{
		Name = "forfeit_song",
		Action = function( screen )
			screen:SetPrevScreenName(SelectMusicOrCourse()):begin_backing_out()
		end
	},
}

if GAMESTATE:IsCourseMode() then
	Choices = {
		{
			Name = "continue_playing",
			Action = function( screen )
				screen:PauseGame(false)
			end
		},
		{
			Name = "skip_song",
			Action = function( screen )
				screen:PostScreenMessage('SM_NotesEnded', 0)
			end
		},
		{
			Name = "forfeit_course",
			Action = function( screen )
				screen:SetPrevScreenName(SelectMusicOrCourse()):begin_backing_out()
			end
		},
		{
			Name = "end_course",
			Action = function( screen )
				screen:PostScreenMessage('SM_NotesEnded', 0)
			end
		},
	}
end

local Selections = Def.ActorFrame{
	Name="Selections",
	InitCommand=function(self)
		-- As this process is starting, we'll already highlight the first option with the color.
		self:GetChild(1):playcommand("GainFocus")
	end,

	Def.Sprite{
		Texture=THEME:GetPathB("ScreenTitleMenu","underlay/HomeFrame"),
	}
}

local function ChangeSel(self,offset)
	-- Do not allow cursor to move if we're not in the pause menu.
	if not Paused then return end

	CurSel = CurSel + offset
	if CurSel < 1 then CurSel = 1 end
	if CurSel > #Choices then CurSel = #Choices end
	
	for i = 1,#Choices do
		self:GetChild("Selections"):GetChild(i):stoptweening():playcommand( i == CurSel and "GainFocus" or "LoseFocus" )
	end
end

local menu_item_height = 48
local menu_spacing= menu_item_height + 12
local menu_bg_width= SCREEN_WIDTH * .2
local menu_text_width= SCREEN_WIDTH * .35
local middlepoint = menu_item_height * #Choices
for i,v in ipairs(Choices) do
	Selections[#Selections+1] = Def.ActorFrame {
		Name=i,
		InitCommand=function(self)
			self:y( (- (middlepoint*.6) ) +((menu_item_height - 6)*i)):zoom(.75)
		end,
		Def.BitmapText{
			Font="journey/40/_journey 40px",
			Text=THEME:GetString("PauseMenu", v.Name),
			InitCommand= function(self)
				self.originalwidth = self:GetZoomedWidth()
				self.maximum = LoadModule("Lua.Resize.lua")( self:GetZoomedWidth(), self:GetZoomedHeight(), 180, 80 )
				self:zoom(0.75):diffuse( color("#777777") )
				--self:diffuse( ColorTable["menuTextGainFocus"] ):playcommand("LoseFocus")
			end,
			LoseFocusCommand= function(self) self:tween(0.2,"easeoutcircle"):zoom(0.75):diffuse( color("#777777") ) end,
			GainFocusCommand= function(self) self:tween(0.2,"easeoutcircle"):zoom( self.originalwidth > 120 and self.maximum or 0.75 ):diffuse( Color.White ) end,
		}
	}
end

return Def.ActorFrame{
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(LoadModule("Lua.InputSystem.lua")(self))
		self:visible(false):Center()
		ChangeSel(self,0)
	end,
	NonGameBackCommand=function(self)
		if not Paused then 
			SCREENMAN:GetTopScreen():PauseGame(true) 
			ChangeSel(self,0)
			self:visible(true)
			self:GetChild("Dim"):playcommand("ShowOrHide",{state=true})
		end
		Paused = true
	end,
	NonGameStartCommand=function(self)
		if Paused then 
			Choices[CurSel].Action( SCREENMAN:GetTopScreen() )
			self:visible(false)
			self:GetChild("Dim"):playcommand("ShowOrHide",{state=false})
		end
		Paused = false
	end,
	MenuLeftCommand=function(self) ChangeSel(self,-1) end,
	MenuRightCommand=function(self) ChangeSel(self,1) end,
	MenuUpCommand=function(self) ChangeSel(self,-1) end,
	MenuDownCommand=function(self) ChangeSel(self,1) end,
	Def.Quad{
		Name="Dim",
		InitCommand=function(self)
			self:stretchto(SCREEN_WIDTH*-1,SCREEN_HEIGHT*-1,SCREEN_WIDTH,SCREEN_HEIGHT):diffuse( Color.Black ):diffusealpha(0)
		end,
		ShowOrHideCommand=function(self,param)
			self:stoptweening():linear(0.2):diffusealpha( param.state and 0.5 or 0 )
		end
	},
	Selections
}