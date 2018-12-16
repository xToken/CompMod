-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\NS2Utility.lua
-- - Dragon

function GetIsCloseToMenuStructure(player)

    local ptlabs = GetEntitiesForTeamWithinRange("PrototypeLab", player:GetTeamNumber(), player:GetOrigin(), PrototypeLab.kResupplyUseRange)
    local armories = GetEntitiesForTeamWithinRange("Armory", player:GetTeamNumber(), player:GetOrigin(), Armory.kResupplyUseRange)
	local robos = GetEntitiesForTeamWithinRange("RoboticsFactory", player:GetTeamNumber(), player:GetOrigin(), RoboticsFactory.kResupplyUseRange)

    return (ptlabs and #ptlabs > 0) or (armories and #armories > 0) or (robos and #robos > 0)

end