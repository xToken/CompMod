-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Shift\shared.lua
-- - Dragon

-- SHIFT
local networkVars = {
    energizing = "boolean"
}

AddMixinNetworkVars(InfestationMixin, networkVars)

local originalShiftOnInitialized
originalShiftOnInitialized = Class_ReplaceMethod("Shift", "OnInitialized",
	function(self)
		InitMixin(self, InfestationMixin)
		originalShiftOnInitialized(self)
		self.energizing = false
	end
)

function Shift:GetInfestationRadius()
    return kStructureInfestationRadius
end

function Shift:GetInfestationMaxRadius()
    return kStructureInfestationRadius
end

function Shift:GetIsEnergizing()
	return self.energizing
end

function Shift:TriggerEnergize()
	self.energizing = true
	self.energizeStart = Shared.GetTime()
	self:TriggerEffects("fireworks")
	return true, true
end

function Shift:GetTechAllowed(techId, techNode, player)

    local allowed, canAfford = ScriptActor.GetTechAllowed(self, techId, techNode, player) 
    
    allowed = allowed and not self.echoActive
    
    if allowed then
 
        if techId == kTechId.TeleportHydra then
            allowed = self.hydraInRange
        elseif techId == kTechId.TeleportWhip then
            allowed = self.whipInRange
        elseif techId == kTechId.TeleportTunnel then
            allowed = self.tunnelInRange
        elseif techId == kTechId.TeleportCrag then
            allowed = self.cragInRange
        elseif techId == kTechId.TeleportShade then
            allowed = self.shadeInRange
        elseif techId == kTechId.TeleportShift then
            allowed = self.shiftInRange
        elseif techId == kTechId.TeleportVeil then
            allowed = self.veilInRange
        elseif techId == kTechId.TeleportSpur then
            allowed = self.spurInRange
        elseif techId == kTechId.TeleportShell then
            allowed = self.shellInRange
        elseif techId == kTechId.TeleportHive then
            allowed = self.hiveInRange
        elseif techId == kTechId.TeleportEgg then
            allowed = self.eggInRange
        elseif techId == kTechId.TeleportHarvester then
            allowed = self.harvesterInRange
        end
    
    end
    
    return allowed, canAfford
    
end

function Shift:EnergizeInRange()

    if self:GetIsBuilt() then
		if self:GetIsEnergizing() then
			local energizeAbles = GetEntitiesWithMixinForTeamWithinXZRange("Energize", self:GetTeamNumber(), self:GetOrigin(), kEnergizeRange)
			
			for _, entity in ipairs(energizeAbles) do
			
				if entity ~= self then
					entity:Energize(self)
				end
				
			end
			
			if self.energizeStart + kShiftEnergizeDuration < Shared.GetTime() then
				self.energizing = false
			end
		else
			-- Passive energy
			local energizeAbles = GetEntitiesWithMixinForTeamWithinXZRange("Energize", self:GetTeamNumber(), self:GetOrigin(), kEnergizeRange)
			for _, entity in ipairs(energizeAbles) do
				
				if (not entity.GetIsEnergizeAllowed or entity:GetIsEnergizeAllowed()) and entity.timeLastEnergizeUpdate + kEnergizeUpdateRate < Shared.GetTime() and entity ~= self then
				
					entity:AddEnergy(kPlayerPassiveEnergyPerEnergize)
					entity.timeLastEnergizeUpdate = Shared.GetTime()
					
				end

			end
		end
    end
    
    return self:GetIsAlive()
    
end

local originalShiftOnUpdateAnimationInput
originalShiftOnUpdateAnimationInput = Class_ReplaceMethod("Shift", "OnUpdateAnimationInput",
	function(self, modelMixin)
		originalShiftOnUpdateAnimationInput(self, modelMixin)
		--modelMixin:SetAnimationInput("asdf", self.energizing)
	end
)

if Client then

	local originalShiftOnUpdate
	originalShiftOnUpdate = Class_ReplaceMethod("Shift", "OnUpdate",
		function(self, deltaTime)
			originalShiftOnUpdate(self, deltaTime)
			if self.isTeleporting ~= self.lastisTeleporting then
				-- This isnt good coding, but these is all over the place in vanilla
				if not self.isTeleporting then
					-- We are not moving, trigger clear, then infest start.
					self:CleanupInfestation()
				end
				self.lastisTeleporting = self.isTeleporting
			end
			if self.moving ~= self.lastmoving then
				-- This isnt good coding, but these is all over the place in vanilla
				if not self.moving then
					-- We are not moving, trigger clear, then infest start.
					self:CleanupInfestation()
				end
				self.lastmoving = self.moving
			end
		end
	)

end

if Server then

	local originalShiftOnUpdate
	originalShiftOnUpdate = Class_ReplaceMethod("Shift", "OnUpdate",
		function(self, deltaTime)
			originalShiftOnUpdate(self, deltaTime)
			
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
	
end

Shared.LinkClassToMap("Shift", Shift.kMapName, networkVars)