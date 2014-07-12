//Dont want to always replace random files, so this.

// Comp Mod change, remove egg drops.
function Egg:GetTechButtons(techId)
    local techButtons = { kTechId.SpawnAlien, kTechId.None, kTechId.None, kTechId.None, 
                          kTechId.None, kTechId.None, kTechId.None, kTechId.None }    
    return techButtons
end

TeamInfo.kRelevantTechIdsAlien =
{
    
    kTechId.GorgeTunnelTech,
    
    kTechId.CragHive,
    kTechId.UpgradeToCragHive,
    kTechId.Shell,
    kTechId.TwoShells,
    kTechId.ThreeShells,
    
    kTechId.ShadeHive,
    kTechId.UpgradeToShadeHive,
    kTechId.Veil,
    kTechId.TwoVeils,
    kTechId.ThreeVeils,
    
    kTechId.ShiftHive,
    kTechId.UpgradeToShiftHive,
    kTechId.Spur,
    kTechId.TwoSpurs,
    kTechId.ThreeSpurs,
    
    kTechId.ResearchBioMassOne,
    kTechId.ResearchBioMassTwo,
    
    kTechId.BabblerTech,
	
	kTechId.MetabolizeEnergy,
	
	kTechId.Charge,
	
	kTechId.BileBomb,
	
	kTechId.Leap,
	
	kTechId.Umbra,
	
	kTechId.MetabolizeHealth,
	
	kTechId.BoneShield,
	
	kTechId.Spores,
	
	kTechId.Stab,
	
	kTechId.WebTech,
	
	kTechId.Stomp,
	
	kTechId.Xenocide	
}
/*
function BabblerEggAbility:IsAllowed(player)
	return GetHasTech(player, kTechId.BabblerTech)
end*/

//Babblers cant be healed
function Babbler:GetCanBeHealedOverride()
    return false
end

function WebsAbility:IsAllowed(player)
	return GetHasTech(player, kTechId.WebTech)
end

local oldBuildClassToGrid = BuildClassToGrid
function BuildClassToGrid()
	local ClassToGrid = oldBuildClassToGrid()
	ClassToGrid["TunnelExit"] = { 3, 8 }
	return ClassToGrid
end