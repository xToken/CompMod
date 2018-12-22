-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod_Server.lua
-- - Dragon

-- Loads Server VM changes

-- Load shared defs
Script.Load("lua/CompMod_Shared.lua")

-- Load server side adjustments
local MainFiles = { }
Shared.GetMatchingFileNames( "lua/CompMod/Server/*.lua", true, MainFiles )

-- Load function changes
for i = 1, #MainFiles do
	Script.Load(MainFiles[i])
end

-- Load end game reporting
Script.Load( "lua/CompMod/GameReporter.lua" )