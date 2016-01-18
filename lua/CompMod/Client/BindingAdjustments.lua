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
for i = 1, #origControlBindings do
	if origControlBindings[i] == "Weapon5" then
		table.insert(origControlBindings, i + 4, "Weapon6")
		table.insert(origControlBindings, i + 5, "input")
		table.insert(origControlBindings, i + 6, "Weapon #6")
		table.insert(origControlBindings, i + 7, "6")
	elseif origControlBindings[i] == "MovementModifier" then
		table.insert(origControlBindings, i + 4, "SecondaryMovementModifier")
		table.insert(origControlBindings, i + 5, "input")
		table.insert(origControlBindings, i + 6, "Secondary Movement Modifier")
		table.insert(origControlBindings, i + 7, "Capital")
	end
end
ReplaceLocals(BindingsUI_GetBindingsData, { globalControlBindings = origControlBindings }) 

local defaults = GetUpValue( GetDefaultInputValue,   "defaults", 			{ LocateRecurse = true } )
table.insert(defaults, { "Weapon6", "6" })
table.insert(defaults, { "SecondaryMovementModifier", "Capital" })