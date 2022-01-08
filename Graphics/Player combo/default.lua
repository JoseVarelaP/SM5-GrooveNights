local c
local player = Var "Player"
local PDir = (
	(PROFILEMAN:GetProfile(player):GetDisplayName() ~= "" and MEMCARDMAN:GetCardState(player) == 'MemoryCardState_none')
	and PROFILEMAN:GetProfileDir(string.sub(player,-1)-1).."GrooveNights.save"
	or "Save/TEMP"..player
)
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt")
local Pulse = function(self)
	local combo=self:GetZoom()
	local newZoom=scale(combo,0,500,0.9,1.4)
	self:zoom(1.2*newZoom):linear(0.05):zoom(newZoom)
end
local PulseLabel = THEME:GetMetric("Combo", "PulseLabelCommand")
local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom")
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom")
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt")
local LabelMinZoom = THEME:GetMetric("Combo", "LabelMinZoom")
local LabelMaxZoom = THEME:GetMetric("Combo", "LabelMaxZoom")

local isRealProf = LoadModule("Profile.IsMachine.lua")(player)
local settings = {"DefaultComboSize","ToggleComboSize","ToggleComboBounce","ToggleComboExplosion","FlashComboColor"}

for _,v in pairs(settings) do
	-- In case the profile is an actual profile or USB
	if not GAMESTATE:IsDemonstration() then
		if isRealProf then
			settings[_] = LoadModule("Config.Load.lua")(v,PDir)
		-- If not, then we'll use the temporary set for regular players.
		else
			settings[_] = GAMESTATE:Env()[v.."Machinetemp"..player]
		end
	else
		settings = {1,true,true,true,true}
	end
end

local function ColoringBeat(number, label, color1, color2)
	if settings[5] then
		number:diffuseshift():effectcolor1(color1):effectcolor2(color2):effectperiod(0.5)
		label:diffuseshift():effectcolor1(color1):effectcolor2(color2):effectperiod(0.5)
	else
		number:finishtweening():diffuse(color1)
		label:finishtweening():diffuse(color1)
	end
end

