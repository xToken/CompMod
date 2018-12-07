-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
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