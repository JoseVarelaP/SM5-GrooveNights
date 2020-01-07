local t = Def.ActorFrame{}

t[#t+1] = Def.Sprite{
    Texture="../_moveon",
    OnCommand=function(s) s:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):linear(0.2):diffuse(color("0,0,0,0")) end
}

return t;