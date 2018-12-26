-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod_Shared.lua
-- - Dragon

-- Base 'Shared' changes which apply to all VMs

Script.Load( "lua/Class.lua" )
Script.Load( "lua/CompMod/Elixer_Utility.lua" )

Elixer.UseVersion( 1.8 )

kCompModVersion = 1
kCompModBuild = 11

local ModFiles = { }
Shared.GetMatchingFileNames( "lua/CompMod/New/*.lua", true, ModFiles )

-- Load new technology
for i = 1, #ModFiles do
	Script.Load(ModFiles[i])
end

local MainFiles = { }
Shared.GetMatchingFileNames( "lua/CompMod/Shared/*.lua", true, MainFiles )

-- Load function changes
for i = 1, #MainFiles do
	Script.Load(MainFiles[i])
end