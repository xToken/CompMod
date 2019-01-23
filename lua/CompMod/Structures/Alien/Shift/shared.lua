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

function Shift:ShouldGenerateInfestation()
    return not self.moving
end

function Shift:TriggerEnergize()
	self.energizing = true
	self.energizeStart = Shared.GetTime()
	self:TriggerEffects("fireworks")
	return true, true
end

function Shift:GetTechAllowed(techId, techNode, player)
    if techId == kTechId.ShiftEnergize and self:GetMaturityLevel() ~= kMaturityLevel.Flourishing then
        return false, false
    end
    return ScriptActor.GetTechAllowed(self, techId, techNode, player) 
    
end

function Shift:GetTechButtons(techId)
    return { kTechId.ShiftEnergize, kTechId.Move, kTechId.None, kTechId.None, 
                        kTechId.None, kTechId.None, kTechId.None, kTechId.None }
end

function Shift:EnergizeInRange()

    if self:GetIsBuilt() then
		--[[if self:GetIsEnergizing() then
			local energizeAbles = GetEntitiesWithMixinForTeamWithinXZRange("Energize", self:GetTeamNumber(), self:GetOrigin(), kEnergizeRange)
			
			for _, entity in ipairs(energizeAbles) do
			
				if (not entity.GetIsEnergizeAllowed or entity:GetIsEnergizeAllowed()) and entity.timeLastEnergizeUpdate + kEnergizeUpdateRate < Shared.GetTime() and entity ~= self then
				
					entity:AddEnergy(kPlayerEnergyPerEnergize * self:GetMaturityScaling())
					entity.timeLastEnergizeUpdate = Shared.GetTime()
					
				end
				
			end
			
			if self.energizeStart + kShiftEnergizeDuration < Shared.GetTime() then
				self.energizing = false
			end
		else--]]
		-- Passive energy
		local energizeAbles = GetEntitiesWithMixinForTeamWithinXZRange("Energize", self:GetTeamNumber(), self:GetOrigin(), kEnergizeRange)
		for _, entity in ipairs(energizeAbles) do
			
			if (not entity.GetIsEnergizeAllowed or entity:GetIsEnergizeAllowed()) and entity.timeLastEnergizeUpdate + kEnergizeUpdateRate < Shared.GetTime() and entity ~= self then
			
				entity:AddEnergy(kPlayerPassiveEnergyPerEnergize * self:GetMaturityScaling())
				entity.timeLastEnergizeUpdate = Shared.GetTime()
				
			end

		end
		--end
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

Shared.LinkClassToMap("Shift", Shift.kMapName, networkVars)