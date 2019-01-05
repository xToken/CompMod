-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\TechTreeConstants\post.lua
-- - Dragon

Script.Load("lua/CompMod/Utilities/Elixer/shared.lua")
Elixer.UseVersion( 1.8 )

-- Load the file with our new tech names
Script.Load("lua/CompMod/TechTreeConstants/NewTechTreeConstants.lua")

-- Table for new tech names
local newTechNames = BuildCompModTechTreeConstantUpdates()

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