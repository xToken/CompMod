-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Utilities\CustomBindings\client.lua
-- - Dragon

local kCustomBindingsTable = { }

function RegisterCustomBinding(bindingName, insertAfter, type, desc, key, comm)
	assert(bindingName)
    assert(type)
    assert(key)
    table.insert(kCustomBindingsTable, { n = bindingName, iA = insertAfter, t = type, d = desc or "Custom Binding", k = key, c = comm })
end

local function InsertCustomBinding(start, t, new)
	table.insert(t, start, new.n)
	table.insert(t, start + 1, new.t)
	table.insert(t, start + 2, new.d)
	table.insert(t, start + 3, new.k)
end

function OnLoadComplete()
	local origControlBindings = GetUpValue(BindingsUI_GetBindingsData, "globalControlBindings", { LocateRecurse = true })
	local origCommanderBindings = GetUpValue(BindingsUI_GetComBindingsData, "globalComControlBindings", { LocateRecurse = true })
	local defaults = GetUpValue( GetDefaultInputValue, "defaults", { LocateRecurse = true })

	for i = 1, #kCustomBindingsTable do
		local target = kCustomBindingsTable[i].c and origCommanderBindings or origControlBindings
		if not kCustomBindingsTable[i].iA then
			-- Just insert at the end
			InsertCustomBinding(#target + 1, target, kCustomBindingsTable[i])
		else
			-- Find the binding to insert after
			local success = false
			for j = 1, #target do
				if target[j] == kCustomBindingsTable[i].iA then
					InsertCustomBinding(j + 4, target, kCustomBindingsTable[i])
					success = true
				end
			end
			if not success then
				-- Couldnt find, insert at end
				InsertCustomBinding(#target + 1, target, kCustomBindingsTable[i])
			end
		end
		-- Insert into defaults table
		table.insert(defaults, { kCustomBindingsTable[i].n, kCustomBindingsTable[i].k })
	end
end

Event.Hook("LoadComplete", OnLoadComplete)