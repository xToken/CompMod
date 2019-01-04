-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Weapon\server.lua
-- - Dragon

local kPerformExpirationCheckAfterDelay = 1.00

local originalWeaponSetWeaponWorldState
originalWeaponSetWeaponWorldState = Class_ReplaceMethod("Weapon", "SetWeaponWorldState",
	function(self, state, preventExpiration)
		originalWeaponSetWeaponWorldState(self, state, preventExpiration)
		if state == false then
			if self.OnTechOrResearchUpdated then
				self:OnTechOrResearchUpdated()
			end
		end
	end
)