local staticzoom = settings[1] or 1
local t = Def.ActorFrame {
	-- These are behind the combo and label for obvious reasons.
	-- 100 Combo milestone
	Def.ActorFrame{
		Condition=tobool(settings[4]),
		
		Def.Sprite{
			Texture="explosion",
			InitCommand=function(self)
				self:diffusealpha(0):blend("BlendMode_Add")
			end,
			HundredMilestoneCommand=function(self)
				self:rotationz(0):zoom(2.6):diffusealpha(0.5):linear(0.5):rotationz(90):zoom(2):diffusealpha(0)
			end
		},

		Def.Sprite{
			Texture="explosion",
			InitCommand=function(self)
				self:diffusealpha(0):blend("BlendMode_Add")
			end,
			HundredMilestoneCommand=function(self)
				self:rotationz(0):zoom(2.6):diffusealpha(0.5):linear(0.5):rotationz(-90):zoom(2):diffusealpha(0)
			end
		},

		Def.Sprite{
			Texture="arrowsplode",
			InitCommand=function(self)
				self:diffusealpha(0)
			end,
			HundredMilestoneCommand=function(self)
				self:rotationz(10):zoom(.25):diffusealpha(1):decelerate(0.5):rotationz(0):zoom(1.3):diffusealpha(0)
			end
		},

		Def.Sprite{
			Texture="minisplode",
			InitCommand=function(self)
				self:diffusealpha(0)
			end,
			HundredMilestoneCommand=function(self)
				self:rotationz(10):zoom(.25):diffusealpha(1):linear(0.5):rotationz(0):zoom(1.3):diffusealpha(0)
			end
		},

		-- 1000 Combo milestone
		Def.Sprite{
			Texture="explosion",
			InitCommand=function(self)
				self:diffusealpha(0):blend("BlendMode_Add")
			end,
			ThousandMilestoneCommand=function(self)
				self:rotationz(0):zoom(2.6):diffusealpha(0.5):linear(0.5):rotationz(90):zoom(2):diffusealpha(0)
			end
		},

		Def.Sprite{
			Texture="explosion",
			InitCommand=function(self)
				self:diffusealpha(0):blend("BlendMode_Add")
			end,
			ThousandMilestoneCommand=function(self)
				self:rotationz(0):zoom(2.6):diffusealpha(0.5):linear(0.5):rotationz(-90):zoom(2):diffusealpha(0)
			end
		},

		Def.Sprite{
			Texture="shot",
			InitCommand=function(self)
				self:diffusealpha(0):blend("BlendMode_Add")
			end,
			ThousandMilestoneCommand=function(self)
				self:zoomx(-2):zoomy(2):diffusealpha(1):x(0):linear(0.5):diffusealpha(0):x(-150)
			end
		},

		Def.Sprite{
			Texture="shot",
			InitCommand=function(self)
				self:diffusealpha(0):blend("BlendMode_Add")
			end,
			ThousandMilestoneCommand=function(self)
				self:zoomx(2):zoomy(2):diffusealpha(1):x(0):linear(0.5):diffusealpha(0):x(150)
			end
		}
	},

	Def.BitmapText{
		-- TODO: Either add engine function to provide adding x positioning to the current glyph or make a separate number set for combo.
		Font="journey/number/_journey even 40",
		Name="Number",
		OnCommand = function(self) self:valign(1):zoomx(1.2):y(0) end,
		ComboCommand=function(self)
			if self:GetText() and self:GetText() ~= "" then
				local zoomed = settings[2] and (scale( self:GetText() ,0,500,0.9,1.4) > 1.4 and 1.4 or scale( self:GetText() ,0,500,0.9,1.4)) or 1
				if PDir and settings[3] then
					self:finishtweening():zoom( (1.05*zoomed)*staticzoom ):linear(0.05):zoom( zoomed*staticzoom )
				else
					self:finishtweening():zoom( staticzoom )
				end
			end
		end
	},
	Def.BitmapText{
		Font="journey/40/_journey 40",
		Text=THEME:GetString("ScreenGameplay","Combo"),
		Name="Label",
		OnCommand = function(self) self:valign(0):zoomy(0.6) end,
		ComboCommand=function(self)
			self:finishtweening()
			if PDir and settings[3] then
				self:zoom( 1.05*staticzoom ):linear(0.05):zoom( 1*staticzoom )
			else
				self:zoom( staticzoom )
			end
		end
	},
	Def.BitmapText{
		Font="journey/40/_journey 40",
		Text=THEME:GetString("ScreenGameplay","Misses"),
		Name="Misses",
		OnCommand = function(self) self:valign(0):diffuse(Color.Red) end,
		ComboCommand=function(self)
			self:finishtweening()
			if PDir and settings[3] then
				self:zoom( 1.05*staticzoom ):linear(0.05):zoom( 1*staticzoom )
			else
				self:zoom( staticzoom )
			end
		end
	},
	
	InitCommand = function(self)
		c = self:GetChildren()
		c.Number:visible(false)
		c.Label:visible(false)
		c.Misses:visible(false)
	end,
	ComboCommand=function(self, param)
		local iCombo = param.Misses or param.Combo
		if not iCombo or iCombo < ShowComboAt then
			c.Number:visible(false):y(6)
			c.Label:visible(false):y(0)
			c.Misses:y(0)
			return
		end

		c.Label:visible(false)

		param.Zoom = scale( iCombo, 0, NumberMaxZoomAt, NumberMinZoom, NumberMaxZoom )
		param.Zoom = clamp( param.Zoom, NumberMinZoom, NumberMaxZoom )
		
		param.LabelZoom = scale( iCombo, 0, NumberMaxZoomAt, LabelMinZoom, LabelMaxZoom )
		param.LabelZoom = clamp( param.LabelZoom, LabelMinZoom, LabelMaxZoom )
		
		c.Number:visible(true):settext( string.format("%i", iCombo) )
		c.Label:visible(true)
		-- FullCombo Rewards
		if param.FullComboW1 then
			ColoringBeat(c.Number, c.Label, color("#9BD8EC"), color("#6ECDEC"))
		elseif param.FullComboW2 then
			ColoringBeat(c.Number, c.Label, color("#FFDD77"), color("#FFCC33"))
		elseif param.FullComboW3 then
			ColoringBeat(c.Number, c.Label, color("#9BE999"), color("#42E93D"))
		elseif param.Combo then
			c.Number:diffuse(Color("White")):stopeffect()
			c.Label:stopeffect():diffuse(Color("White"))
			c.Misses:visible(false)
		else
			c.Number:diffuse(color("#ff0000")):stopeffect()
			c.Label:visible(false):stopeffect()
			c.Misses:visible(true)
		end

		c.Number:finishtweening()
		c.Label:finishtweening()
		-- Pulse
		if LoadModule("Config.Load.lua")("ToggleComboBounce",PDir) then
			Pulse( c.Number )
			PulseLabel( c.Label, param )
			PulseLabel( c.Misses, param )
		end
		-- Milestone Logic
	end
}

return t