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

local originalAlienGetPlayerStatusDesc
originalAlienGetPlayerStatusDesc = Class_ReplaceMethod("Alien", "GetPlayerStatusDesc",
	function(self)
	
		local status = kPlayerStatus.Void
		
		if (self:GetIsAlive() == false) then
			status = kPlayerStatus.Dead
		else
			if (self:isa("Embryo")) then
				if self.gestationTypeTechId == kTechId.Skulk then
					status = kPlayerStatus.SkulkEgg
				elseif self.gestationTypeTechId == kTechId.Gorge then
					status = kPlayerStatus.GorgeEgg
				elseif self.gestationTypeTechId == kTechId.Lerk then
					status = kPlayerStatus.LerkEgg
				elseif self.gestationTypeTechId == kTechId.Fade then
					status = kPlayerStatus.FadeEgg
				elseif self.gestationTypeTechId == kTechId.Onos then
					status = kPlayerStatus.OnosEgg
				else
					status = kPlayerStatus.SkulkEgg
				end
			else
				status = kPlayerStatus[self:GetClassName()]
			end
		end
		
		return status

	end

)

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