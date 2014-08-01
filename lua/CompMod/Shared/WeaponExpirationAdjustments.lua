//Dont want to always replace random files, so this.

// Comp Mod change, decrease weapon time on ground.
// Set to true for being a world weapon, false for when it's carried by a player
local origWeaponGetExpireTimeFraction
origWeaponGetExpireTimeFraction = Class_ReplaceMethod("Weapon", "GetExpireTimeFraction",
	function(self)
		if self.expireTime then
			return Clamp((self.expireTime - Shared.GetTime()) / kWeaponStayTime, 0, 1)
		else
			return 0
		end
	end
)