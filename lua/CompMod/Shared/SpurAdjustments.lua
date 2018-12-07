-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\SpurAdjustments.lua
-- - Dragon

-- SPUR
local originalSpurOnInitialized
originalSpurOnInitialized = Class_ReplaceMethod("Spur", "OnInitialized",
	function(self)
		InitMixin(self, InfestationMixin)
		originalSpurOnInitialized(self)
	end
)

function Spur:GetInfestationRadius()
    return kStructureInfestationRadius
end

function Spur:GetInfestationMaxRadius()
    return kStructureInfestationRadius
end

if Server then

	local originalSpurOnUpdate
	originalSpurOnUpdate = Class_ReplaceMethod("Spur", "OnUpdate",
		function(self, deltaTime)
			originalSpurOnUpdate(self, deltaTime)
			
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

	function Spur:OnKill(attacker, doer, point, direction)
		self:SetModel(nil)
	end
	
	function Spur:GetPassiveBuild()
		return self:GetGameEffectMask(kGameEffect.OnInfestation)
	end

end

local networkVars = { }

AddMixinNetworkVars(InfestationMixin, networkVars)

Shared.LinkClassToMap("Spur", Spur.kMapName, networkVars)