-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod_Client.lua
-- - Dragon

-- Loads Client VM changes

-- Load shared defs
Script.Load("lua/CompMod_Shared.lua")

-- Load client specific changes
local PreLoad = { }

-- Load this first, enables other client functions to override GUI in a slightly less horribly awful way
for i = 1, #PreLoad do
	Script.Load(PreLoad[i])
end

local MainFiles = { }
Shared.GetMatchingFileNames( "lua/CompMod/Client/*.lua", true, MainFiles )

-- Load function changes
for i = 1, #MainFiles do
	if not table.contains(PreLoad, MainFiles[i]) then
		Script.Load(MainFiles[i])
	end	
end