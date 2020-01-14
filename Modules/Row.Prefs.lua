return function(Prefs)
	for pn = 1,2 do
		if FILEMAN:DoesFileExist("Save/MachineProfile/GrooveNightsPrefsForPlayerp"..pn.."/GrooveNightsPrefs.ini") then 
			local Createfile = RageFileUtil.CreateRageFile()
			Createfile:Open("Save/MachineProfile/GrooveNightsPrefsForPlayerp"..pn.."/GrooveNightsPrefs.ini", 2)
			Createfile:Write("")
			Createfile:Close()
			Createfile:destroy()
		end
	end
	for k,v in pairs(Prefs) do
		if not LoadModule("Config.Exists.lua")(k,"Save/GrooveNightsPrefs.ini") and not v.UserPref then
			for i,v2 in ipairs(v.Values) do
				if tostring(v2) == tostring(v.Default) then LoadModule("Config.save.lua")(k,tostring(v.Values[i]),"Save/GrooveNightsPrefs.ini") end
			end
		end
		_G[k] = function()
			return {
				Name = k,
				LayoutType = v.OneInRow and "ShowOneInRow" or "ShowAllInRow",
				SelectType = "SelectOne",
				OneChoiceForAllPlayers = (not v.UserPref),
				ExportOnChange = false,
				Choices = v.Choices,
				Values = v.Values,
				LoadSelections = function(self, list, pn)
					if v.LoadFunc then
						v.LoadFunc(self,list,pn)
						return
					end
					local reset = false
					if getenv(k.."env"..pn) then reset = true setenv(k.."env"..pn,false) end
					local Location = "Save/GrooveNightsPrefs.ini"
					if v.UserPref then
						Location = (
							( PROFILEMAN:GetProfile(pn):GetDisplayName() ~= "" and MEMCARDMAN:GetCardState(pn) == 'MemoryCardState_none') and
							CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/GrooveNightsPrefs.ini"
							or "Save/TEMP"..pn
						)
						lua.ReportScriptError( Location )
					end
					if not reset and not v.SkipLocation and LoadModule("Config.Exists.lua")(k,Location) then
						local CurPref = LoadModule("Config.Load.lua")(k,Location)
						for i,v2 in ipairs(self.Values) do
							if tostring(v2) == tostring(CurPref) then list[i] = true return end
						end
					elseif not reset and getenv(k.."Machinetemp"..pn) ~= nil then
						local CurPref = getenv(k.."Machinetemp"..pn)
						for i,v2 in ipairs(self.Values) do
							if tostring(v2) == tostring(CurPref) then list[i] = true return end
						end
					else
						for i,v2 in ipairs(self.Values) do
							if tostring(v2) == tostring(v.Default) then list[i] = true return end
						end
					end
					list[1] = true
				end,
				NotifyOfSelection= function(self, pn, choice)
					if v.GenForOther then 
						setenv(k,choice)
						local Location = "Save/GrooveNightsPrefs.ini"
						if v.GenForUserPref then Location = CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/GrooveNightsPrefs.ini" end
						local CurPref = LoadModule("Config.Load.lua")(v.GenForOther[1],Location)
						CurPref = string.gsub(tostring(CurPref), " ", "")
						local Reset = {true,true}
						for i,v2 in ipairs(_G[v.GenForOther[1]]().Choices) do 
							_G[v.GenForOther[1]]().Choices[i] = nil -- first empty table
							_G[v.GenForOther[1]]().Values[i] = nil -- first empty table
						end
						for i,v2 in ipairs(v.GenForOther[2]("Choice")) do
							_G[v.GenForOther[1]]().Choices[i] = v2 -- then fill table
							if v2 == CurPref then Reset[tonumber(string.sub(pn,-1))] = false
						end end 
						for i,v2 in ipairs(v.GenForOther[2]("Value")) do
							_G[v.GenForOther[1]]().Values[i] = v2 -- then fill table
						end
						setenv(v.GenForOther[1].."env"..pn,Reset[tonumber(string.sub(pn,-1))])
						MESSAGEMAN:Broadcast(v.GenForOther[1], {pn=pn,choice=choice})
						setenv(v.GenForOther[1].."env"..pn,Reset[tonumber(string.sub(pn,-1))]) -- need to double this because bug.
					end
					MESSAGEMAN:Broadcast(k.."Change", {pn=pn,choice=choice,TextChoice=self.Choices[choice]})
				end,
				SaveSelections = function(self, list, pn)
					local Location = "Save/GrooveNightsPrefs.ini"
					if v.SaveFunc then
						v.SaveFunc(self,list,pn)
						return
					end
					if v.UserPref then 
						Location = (
							( PROFILEMAN:GetProfile(pn):GetDisplayName() ~= "" and MEMCARDMAN:GetCardState(pn) == 'MemoryCardState_none') and
							CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/GrooveNightsPrefs.ini"
							or "Save/TEMP"..pn
						)
					end
					for i,_ in ipairs(self.Values) do
							if list[i] == true then
								LoadModule("Config.Save.lua")( k, tostring(self.Values[i]) ,Location )
								setenv(k.."Machinetemp"..pn,tostring(self.Values[i]) )
							end
					end
				end,
				Reload = function() return "ReloadChanged_All" end,
				ReloadRowMessages= {k}
			}
		end
	end
end