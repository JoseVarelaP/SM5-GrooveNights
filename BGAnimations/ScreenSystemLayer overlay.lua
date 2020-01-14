local function CreditsText( pn )
	local text = LoadFont(Var "LoadingScreen","credits") .. {
		InitCommand=function(self)
			self:name("Credits" .. PlayerNumberToString(pn))
			ActorUtil.LoadAllCommandsAndSetXY(self,Var "LoadingScreen");
		end;
		UpdateTextCommand=function(self)
			local str = ScreenSystemLayerHelpers.GetCreditsMessage(pn);
			self:settext(str);
		end;
		UpdateVisibleCommand=function(self)
			local screen = SCREENMAN:GetTopScreen();
			local bShow = true;
			if screen then
				local sClass = screen:GetName();
				bShow = THEME:GetMetric( sClass, "ShowCreditDisplay" );
			end
			self:visible( bShow );
		end
	};
	return text;
end;

local t = Def.ActorFrame {}
	-- Aux
t[#t+1] = LoadActor(THEME:GetPathB("ScreenSystemLayer","aux"));
	-- Credits
t[#t+1] = Def.ActorFrame {
 	CreditsText( PLAYER_1 );
	CreditsText( PLAYER_2 ); 
};

-- Text
t[#t+1] = Def.ActorFrame {
	InitCommand=function(s) s:y(-40) end,
	OnCommand=function(s) s:finishtweening():y(-40):decelerate(0.2):y(-10) SOUND:PlayOnce( THEME:GetPathS( 'gnSystemMessage', 'sound' ) ) end,
	OffCommand=function(s) s:sleep(2):bouncebegin(0.2):y(-40) end,
	Def.Sprite {
		Texture=THEME:GetPathG("ScreenSystemLayer","MessageFrame"),
		InitCommand=function(s)
			s:zoomtowidth( SCREEN_WIDTH ):diffuse( color("#1C2C3C") ):align(0,0)
		end,
		OnCommand=function(s) end,
	};
	Def.BitmapText{
		Font="Common Normal";
		Name="Text";
		InitCommand=cmd(maxwidth,750;horizalign,left;vertalign,top;y,SCREEN_TOP+14;x,SCREEN_LEFT+10;shadowlength,1;diffusealpha,0;);
		OnCommand=function(s) s:diffusealpha(1):zoom(0.6) end,
		OffCommand=cmd(sleep,3;sleep,0.5;diffusealpha,0;);
	};
	SystemMessageMessageCommand = function(self, params)
		self:GetChild("Text"):settext( params.Message );
		self:playcommand( "On" );
		if params.NoAnimate then
			self:finishtweening();
		end
		self:playcommand( "Off" );
	end;
	HideSystemMessageMessageCommand = cmd(finishtweening);
};

return t;
