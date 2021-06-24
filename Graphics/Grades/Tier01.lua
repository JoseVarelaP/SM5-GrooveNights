local starpos = {
	{-90,80},
	{-90,-80},
	{85,-80},
	{85,80}
}

local Data = ...

local t = Def.ActorFrame{
	OnCommand=function(self)
		self:zoom(0.2):xy(-1,-1):wag():effectmagnitude(0,0,2)
	end
}

for _,v in pairs(starpos) do
	t[#t+1] = Def.ActorFrame{
		OnCommand=function(self) self:hibernate(0.3*(_-1)):xy(v[1],v[2]):sleep(1.4):queuecommand("Update") end,
		UpdateCommand=function(self)
			self:decelerate(0.3):zoom(1.1):accelerate(0.3):zoom(1):decelerate(0.3):zoom(0.9):diffusealpha(0.9):accelerate(0.3):zoom(1):diffusealpha(1):queuecommand("Update")
		end,

		Def.Sound{
			Name = "GradeSound",
			File = THEME:GetPathS("gnGradeUp",_),
		},

		Def.Sprite{
			Texture=LoadModule("Score.CustomTierGraphic.lua")(Data[1],1),
			OnCommand=function(self) self:sleep(0.2) end,
			InitCommand=function(self)
				self:diffusealpha(0)
				:sleep(0.2)
				:queuecommand("GradeSound"):decelerate(0.6):zoom(1.7):diffusealpha(1):accelerate(0.4):zoom(1.3)
				:decelerate(0.1):zoom(1.1):diffusealpha(0.8):accelerate(0.1):zoom(1.3):diffusealpha(1)
			end,
			GradeSoundCommand=function(self)
				self:GetParent():GetChild("GradeSound"):play()
			end
		}
	}
end

-- Fireworks
-- TODO: Potential refactor here
t[#t+1] = Def.ActorFrame{
	OnCommand=function(self) self:zoom(.5):xy(-1,-1):wag():effectmagnitude(0,0,2) end,

	Def.ActorFrame{
		OnCommand=function(self) self:hibernate(1.4):zoom(8):draworder(-2000) end,
		
		Def.ActorFrame{
			OnCommand=function(self) self:xy(-20,20):sleep(1.4):queuecommand("Update") end,
			UpdateCommand=function(self)
				self:decelerate(0.3):zoom(1.1):accelerate(0.3):zoom(1):decelerate(0.3)
				:zoom(0.9):diffusealpha(0.9):accelerate(0.3):zoom(1):diffusealpha(1):queuecommand("Update")
			end,
			--fworkgreen1
			Def.Sprite{
				Texture="fireworks",
				Frame0000=4,
				Delay0000=0.05,
				Frame0001=5,
				Delay0001=0.05,
				Frame0002=6,
				Delay0002=0.05,
				Frame0003=7,
				Delay0003=0.05,
				Frame0004=12,
				Delay0004=3,
				InitCommand=function(self)
					self:diffusealpha(0):sleep(0.2)
					:decelerate(0.6):zoom(1.5):diffusealpha(1):accelerate(0.4):zoom(1)
					:decelerate(0.1):zoom(0.9):diffusealpha(0.8):accelerate(0.1):zoom(1):diffusealpha(1)
				end,
				OnCommand=function(self) self:sleep(0.2) end
			}
		},

		Def.ActorFrame{
			OnCommand=function(self) self:hibernate(0.3):xy(-20,-20):sleep(1.4):queuecommand("Update") end,
			UpdateCommand=function(self)
				self:decelerate(0.3):zoom(1.1):accelerate(0.3):zoom(1):decelerate(0.3)
				:zoom(0.9):diffusealpha(0.9):accelerate(0.3):zoom(2):diffusealpha(1):queuecommand("Update")
			end,
			--fworkred1
			Def.Sprite{
				Texture="fireworks",
				Frame0000=10,
				Delay0000=0.05,
				Frame0001=11,
				Delay0001=0.05,
				Frame0002=12,
				Delay0002=0.5,
				Frame0003=8,
				Delay0003=0.05,
				Frame0004=9,
				Delay0004=0.05,
				InitCommand=function(self)
					self:diffusealpha(0):sleep(0.2)
					:decelerate(0.6):zoom(1.5):diffusealpha(1):accelerate(0.4):zoom(1)
					:decelerate(0.1):zoom(0.9):diffusealpha(0.8):accelerate(0.1):zoom(1):diffusealpha(1)
				end,
				OnCommand=function(self) self:sleep(0.2) end
			}
		},

		Def.ActorFrame{
			OnCommand=function(self) self:hibernate(0.3):xy(20,-20):sleep(1.4):queuecommand("Update") end,
			UpdateCommand=function(self)
				self:decelerate(0.3):zoom(1.1):accelerate(0.3):zoom(1):decelerate(0.3)
				:zoom(0.9):diffusealpha(0.9):accelerate(0.3):zoom(2):diffusealpha(1):queuecommand("Update")
			end,
			--fworkyellow1
			Def.Sprite{
				Texture="fireworks",
				Frame0000=12,
				Delay0000=1.5,
				Frame0001=0,
				Delay0001=0.05,
				Frame0002=1,
				Delay0002=0.05,
				Frame0003=2,
				Delay0003=0.05,
				Frame0004=3,
				Delay0004=0.05,
				InitCommand=function(self)
					self:diffusealpha(0):sleep(0.2)
					:decelerate(0.6):zoom(1.5):diffusealpha(1):accelerate(0.4):zoom(1)
					:decelerate(0.1):zoom(0.9):diffusealpha(0.8):accelerate(0.1):zoom(1):diffusealpha(1)
				end,
				OnCommand=function(self) self:sleep(0.2) end
			}
		},

		Def.ActorFrame{
			OnCommand=function(self) self:hibernate(0.3):xy(20,20):sleep(1.4):queuecommand("Update") end,
			UpdateCommand=function(self)
				self:decelerate(0.3):zoom(1.1):accelerate(0.3):zoom(1):decelerate(0.3)
				:zoom(0.9):diffusealpha(0.9):accelerate(0.3):zoom(2):diffusealpha(1):queuecommand("Update")
			end,
			--fworkgreen2
			Def.Sprite{
				Texture="fireworks",
				Frame0000=4,
				Delay0000=0.05,
				Frame0001=5,
				Delay0001=0.05,
				Frame0002=6,
				Delay0002=0.05,
				Frame0003=7,
				Delay0003=0.05,
				Frame0004=12,
				Delay0004=1,
				InitCommand=function(self)
					self:diffusealpha(0):sleep(0.2)
					:decelerate(0.6):zoom(1.5):diffusealpha(1):accelerate(0.4):zoom(1)
					:decelerate(0.1):zoom(0.9):diffusealpha(0.8):accelerate(0.1):zoom(1):diffusealpha(1)
				end,
				OnCommand=function(self) self:sleep(0.2) end
			}
		}
	}
}

