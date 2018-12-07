-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\TechIdAdjustments.lua
-- - Dragon

-- This is relevant, not only to this but to any functions - it explains Reference/Value in lua function calls
-- Tables, functions, threads, and (full) userdata values are objects: variables do not actually contain these values, only references to them.
local InfestationRequirementRemovedIDs = { }
table.insert(InfestationRequirementRemovedIDs, kTechId.Harvester)
table.insert(InfestationRequirementRemovedIDs, kTechId.Crag)
table.insert(InfestationRequirementRemovedIDs, kTechId.Shift)
table.insert(InfestationRequirementRemovedIDs, kTechId.Shade)
table.insert(InfestationRequirementRemovedIDs, kTechId.Veil)
table.insert(InfestationRequirementRemovedIDs, kTechId.Spur)
table.insert(InfestationRequirementRemovedIDs, kTechId.Shell)

local function AddCompModTechChanges(techData)					
	for index, record in ipairs(techData) do 
        if table.contains(InfestationRequirementRemovedIDs, record[kTechDataId]) then
			record[kTechDataRequiresInfestation] = false	
		end
    end
end

//You dumbass, the BuildTechData is global...
local oldBuildTechData = BuildTechData
function BuildTechData()
	local techData = oldBuildTechData()
	AddCompModTechChanges(techData)
	return techData
end