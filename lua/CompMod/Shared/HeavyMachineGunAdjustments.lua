//Dont want to always replace random files, so this.

// Call this once to generate the basics
GetTexCoordsForTechId(kTechId.Rifle)
// Add HMG
//gTechIdPosition[kTechId.HeavyMachineGun] = kDeathMessageIcon.HeavyMachineGun
gTechIdPosition[kTechId.HeavyMachineGun] = kDeathMessageIcon.Rifle

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