local t = Def.ActorFrame{
	OnCommand=function(self)
		self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):zoom( (SCREEN_WIDTH/640) )
	end
}

t[#t+1] = Def.Sprite{
	Texture="easter_eggs/ice.png",
	OnCommand=function(self)
		self:zoom(1.2):diffusealpha(0):croptop(0.9):fadetop(0.1):blend("BlendMode_Add")
		:sleep(0):linear(1):diffusealpha(0.5):linear(3.5):croptop(0):fadetop(0)
	end,
}

for i=1,3 do
	for e=1,6 do
		local num = e+(6*(i-1))
		t[#t+1] = Def.Sprite{
			Texture="easter_eggs/line".. e,
			OnCommand=function(self)
				self:y( 200-(30*(num-1)) ):diffusealpha(0):sleep( 0.2*(num+1) )
				:linear(1):diffusealpha(1):linear(1):diffusealpha(0)
			end
		}
	end
end

return t