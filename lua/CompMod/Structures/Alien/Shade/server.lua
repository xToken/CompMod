-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Shade\server.lua
-- - Dragon

local originalShadeOnUpdate
originalShadeOnUpdate = Class_ReplaceMethod("Shade", "OnUpdate",
	function(self, deltaTime)
		originalShadeOnUpdate(self, deltaTime)
		
		if not self:GetIsAlive() then

			local destructionAllowedTable = { allowed = true }
			if self.GetDestructionAllowed then
				self:GetDestructionAllowed(destructionAllowedTable)
			end

			if destructionAllowedTable.allowed then
				DestroyEntity(self)
			end

		end

		if self.moving ~= self.lastmoving then
			-- This isnt good coding, but these is all over the place in vanilla
			if self.moving then
				-- We are moving, trigger recede
				self:SetDesiredInfestationRadius(0)
			else
				-- We are not moving, trigger clear, then infest start.
				self:CleanupInfestation()
			end
			self.lastmoving = self.moving
		end
		
	end
)

function Shade:OnTeleport()
	self:SetDesiredInfestationRadius(0)
end

function Shade:OnTeleportFailed()
    self:SetDesiredInfestationRadius(self:GetInfestationMaxRadius())
end

local originalShadeOnTeleportEnd
originalShadeOnTeleportEnd = Class_ReplaceMethod("Shade", "OnTeleportEnd",
	function(self, destinationEntity)
		originalShadeOnTeleportEnd(self, destinationEntity)
		self:CleanupInfestation()
	end
)

function Shade:UpdateCloaking()

	for _, cloakable in ipairs( GetEntitiesWithMixinForTeamWithinRange("Cloakable", self:GetTeamNumber(), self:GetOrigin(), Shade.kCloakRadius) ) do
		cloakable:TriggerCloak()
	end
    
    return self:GetIsAlive()

end

function Shade:GetDestroyOnKill()
	return false
end

function Shade:OnKill(attacker, doer, point, direction)
	self:SetModel(nil)
	local team = self:GetTeam()
	if team then
		team:OnTeamEntityDestroyed(self)
	end
end

function Shade:GetPassiveBuild()
	return self:GetGameEffectMask(kGameEffect.OnInfestation)
end