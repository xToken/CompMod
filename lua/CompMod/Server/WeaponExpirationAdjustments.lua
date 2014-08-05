//Dont want to always replace random files, so this.

// Comp Mod change, decrease weapon time on ground.

local function DestroyWeapon(self)
	local enoughTimePassed = (Shared.GetTime() - self.weaponWorldStateTime) >= kWeaponStayTime
	if self:GetWeaponWorldState() and enoughTimePassed then
		DestroyEntity(self)
	end
	return false
end

local origWeaponSetExpireTime
origWeaponSetExpireTime = Class_ReplaceMethod("Weapon", "SetExpireTime",
	function(self, callback, lifetime)
		self:AddTimedCallback(DestroyWeapon, kWeaponStayTime)
		self.expireTime = Shared.GetTime() + kWeaponStayTime
	end
)

//Enhanced Weapon Cleanup
local lastWeaponScan = 0
local kWeaponScanRate = 30
local function ScanForOldWeapons()
	PROFILE("ScanForOldWeapons")
	if lastWeaponScan + kWeaponScanRate < Shared.GetTime() then
		for _, entity in ientitylist(Shared.GetEntitiesWithClassname("Weapon")) do
			if entity.weaponWorldStateTime ~= nil and entity.GetWeaponWorldState then
				local enoughTimePassed = (Shared.GetTime() - entity.weaponWorldStateTime) >= kWeaponStayTime
				if entity:GetWeaponWorldState() and enoughTimePassed then
					DestroyEntity(entity)
				end
			end
		end
		lastWeaponScan = Shared.GetTime()
	end
end

Event.Hook("UpdateServer", ScanForOldWeapons)