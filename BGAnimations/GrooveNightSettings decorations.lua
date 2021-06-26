local t = Def.ActorFrame{}
local crownon = true
local curzoom = 1
t[#t+1] = Def.Sprite{
    Texture=THEME:GetPathG("Judgment","label"),
    Condition=GAMESTATE:Env()["GNSetting"] == "Judgment",
    OnCommand=function(self)
        local judgsize = LoadModule("Config.Load.lua")("DefaultJudgmentSize","Save/GrooveNightsPrefs.ini")
        local judgopac = LoadModule("Config.Load.lua")("DefaultJudgmentOpacity","Save/GrooveNightsPrefs.ini")
        self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+170):animate(0)
        :zoom( 0.75*(judgsize or 1) )
        :diffusealpha( judgopac or 1 )
    end,
    JudgmentTweenMessageCommand=function(self,param)
        local DJS = curzoom
        self:finishtweening()
        :zoom( param.EnableBounce and 0.8*DJS or 0.75*DJS )
		:decelerate( 0.1 )
        :zoom( 0.75*DJS )
    end,
    DefaultJudgmentSizeChangeMessageCommand=function(self,param)
        if param.choice then self:finishtweening():zoom( 0.75*(param.choice)/10 ) curzoom = (param.choice-1)/10 end
    end,
    DefaultJudgmentOpacityChangeMessageCommand=function(self,param)
        if param.choice then self:diffusealpha( (param.choice-1)/10 ) end
    end,
    ToggleJudgmentBounceChangeMessageCommand=function(self,param)
        MESSAGEMAN:Broadcast("JudgmentTween",{EnableBounce=param.choice})
    end,
}

t[#t+1] = Def.ActorFrame{
    Condition=GAMESTATE:Env()["GNSetting"] == "Judgment",
    InitCommand=function(self)
        self:xy( SCREEN_CENTER_X-100, SCREEN_CENTER_Y+170 )
    end,

    Def.Sprite{
        Texture=THEME:GetPathG("LifeMeterBar","over"),
        OnCommand=function(self)
            self:rotationz(90):y(100):cropright(0.7):faderight(0.2)
        end,
    },
    
    Def.Sprite{
        Texture=THEME:GetPathB("ScreenGameplay","Overlay/winning.png"),
        OnCommand=function(self)
            self:zoom(0.6):rotationz(30):xy(10,-40)
            :diffusealpha( LoadModule("Config.Load.lua")("TournamentCrownEnabled","Save/GrooveNightsPrefs.ini") and 1 or 0 )
        end,
        TournamentCrownEnabledChangeMessageCommand=function(self,param)
            self:playcommand("CrownTween",{EnableBounce=param.choice})
        end,
        CrownTweenCommand=function(self,param)
            local hasdiffusing = param.EnableBounce == 2
            self:stoptweening()
            :rotationz( 30 )
            :tween(0.5,"easeoutelastic")
            :zoom( hasdiffusing and 0.6 or 0 )
            :rotationz( 30 )
        end,
    }
}

t[#t+1] = Def.BitmapText{
    Font="journey/number/_journey even 40",
    Condition=GAMESTATE:Env()["GNSetting"] == "Judgment",
    Text=math.random(1,100),
    OnCommand=function(self)
        local defaultsize = LoadModule("Config.Load.lua")("DefaultComboSize","Save/GrooveNightsPrefs.ini")
        self:xy(SCREEN_CENTER_X+150,SCREEN_CENTER_Y+170):animate(0)
        :zoom( defaultsize or 1 )
    end,
    ComboTweenMessageCommand=function(self,param)
        local setzoom = self:GetZoom()
        self:finishtweening()
        :zoom( setzoom*1.1 )
		:decelerate( 0.1 )
        :zoom( setzoom )
    end,
    DefaultComboSizeChangeMessageCommand=function(self,param)
        if param.choice then self:finishtweening():zoom( (param.choice)/10 ) curzoom = (param.choice-1)/10 end
    end,
    ToggleComboSizeIncreaseChangeMessageCommand=function(self,param) MESSAGEMAN:Broadcast("ComboTween",{EnableBounce=param.choice}) end,
    ToggleComboBounceChangeMessageCommand=function(self) MESSAGEMAN:Broadcast("ComboTween") end,
    ToggleComboExplosionChangeMessageCommand=function(self) MESSAGEMAN:Broadcast("ComboTween") end,
}

return t