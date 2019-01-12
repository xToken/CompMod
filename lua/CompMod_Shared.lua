-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod_Shared.lua
-- - Dragon

-- Base 'Shared' changes which apply to all VMs

Script.Load("lua/Class.lua")
Script.Load("lua/CompMod/Utilities/Elixer/shared.lua")

Elixer.UseVersion( 1.8 )

kCompModBuild = 20

local MainFiles = { }
Shared.GetMatchingFileNames("lua/CompMod/*shared.lua", true, MainFiles)

-- Load function changes
for i = 1, #MainFiles do
	Script.Load(MainFiles[i])
end