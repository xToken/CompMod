// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\SkulkAdjustments.lua
// - Dragon

//Skulk is exempt, just replace it
local originalSkulkModifyHeal
originalSkulkModifyHeal = Class_ReplaceMethod("Skulk", "ModifyHeal",
	function(self, healTable)
		if self.isOnFire then
			healTable.health = healTable.health * kOnFireHealingScalar
		end
	end
)