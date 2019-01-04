-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod_Predict.lua
-- - Dragon

-- Loads Predict VM changes

-- Load shared defs
Script.Load("lua/CompMod_Shared.lua")

-- Load predict specific changes
local MainFiles = { }
Shared.GetMatchingFileNames("lua/CompMod/*predict.lua", true, MainFiles)

-- Load function changes
for i = 1, #MainFiles do
	Script.Load(MainFiles[i])
end