local t = Def.ActorFrame {
	InitCommand = function (self)
		self:RunCommandsRecursively(function (self)
			self:MaskDest()
		end)
	end
}

t[#t+1] = Def.Sprite {
	Texture = THEME:GetPathG("ScreenSystemLayer","MessageFrame"),
	InitCommand=function (self)
		self:diffusealpha(0.8):zoomto(640,48):diffuse( color("#1C2C3C") ):fadeleft(0.1):faderight(0.1)
	end
}


t[#t+1] = Def.TextBanner {
	InitCommand=function (self)
		self:x(-300):y(0):Load("TextBannerHighScores")
	end,
	SetCommand=function(self, params)
		if params.Song then
			self:SetFromSong( params.Song ):diffuse( SONGMAN:GetSongColor(params.Song) )
		else
			self:SetFromString( params.Course:GetTitle() ):diffuse( SONGMAN:GetCourseColor(params.Course) )
		end
	end
}

local NumColumns = THEME:GetMetric(Var "LoadingScreen", "NumColumns")

local c
local Scores = Def.ActorFrame {
	InitCommand = function(self)
		c = self:GetChildren()
	end
}
t[#t+1] = Scores

for idx=1,NumColumns do
	local x_pos = -60 + 80 * (idx-1)
	Scores[#Scores+1] = LoadActor("filled") .. {
		Name = idx .. "Filled";
		InitCommand=function (self)
			self:x(x_pos)
		end
	}
	Scores[#Scores+1] = Def.BitmapText{
		Font="Common Normal",
		Name = idx .. "Name",
		InitCommand=function (self)
			self:xy(x_pos,6):shadowlengthy(2):shadowcolor(color("#000000")):maxwidth(68):zoom(0.6)
		end
	}
	Scores[#Scores+1] = Def.BitmapText {
		Font = "Common Normal",
		Name = idx .. "Score",
		InitCommand=function (self)
			self:xy(x_pos,-10):zoom(0.7):shadowlengthy(2):shadowcolor(color("#000000")):maxwidth(68)
		end
	}
end

Scores.SetCommand=function(self, params)
	local pProfile = PROFILEMAN:GetMachineProfile()

	for name, child in pairs(c) do
		child:visible(false)
	end

	local Current = params.Song or params.Course;
	if Current then
		for idx, CurrentItem in pairs(params.Entries) do
			if CurrentItem then
				local hsl = pProfile:GetHighScoreList(Current, CurrentItem)
				local hs = hsl and hsl:GetHighScores()
				local name = c[idx .. "Name"]
				local score = c[idx .. "Score"]
				local filled = c[idx .. "Filled"]
				name:visible( true )
				score:visible( true )
				filled:visible( true ):diffuse( ColorLightTone(DifficultyColor(CurrentItem:GetDifficulty())) )
				if hs and #hs > 0 then
					name:settext( hs[1]:GetName() )
					score:settext( FormatPercentScore( hs[1]:GetPercentDP() ) )
				else
					name:settext( "----" )
					score:settext( FormatPercentScore( 0 ) )
				end
			end
		end
	end
end

return t
