-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\NS2Utility\server.lua
-- - Dragon

-- Theres no callbacks here to notify the team... not sure why really
local oldCreateEntityForTeam = CreateEntityForTeam
function CreateEntityForTeam(techId, position, teamNumber, player)
	local newEnt = oldCreateEntityForTeam(techId, position, teamNumber, player)
	if newEnt then
		local gameRules = GetGamerules()
		if gameRules then
			-- Being extra careful here
			local team = gameRules:GetTeam(teamNumber)
			if team then
				team:OnTeamEntityCreated(newEnt)
			end
		end
	end
	return newEnt
end

-- Assumes position is at the bottom center of the egg
function GetCanEggFit(position)

    local extents = LookupTechData(kTechId.Egg, kTechDataMaxExtents)
    local maxExtentsDimension = math.max(extents.x, extents.y)
    ASSERT(maxExtentsDimension > 0, "invalid x extents for")

    local eggCenter = position + Vector(0, extents.y + .05, 0)

    local filter
    local physicsMask = PhysicsMask.AllButPCs
    local trace = Shared.TraceRay(eggCenter, eggCenter - Vector(0, 1000, 0), CollisionRep.Move, physicsMask, EntityFilterOne(nil))
    
    if not Shared.CollideBox(extents, eggCenter, CollisionRep.Default, physicsMask, filter) and GetIsPointOnInfestation(position) and not trace.entity then
            
        return true
                    
    end
    
    return false
    
end