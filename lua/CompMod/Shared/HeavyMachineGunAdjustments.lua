// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\HeavyMachineGunAdjustments.lua
// - Dragon

// Call this once to generate the basics
GetTexCoordsForTechId(kTechId.Rifle)
// Add HMG
gTechIdPosition[kTechId.HeavyMachineGun] = kDeathMessageIcon.Crush

local originalMarineGetPlayerStatusDesc
originalMarineGetPlayerStatusDesc = Class_ReplaceMethod("Marine", "GetPlayerStatusDesc",
	function(self)
		local weapon = self:GetWeaponInHUDSlot(1)
		if (weapon) and self:GetIsAlive() then
			if (weapon:isa("HeavyMachineGun")) then
				return kPlayerStatus.HMG
			end
		end
		return originalMarineGetPlayerStatusDesc(self)
	end
)