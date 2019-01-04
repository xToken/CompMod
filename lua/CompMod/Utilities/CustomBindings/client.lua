-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Utilities\CustomBindings\client.lua
-- - Dragon

local kCustomBindingsTable = { }

function RegisterCustomBinding(bindingName, insertAfter, type, desc, key)
	assert(bindingName)
    assert(type)
    assert(key)
    table.insert(kCustomBindingsTable, { n = bindingName, iA = insertAfter, t = type, d = desc or "Custom Binding", k = key })
end

function OnLoadComplete()
	local origControlBindings = GetUpValue(BindingsUI_GetBindingsData, "globalControlBindings", { LocateRecurse = true })
	local defaults = GetUpValue( GetDefaultInputValue, "defaults", { LocateRecurse = true })
	for i = 1, #kCustomBindingsTable do
		if not kCustomBindingsTable[i].iA then
			-- Just insert at the end
			table.insert(origControlBindings, #origControlBindings + 1, kCustomBindingsTable[i].n)
			table.insert(origControlBindings, #origControlBindings + 1, kCustomBindingsTable[i].t)
			table.insert(origControlBindings, #origControlBindings + 1, kCustomBindingsTable[i].d)
			table.insert(origControlBindings, #origControlBindings + 1, kCustomBindingsTable[i].k)
		else
			-- Find the binding to insert after
			local success = false
			for j = 1, #origControlBindings do
				if origControlBindings[j] == kCustomBindingsTable[i].iA then
					table.insert(origControlBindings, j + 4, kCustomBindingsTable[i].n)
					table.insert(origControlBindings, j + 5, kCustomBindingsTable[i].t)
					table.insert(origControlBindings, j + 6, kCustomBindingsTable[i].d)
					table.insert(origControlBindings, j + 7, kCustomBindingsTable[i].k)
					success = true
				end
			end
			if not success then
				-- Couldnt find, insert at end
				table.insert(origControlBindings, #origControlBindings + 1, kCustomBindingsTable[i].n)
				table.insert(origControlBindings, #origControlBindings + 1, kCustomBindingsTable[i].t)
				table.insert(origControlBindings, #origControlBindings + 1, kCustomBindingsTable[i].d)
				table.insert(origControlBindings, #origControlBindings + 1, kCustomBindingsTable[i].k)
			end
		end
		-- Insert into defaults table
		table.insert(defaults, { kCustomBindingsTable[i].n, kCustomBindingsTable[i].k })
	end
	--ReplaceLocals(BindingsUI_GetBindingsData, { globalControlBindings = origControlBindings })
end

Event.Hook("LoadComplete", OnLoadComplete)