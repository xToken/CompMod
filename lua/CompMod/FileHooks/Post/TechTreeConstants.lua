-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\FileHooks\Post\TechTreeConstants.lua
-- - Dragon

Script.Load( "lua/CompMod/Elixer_Utility.lua" )
Elixer.UseVersion( 1.8 )

-- Table for new tech names
local newTechNames = { }
table.insert(newTechNames, "FlamethrowerUpgrade1")
table.insert(newTechNames, "ShotgunUpgrade1")
table.insert(newTechNames, "ShotgunUpgrade2")
table.insert(newTechNames, "MGUpgrade1")
table.insert(newTechNames, "MGUpgrade2")
table.insert(newTechNames, "GLUpgrade1")
table.insert(newTechNames, "JetpackUpgrade1")
table.insert(newTechNames, "ExoUpgrade1")
table.insert(newTechNames, "ExoUpgrade2")
table.insert(newTechNames, "MinigunUpgrade1")
table.insert(newTechNames, "MinigunUpgrade2")
table.insert(newTechNames, "RailgunUpgrade1")
table.insert(newTechNames, "ARCUpgrade1")
table.insert(newTechNames, "ARCUpgrade2")
table.insert(newTechNames, "SentryUpgrade1")
table.insert(newTechNames, "Weapons1Upgrade")
table.insert(newTechNames, "Weapons2Upgrade")
table.insert(newTechNames, "Weapons3Upgrade")
table.insert(newTechNames, "Armor1Upgrade")
table.insert(newTechNames, "Armor2Upgrade")
table.insert(newTechNames, "Armor3Upgrade")

-- Grab existing list of techID names
local gTechIdToString = GetUpValue( StringToTechId, "gTechIdToString", { LocateRecurse = true } )

-- Add new techs to string table, with index
for i = 1, #newTechNames do
	gTechIdToString[newTechNames[i]] = kTechIdMax + i - 1
end

-- Push out max index accordingly
gTechIdToString['Max'] = kTechIdMax + #newTechNames

-- Rebuild table to create enum from
local kTechIdTable = { }
for k, _ in pairs(gTechIdToString) do
	table.insert(kTechIdTable, k)
end

-- Sort
table.sort(kTechIdTable, function(a, b) return gTechIdToString[a] < gTechIdToString[b] end)

-- Update global kTechId enum
kTechId = enum(kTechIdTable)

-- Reset Max
kTechIdMax = kTechId.Max