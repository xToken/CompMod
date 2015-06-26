// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Client\BindingAdjustments.lua
// - Dragon

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
	elseif origControlBindings[i] == "LeftShift" then
		table.insert(newGlobalControlBindings, "SecondaryMovementModifier")
		table.insert(newGlobalControlBindings, "input")
		table.insert(newGlobalControlBindings, "Secondary Movement Modifier")
		table.insert(newGlobalControlBindings, "Capital")
	end	
end
ReplaceLocals(BindingsUI_GetBindingsData, { globalControlBindings = newGlobalControlBindings }) 

local defaults = GetUpValue( GetDefaultInputValue,   "defaults", 			{ LocateRecurse = true } )
table.insert(defaults, { "Weapon6", "6" })
table.insert(defaults, { "SecondaryMovementModifier", "Capital" })