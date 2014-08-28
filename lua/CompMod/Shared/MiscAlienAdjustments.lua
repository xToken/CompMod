//Dont want to always replace random files, so this.

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