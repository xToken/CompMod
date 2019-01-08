-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Shift\server.lua
-- - Dragon

local originalShiftOnUpdate
originalShiftOnUpdate = Class_ReplaceMethod("Shift", "OnUpdate",
	function(self, deltaTime)
		UpdateAlienStructureMove(self, deltaTime)
		
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

function Shift:OnTeleport()
	self:SetDesiredInfestationRadius(0)
end

function Shift:OnTeleportFailed()
    self:SetDesiredInfestationRadius(self:GetInfestationMaxRadius())
end

local originalShiftOnTeleportEnd
originalShiftOnTeleportEnd = Class_ReplaceMethod("Shift", "OnTeleportEnd",
	function(self, destinationEntity)
		originalShiftOnTeleportEnd(self, destinationEntity)
		self:CleanupInfestation()
	end
)

local originalShiftPerformActivation
originalShiftPerformActivation = Class_ReplaceMethod("Shift", "PerformActivation",
	function(self, techId, position, normal, commander)
		if techId == kTechId.ShiftEnergize then
			return self:TriggerEnergize(commander)
		else
			return originalShiftPerformActivation(self, techId, position, normal, commander)
		end
	end
)

function Shift:GetDestroyOnKill()
	return false
end

function Shift:OnKill(attacker, doer, point, direction)
	self:SetModel(nil)
	local team = self:GetTeam()
	if team then
		team:OnTeamEntityDestroyed(self)
	end
end

function Shift:GetPassiveBuild()
	return self:GetGameEffectMask(kGameEffect.OnInfestation)
end