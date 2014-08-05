//Input overrides
local origPlayerSendKeyEvent
origPlayerSendKeyEvent = Class_ReplaceMethod("Player", "SendKeyEvent", 
	function(self, key, down)
		local consumed = origPlayerSendKeyEvent(self, key, down)
		if not consumed and down then
			if GetIsBinding(key, "Weapon6") then
				Shared.ConsoleCommand("slot6")
				consumed = true
			end
		end	
		return consumed
	end
)

local origControlBindings = GetUpValue( BindingsUI_GetBindingsData,   "globalControlBindings", 			{ LocateRecurse = true } )
local newGlobalControlBindings = { }
for i = 1, #origControlBindings do
	table.insert(newGlobalControlBindings, origControlBindings[i])
	if origControlBindings[i] == "5" then
		table.insert(newGlobalControlBindings, "Weapon6")
		table.insert(newGlobalControlBindings, "input")
		table.insert(newGlobalControlBindings, "Weapon #6")
		table.insert(newGlobalControlBindings, "6")
	end	
end
ReplaceLocals(BindingsUI_GetBindingsData, { globalControlBindings = newGlobalControlBindings }) 

local defaults = GetUpValue( GetDefaultInputValue,   "defaults", 			{ LocateRecurse = true } )
table.insert(defaults, { "Weapon6", "6" })