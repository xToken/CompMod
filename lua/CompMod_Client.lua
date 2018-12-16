-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod_Client.lua
-- - Dragon

-- Loads Client VM changes

-- Load shared defs
Script.Load("lua/CompMod_Shared.lua")

-- Load client specific changes
local MainFiles = { }
Shared.GetMatchingFileNames( "lua/CompMod/Client/*.lua", true, MainFiles )

-- Load function changes
for i = 1, #MainFiles do
	Script.Load(MainFiles[i])
end