--[[
OnCommand="zoom,0.2;x,-1;y,-1;wag;EffectMagnitude,0,0,2"
>
	<children>
		<!--Fireworks-->
		<ActorFrame
			OnCommand="hibernate,1.4;zoom,8;draworder,-2000;"
		>
			<children>
		<ActorFrame
			OnCommand="x,-20;y,20;sleep,1.4;queuecommand,Update;"
			UpdateCommand="decelerate,0.3;zoom,1.1;accelerate,0.3;zoom,1;decelerate,0.3;zoom,0.9;diffusealpha,0.9;accelerate,0.3;zoom,1;diffusealpha,1;queuecommand,Update;"
		>
			<children>
				<Layer
					File="fworkgreen1.sprite"
					InitCommand="diffusealpha,0;sleep,0.2;queuecommand,GradeSound;decelerate,0.6;zoom,1.5;diffusealpha,1;accelerate,0.4;zoom,1;decelerate,0.1;zoom,0.9;diffusealpha,0.8;accelerate,0.1;zoom,1;diffusealpha,1;"
					OnCommand="sleep,0.2;"
				/>
			</children>
		</ActorFrame>
		<ActorFrame
			OnCommand="hibernate,0.3;x,-20;y,-20;sleep,1.4;queuecommand,Update;"
			UpdateCommand="decelerate,0.3;zoom,1.1;accelerate,0.3;zoom,1;decelerate,0.3;zoom,0.9;diffusealpha,0.9;accelerate,0.3;zoom,1;diffusealpha,1;queuecommand,Update;"
		>
			<children>
				<Layer
					File="fworkred1.sprite"
					InitCommand="diffusealpha,0;sleep,0.2;queuecommand,GradeSound;decelerate,0.6;zoom,1.5;diffusealpha,1;accelerate,0.4;zoom,1;decelerate,0.1;zoom,0.9;diffusealpha,0.8;accelerate,0.1;zoom,1;diffusealpha,1;"
					OnCommand="sleep,0.2;"
				/>
			</children>
		</ActorFrame>
		<ActorFrame
			OnCommand="hibernate,0.6;x,20;y,-20;sleep,1.4;queuecommand,Update;"
			UpdateCommand="decelerate,0.3;zoom,1.1;accelerate,0.3;zoom,1;decelerate,0.3;zoom,0.9;diffusealpha,0.9;accelerate,0.3;zoom,1;diffusealpha,1;queuecommand,Update;"
		>
			<children>
				<Layer
					File="fworkyellow1.sprite"
					InitCommand="diffusealpha,0;sleep,0.2;queuecommand,GradeSound;decelerate,0.6;zoom,1.5;diffusealpha,1;accelerate,0.4;zoom,1;decelerate,0.1;zoom,0.9;diffusealpha,0.8;accelerate,0.1;zoom,1;diffusealpha,1;"
					OnCommand="sleep,0.2;"
				/>
			</children>
		</ActorFrame>
		<ActorFrame
			OnCommand="hibernate,0.9;x,20;y,20;sleep,1.4;queuecommand,Update;"
			UpdateCommand="decelerate,0.3;zoom,1.1;accelerate,0.3;zoom,1;decelerate,0.3;zoom,0.9;diffusealpha,0.9;accelerate,0.3;zoom,1;diffusealpha,1;queuecommand,Update;"
		>
			<children>
				<Layer
					File="fworkgreen2.sprite"
					InitCommand="diffusealpha,0;sleep,0.2;queuecommand,GradeSound;decelerate,0.6;zoom,1.5;diffusealpha,1;accelerate,0.4;zoom,1;decelerate,0.1;zoom,0.9;diffusealpha,0.8;accelerate,0.1;zoom,1;diffusealpha,1;"
					OnCommand="sleep,0.2;"
				/>
			</children>
		</ActorFrame>
	</children>
</ActorFrame>
]]
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