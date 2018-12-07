-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\ShellAdjustments.lua
-- - Dragon

-- SHELL
local originalShellOnInitialized
originalShellOnInitialized = Class_ReplaceMethod("Shell", "OnInitialized",
	function(self)
		InitMixin(self, InfestationMixin)
		originalShellOnInitialized(self)
	end
)

function Shell:GetInfestationRadius()
    return kStructureInfestationRadius
end

function Shell:GetInfestationMaxRadius()
    return kStructureInfestationRadius
end

if Server then

	local originalShellOnUpdate
	originalShellOnUpdate = Class_ReplaceMethod("Shell", "OnUpdate",
		function(self, deltaTime)
			originalShellOnUpdate(self, deltaTime)
			
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

	function Shell:OnKill(attacker, doer, point, direction)
		self:SetModel(nil)
	end
	
	function Shell:GetPassiveBuild()
		return self:GetGameEffectMask(kGameEffect.OnInfestation)
	end

end

local networkVars = { }

AddMixinNetworkVars(InfestationMixin, networkVars)

Shared.LinkClassToMap("Shell", Shell.kMapName, networkVars)