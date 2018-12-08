-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\HarvesterAdjustments.lua
-- - Dragon

-- Harvester
local originalHarvesterOnInitialized
originalHarvesterOnInitialized = Class_ReplaceMethod("Harvester", "OnInitialized",
	function(self)
		InitMixin(self, InfestationMixin)
		originalHarvesterOnInitialized(self)
	end
)

function Harvester:GetInfestationRadius()
    return kStructureInfestationRadius
end

function Harvester:GetInfestationMaxRadius()
    return kStructureInfestationRadius
end

if Server then

	local originalHarvesterOnUpdate
	originalHarvesterOnUpdate = Class_ReplaceMethod("Harvester", "OnUpdate",
		function(self, deltaTime)
			originalHarvesterOnUpdate(self, deltaTime)
			
			if not self:GetIsAlive() then

				local destructionAllowedTable = { allowed = true }
				if self.GetDestructionAllowed then
					self:GetDestructionAllowed(destructionAllowedTable)
				end

				if destructionAllowedTable.allowed then
					DestroyEntity(self)
				end

			end
			
		end
	)

	function Harvester:OnKill(attacker, doer, point, direction)
		self:SetModel(nil)
		local attached = self:GetAttached()
		if attached then
			attached:ClearAttached()
		end
		self:ClearAttached()
	end
	
	function Harvester:GetPassiveBuild()
		return self:GetGameEffectMask(kGameEffect.OnInfestation)
	end

end

local networkVars = { }

AddMixinNetworkVars(InfestationMixin, networkVars)

Shared.LinkClassToMap("Harvester", Harvester.kMapName, networkVars)