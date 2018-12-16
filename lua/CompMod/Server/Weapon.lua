-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Server\Weapon.lua
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

local originalWeaponDropped
originalWeaponDropped = Class_ReplaceMethod("Weapon", "Dropped",
	function(self, prevOwner)
		local slot = self:GetHUDSlot()

		self.prevOwnerId = prevOwner:GetId()
		self:SetWeaponWorldState(true)
		
		-- when dropped weapons always need a physic model
		if not self.physicsModel then
			self.physicsModel = Shared.CreatePhysicsModel(self.physicsModelIndex, true, self:GetCoords(), self)
		end
		
		if self.physicsModel then
		
			local viewCoords = prevOwner:GetViewCoords()
			local impulse = 0.075
			if slot == 2 then
				impulse = 0.0075
			elseif slot == 4 then
				impulse = 0.005
			end
			self.physicsModel:AddImpulse(self:GetOrigin(), (viewCoords.zAxis * impulse))
			self.physicsModel:SetAngularVelocity(Vector(5,0,0))
			
		end
		
		self.weaponExpirationCheckTime = Shared.GetTime() + kPerformExpirationCheckAfterDelay
	end
)