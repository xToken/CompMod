// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\MiscAlienAdjustments.lua
// - Dragon

// Comp Mod change, remove egg drops.
function Egg:GetTechButtons(techId)
    local techButtons = { kTechId.SpawnAlien, kTechId.None, kTechId.None, kTechId.None, 
                          kTechId.None, kTechId.None, kTechId.None, kTechId.None }    
    return techButtons
end

/*
function BabblerEggAbility:IsAllowed(player)
	return GetHasTech(player, kTechId.BabblerTech)
end*/

//Babblers cant be healed
function Babbler:GetCanBeHealedOverride()
    return false
end

local oldBuildClassToGrid = BuildClassToGrid
function BuildClassToGrid()
	local ClassToGrid = oldBuildClassToGrid()
	ClassToGrid["TunnelExit"] = { 3, 8 }
	return ClassToGrid
end