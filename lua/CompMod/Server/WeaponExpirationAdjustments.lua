//Dont want to always replace random files, so this.

// Comp Mod change, decrease weapon time on ground.
// Set to true for being a world weapon, false for when it's carried by a player
local origWeaponSetWeaponWorldState
origWeaponSetWeaponWorldState = Class_ReplaceMethod("Weapon", "SetWeaponWorldState",
	function(self, state, preventExpiration)
	
		if state ~= self.weaponWorldState then
		
			if state then
			
				self:SetPhysicsType(PhysicsType.DynamicServer)
				
				// So it doesn't affect player movement and so collide callback is called
				self:SetPhysicsGroup(PhysicsGroup.DroppedWeaponGroup)
				self:SetPhysicsGroupFilterMask(PhysicsMask.DroppedWeaponFilter)
				
				if self.physicsModel then
					self.physicsModel:SetCCDEnabled(true)
				end
				
				if not preventExpiration then
				
					self.weaponWorldStateTime = Shared.GetTime()
					
					local function DestroyWorldWeapon()
					
						// We need to make sure this callback is still valid. It is possible
						// for this weapon to be dropped and picked up before this callback fires off
						// and then be dropped again, in which case this callback should be ignored and
						// the next callback will destroy the weapon.
						
						// $AU: i would suggest to not use TimedCallbacks here. I noticed sometimes weapons won't disappear (not commander dropped, marine dropped),
						// and also the callback table gets blown up when you spam drop/pickup constantly.
						
						local enoughTimePassed = (Shared.GetTime() - self.weaponWorldStateTime) >= kWeaponStayTime
						if self:GetWeaponWorldState() and enoughTimePassed then
							DestroyEntity(self)
						end
						
					end
					
					self:SetExpireTime(DestroyWorldWeapon, kWeaponStayTime)
					
				end
				
				self:SetIsVisible(true)
				
			else
			
				self:SetPhysicsType(PhysicsType.None)
				self:SetPhysicsGroup(PhysicsGroup.WeaponGroup)
				self:SetPhysicsGroupFilterMask(PhysicsMask.None)
				
				if self.physicsModel then
					self.physicsModel:SetCCDEnabled(false)
				end
				
			end
			
			self.hitGround = false
			
			self.weaponWorldState = state
			
		end
		
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