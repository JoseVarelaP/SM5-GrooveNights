-- Some stage graphics contain different coloring offsets depending on the text string.
local stagecases = {
	Conditionals = {
		["Stage_Event"] = "Event",
		["Stage_Final"] = "Final",
	},

	__index = function( this, stage )
		-- Course mode will request song number, so return that instead.
		if GAMESTATE:IsCourseMode() then
			return "Song"
		end
		-- If there's a special case found in the Conditionals Table, then it means that it has to use custom
		-- text and possibly an offset. Otherwise, it might just be a typical round, and will require both bitmaptext actors.
		return this.Conditionals[stage] or "Round"
	end
}

setmetatable(stagecases, stagecases)

local currentdata = stagecases[GAMESTATE:GetCurrentStage()]
local curindex = GAMESTATE:GetCurrentStageIndex()+( Var "LoadingScreen" ~= "ScreenEvaluationNormal" and 1 or 0 )
local CourseIndx = 1

local function ConvertText( child )
	curindex = GAMESTATE:IsCourseMode() and CourseIndx or GAMESTATE:GetCurrentStageIndex()+1
	local str = string.format( THEME:GetString("ScreenGameplay", stagecases[GAMESTATE:GetCurrentStage()] ), curindex )

	local ColoringProcess = {}
	--for k in string.gmatch( str, "%[(.-)%]" ) do
	for p1,m,p2 in str:gmatch("()(%[.-%])()" ) do
        ColoringProcess[#ColoringProcess+1] = {
        	Start = p1-1,
        	Attr = {
        		Diffuse = Color.Red,
        		Length = m:len()-1
        	}
        }
    end
	
	-- We're done, get rid of the brackets themselves.
	child:settext( str:gsub( "%[","" ):gsub("%]","") )
	for k,v in pairs( ColoringProcess ) do
		--lua.ReportScriptError( ("%i-%i"):format(v.Start, v.Attr.Length) )
		child:AddAttribute( v.Start, v.Attr )
	end
	return 
end

return Def.ActorFrame{
	OnCommand=function(self)
		ConvertText( self:GetChild("Number") )

		local num = self:GetChild("Number")
		num:zoom( LoadModule("Lua.Resize.lua")( num:GetZoomedWidth(), num:GetZoomedHeight(), 140, 70 ) )
	end,
	BeforeLoadingNextCourseSongMessageCommand=function(self)
        CourseIndx = CourseIndx + 1
        ConvertText( self:GetChild("Number") )
    end,
	
	Def.BitmapText{
		Font="journey/40/_journey 40px",
		Name="Number",
		--Condition=(not GAMESTATE:IsEventMode() and not currentdata.ColorOffset),
		Text=curindex,
		OnCommand=function(self)
			self:y( -3 ):strokecolor(Color.Black)
		end
	}
}