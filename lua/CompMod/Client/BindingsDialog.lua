-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Client\BindingsDialog.lua
-- - Dragon

local origControlBindings = GetUpValue(BindingsUI_GetBindingsData, "globalControlBindings", { LocateRecurse = true })

for i = 1, #origControlBindings do
	if origControlBindings[i] == "MovementModifier" then
		table.insert(origControlBindings, i + 4, "SecondaryMovementModifier")
		table.insert(origControlBindings, i + 5, "input")
		table.insert(origControlBindings, i + 6, "Secondary Movement Modifier")
		table.insert(origControlBindings, i + 7, "Capital")
	end
end

ReplaceLocals(BindingsUI_GetBindingsData, { globalControlBindings = origControlBindings })

local defaults = GetUpValue( GetDefaultInputValue, "defaults", { LocateRecurse = true })
table.insert(defaults, { "SecondaryMovementModifier", "Capital" })