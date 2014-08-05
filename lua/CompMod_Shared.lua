//Base 'Shared' changes which apply to all VMs

Script.Load( "lua/CompMod/Elixer_Utility.lua" )
Elixer.UseVersion( 1.5 )

local ModFiles = { }
Shared.GetMatchingFileNames( "lua/CompMod/NewTech/*.lua", true, ModFiles )

//Load new technology
for i = 1, #ModFiles do
	Script.Load(ModFiles[i])
end

local PreLoad = 
{
"lua/CompMod/Shared/BalanceAdjustments.lua",
"lua/CompMod/Shared/BalanceHealthAdjustments.lua",
"lua/CompMod/Shared/BalanceMiscAdjustments.lua",
"lua/CompMod/Shared/TechIdAdjustments.lua"
}

//Load constant changes
for i = 1, #PreLoad do
	Script.Load(PreLoad[i])
end

local MainFiles = { }
Shared.GetMatchingFileNames( "lua/CompMod/Shared/*.lua", true, MainFiles )

//Load function changes
for i = 1, #MainFiles do
	if not table.contains(PreLoad, MainFiles[i]) then
		Script.Load(MainFiles[i])
	end	
end