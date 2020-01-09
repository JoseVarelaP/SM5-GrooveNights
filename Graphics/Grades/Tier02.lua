local starpos = {
	{-90,60},
	{0,-60},
	{85,60}
}

local player = ...

local t = Def.ActorFrame{
	OnCommand=function(s)
		s:zoom(0.2):xy(-1,-1):wag():effectmagnitude(0,0,2)
	end,
}

for _,v in pairs(starpos) do
	t[#t+1] = Def.ActorFrame{
		OnCommand=function(s) s:hibernate(0.3*(_-1)):xy(v[1],v[2]):sleep(1.4):queuecommand("Update") end,
		UpdateCommand=function(s)
			s:decelerate(0.3):zoom(1.1):accelerate(0.3):zoom(1):decelerate(0.3):zoom(0.9):diffusealpha(0.9):accelerate(0.3):zoom(1):diffusealpha(1):queuecommand("Update")
		end,

		Def.Sprite{
			Texture=LoadModule("Score.CustomTierGraphic.lua")(player,2),
			OnCommand=function(s) s:sleep(0.2) end,
			InitCommand=function(s)
				s:diffusealpha(0)
				:sleep(0.2)
				:queuecommand("GradeSound"):decelerate(0.6):zoom(1.7):diffusealpha(1):accelerate(0.4):zoom(1.3)
				:decelerate(0.1):zoom(1.1):diffusealpha(0.8):accelerate(0.1):zoom(1.3):diffusealpha(1)
			end,
			GradeSoundCommand=function(s)
				SOUND:PlayOnce( THEME:GetPathS("gnGradeUp",_) )
			end,
		}
	}
end

return t;

