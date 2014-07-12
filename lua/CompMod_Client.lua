//Loads Client VM changes

//Load shared defs
Script.Load("lua/CompMod_Shared.lua")

//Load client specific changes
local PreLoad = 
{
"lua/CompMod/Client/GUIAdjustments.lua"
}

// Load this first, enables other client functions to override GUI in a slightly less horribly awful way
for i = 1, #PreLoad do
	Script.Load(PreLoad[i])
end

local MainFiles = { }
Shared.GetMatchingFileNames( "lua/CompMod/Client/*.lua", true, MainFiles )

//Load function changes
for i = 1, #MainFiles do
	if not table.contains(PreLoad, MainFiles[i]) then
		Script.Load(MainFiles[i])
	end	
end