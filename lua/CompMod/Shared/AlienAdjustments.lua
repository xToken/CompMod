//Dont want to always replace random files, so this.

//Skulk is exempt, just replace it
local originalSkulkModifyHeal
originalSkulkModifyHeal = Class_ReplaceMethod("Skulk", "ModifyHeal",
	function(self, healTable)
		if self.isOnFire then
			healTable.health = healTable.health * kOnFireHealingScalar
		end
	end
)