--[[
<ActorFrame	InitCommand="queuecommand,Start;"
			StartCommand="%function(self)
			if getSpecialUSB() then
				if gnDimBGMSeconds == nil then
					gnDimBGMSeconds = 0.1;
					end
				if gnDimBGMSeconds ~= 0 then
					SOUND:DimMusic( 0, gnDimBGMSeconds )
					end
				end
			end">
	<children>
		<ActorFrame	Condition="(GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_2))"
		InitCommand="queuecommand,Start;"
					StartCommand="%function(self)
		if gnCustomPlayed ~= nil then
			gnCustomPlayed = nil;
			self:hibernate(9999);
			else
						if not getSpecialUSB() then
							self:addx(200000);
							end
			end
					end">
			<children>
			<Layer Type="Quad"
			InitCommand="%function(self)
			self:diffusealpha(0);
			if GAMESTATE:IsHumanPlayer(PLAYER_1) then
				self:x(245+AddFromCenter('x','Double',PLAYER_1));
				else
				self:x(-64+AddFromCenter('x','Double',PLAYER_2));
				end
			if GAMESTATE:IsHumanPlayer(PLAYER_1) then self:y(40+AddFromCenter('y','Double',PLAYER_1)); else  self:y(40+AddFromCenter('y','Double',PLAYER_2)); end
			self:queuecommand('ColourIt');
			end"
			ColourItCommand="diffuse,0,0,0,1;zoom,2;decelerate,0.5;zoom,1;diffuse,0,0,0,0.8;zoom,5000;queuecommand,Duration;"
			DurationCommand="%function(self)
				if gnDimBackgroundSeconds == nil then
					gnDimBackgroundSeconds = 0.1;
					end
				if gnDimBackgroundSeconds == 0 then
					gnDimBackgroundSeconds = 0.1;
					end
			self:sleep(gnDimBackgroundSeconds);
			self:linear(1);
			self:diffusealpha(0);
			end"
			OffCommand="accelerate,0.3;zoom,0;"
			/>
		</children></ActorFrame>
		
		<ActorFrame	Condition="not (GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_2))"
		InitCommand="queuecommand,Start;"
					StartCommand="%function(self)
						if not getSpecialUSB() then
							self:addx(200000);
							end
					end">
			<children>
			<Layer Type="Quad"
			InitCommand="%function(self)
			self:diffusealpha(0);
			if GAMESTATE:IsHumanPlayer(PLAYER_1) then
				self:x(245+AddFromCenter('x','Double',PLAYER_1));
				else
				self:x(-64+AddFromCenter('x','Double',PLAYER_2));
				end
			if GAMESTATE:IsHumanPlayer(PLAYER_1) then self:y(40+AddFromCenter('y','Double',PLAYER_1)); else  self:y(40+AddFromCenter('y','Double',PLAYER_2)); end
			self:queuecommand('ColourIt');
			end"
			ColourItCommand="diffuse,0,0,0,1;zoom,2;decelerate,0.5;zoom,1;diffuse,0,0,0,0.8;zoom,5000;queuecommand,Duration;"
			DurationCommand="%function(self)
				if gnDimBackgroundSeconds == nil then
					gnDimBackgroundSeconds = 0.1;
					end
				if gnDimBackgroundSeconds == 0 then
					gnDimBackgroundSeconds = 0.1;
					end
			self:sleep(gnDimBackgroundSeconds);
			self:linear(1);
			self:diffusealpha(0);
			end"
			OffCommand="accelerate,0.3;zoom,0;"
			/>
		</children></ActorFrame>
		
		
		<Layer File="@'../../Sounds/'..getCustomDoubleImageOrVideo()" 
		Condition="(GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_2))"
		InitCommand="%function(self)
		if gnCustomPlayed ~= nil then
			gnCustomPlayed = nil;
			self:hibernate(9999);
			else
				self:x(-66+AddFromCenter('x','Double',PLAYER_2));
				self:y(40+AddFromCenter('y','Double',PLAYER_2));
				self:diffusealpha(0);
				self:zoom(2);
				self:decelerate(0.5);
				self:diffusealpha(gnDiffusealpha);
				self:zoom(gnZoom);
				gnPath = getCustomDoubleSound();
				SOUND:PlayOnce(gnPath);
						if gnOnScreenSeconds == nil then
							gnOnScreenSeconds = 0.1;
							end
						if gnOnScreenSeconds == 0 then
							gnOnScreenSeconds = 0.1;
							end
				self:sleep(gnOnScreenSeconds);
				self:linear(1);
				self:diffusealpha(0)
				end
			end"
		OffCommand="accelerate,0.3;zoom,0;"
		/>
		
<Layer File="@'../../Sounds/'..getCustomDoubleImageOrVideo()" 
		Condition="not (GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_2))"
		InitCommand="%function(self)
				if GAMESTATE:IsHumanPlayer(PLAYER_1) then
					self:x(244+AddFromCenter('x','Double',PLAYER_1));
					else
					self:x(-66+AddFromCenter('x','Double',PLAYER_2));
					end
				if GAMESTATE:IsHumanPlayer(PLAYER_1) then self:y(40+AddFromCenter('y','Double',PLAYER_1)); else  self:y(40+AddFromCenter('y','Double',PLAYER_2)); end
				self:diffusealpha(0);
				self:zoom(2);
				self:decelerate(0.5);
				self:diffusealpha(gnDiffusealpha);
				self:zoom(gnZoom);
				gnPath = getCustomDoubleSound();
				SOUND:PlayOnce(gnPath);
						if gnOnScreenSeconds == nil then
							gnOnScreenSeconds = 0.1;
							end
						if gnOnScreenSeconds == 0 then
							gnOnScreenSeconds = 0.1;
							end
				self:sleep(gnOnScreenSeconds);
				self:linear(1);
				self:diffusealpha(0)
			end"
		OffCommand="accelerate,0.3;zoom,0;"
		/>

		<ActorFrame
			OnCommand="zoom,0.2;x,-1;y,-1;wag;EffectMagnitude,0,0,2"
		>
			<children>
				<ActorFrame
					OnCommand="x,-55;y,60;sleep,1.4;queuecommand,Update;"
					UpdateCommand="decelerate,0.3;zoom,1.1;accelerate,0.3;zoom,1;decelerate,0.3;zoom,0.9;diffusealpha,0.9;accelerate,0.3;zoom,1;diffusealpha,1;queuecommand,Update;"
				>
					<children>
						<Layer
							File="@getResultStars('0003')"
							InitCommand="diffusealpha,0;sleep,0.2;queuecommand,GradeSound;decelerate,0.6;zoom,1.5;diffusealpha,1;accelerate,0.4;zoom,1;decelerate,0.1;zoom,0.9;diffusealpha,0.8;accelerate,0.1;zoom,1;diffusealpha,1;"
							OnCommand="sleep,0.2;"
							GradeSoundCommand="%function(self)
							gnSound = GradeSound(5);
							SOUND:PlayOnce( gnSound )
							end"
						/>
					</children>
				</ActorFrame>
				<ActorFrame
					OnCommand="hibernate,0.3;x,50;y,-50;sleep,1.4;queuecommand,Update;"
					UpdateCommand="decelerate,0.3;zoom,1.1;accelerate,0.3;zoom,1;decelerate,0.3;zoom,0.9;diffusealpha,0.9;accelerate,0.3;zoom,1;diffusealpha,1;queuecommand,Update;"
				>
					<children>
						<Layer
							File="@getResultStars('0003')"
							InitCommand="diffusealpha,0;sleep,0.2;queuecommand,GradeSound;decelerate,0.6;zoom,1.5;diffusealpha,1;accelerate,0.4;zoom,1;decelerate,0.1;zoom,0.9;diffusealpha,0.8;accelerate,0.1;zoom,1;diffusealpha,1;"
							OnCommand="sleep,0.2;"
							GradeSoundCommand="%function(self)
							gnSound = GradeSound(6);
							SOUND:PlayOnce( gnSound )
							end"
						/>
					</children>
				</ActorFrame>
			</children>
		</ActorFrame>
	</children>
</ActorFrame>
]]