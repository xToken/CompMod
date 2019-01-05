-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\NS2Utility\shared.lua
-- - Dragon

function GetIsCloseToMenuStructure(player)

    local ptlabs = GetEntitiesForTeamWithinRange("PrototypeLab", player:GetTeamNumber(), player:GetOrigin(), PrototypeLab.kResupplyUseRange)
    local armories = GetEntitiesForTeamWithinRange("Armory", player:GetTeamNumber(), player:GetOrigin(), Armory.kResupplyUseRange)
	local robos = GetEntitiesForTeamWithinRange("RoboticsFactory", player:GetTeamNumber(), player:GetOrigin(), RoboticsFactory.kResupplyUseRange)

    return (ptlabs and #ptlabs > 0) or (armories and #armories > 0) or (robos and #robos > 0)

end

local oldGetSelectionText = GetSelectionText
function GetSelectionText(entity, teamNumber)

    local text = oldGetSelectionText(entity, teamNumber)

    if HasMixin(entity, "Maturity") then

        if entity:GetMaturityLevel() == kMaturityLevel.Starving then
            text = Locale.ResolveString("STARVING") .. " " .. text
        end

        if entity:GetMaturityLevel() == kMaturityLevel.Mature then
            text = Locale.ResolveString("MATURED") .. " " .. text
        end

    end
    return text

end

function GetNumberOfAllowedUpgrades(callingEntity)
    if not callingEntity then
        return 1
    end
    local techtree = GetTechTree(callingEntity:GetTeamNumber())
    if techtree then
        if GetHasTech(callingEntity, kTechId.AdditionalTraitSlot2) then
            return 3
        elseif GetHasTech(callingEntity, kTechId.AdditionalTraitSlot1) then
            return 2
        else
            return 1
        end
    else
        return 1
    end
end

-- Bullet size re-enabled

--[[
function GetBulletTargets(startPoint, endPoint, spreadDirection, bulletSize, filter)

    local targets = {}
    local hitPoints = {}
    local trace
	
    for i = 1, 5 do

        local traceFilter
        if filter then

            traceFilter = function(test)
                return EntityFilterList(targets)(test) or filter(test)
            end

        else
            traceFilter = EntityFilterList(targets)
        end

        trace = Shared.TraceRay(startPoint, endPoint, CollisionRep.Damage, PhysicsMask.Bullets, traceFilter)
        if trace.entity and not table.icontains(targets, trace.entity) then

            table.insert(targets, trace.entity)
            table.insert(hitPoints, trace.endPoint)

        end
        
        local deadTarget = trace.entity and HasMixin(trace.entity, "Live") and not trace.entity:GetIsAlive()
        local softTarget = trace.entity and HasMixin(trace.entity, "SoftTarget")
        local ragdollTarget = trace.entity and trace.entity:isa("Ragdoll")
        if (not trace.entity or not (deadTarget or softTarget or ragdollTarget)) or trace.fraction == 1 then
            break
        end
    
    end

    return targets, trace, hitPoints

end
--]]