-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\ShadeAdjustments.lua
-- - Dragon

-- SHADE
local originalShadeOnInitialized
originalShadeOnInitialized = Class_ReplaceMethod("Shade", "OnInitialized",
	function(self)
		InitMixin(self, InfestationMixin)
		originalShadeOnInitialized(self)
	end
)

function Shade:GetInfestationRadius()
    return kStructureInfestationRadius
end

function Shade:GetInfestationMaxRadius()
    return kStructureInfestationRadius
end

function Shade:GetAllowedInfestationDestruction()
	return self.moving
end

if Client then

	local originalShadeOnUpdate
	originalShadeOnUpdate = Class_ReplaceMethod("Shade", "OnUpdate",
		function(self, deltaTime)
			originalShadeOnUpdate(self, deltaTime)

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

	function Shade:OnKill(attacker, doer, point, direction)
		self:SetModel(nil)
	end
	
	function Shade:GetPassiveBuild()
		return self:GetGameEffectMask(kGameEffect.OnInfestation)
	end

end

local networkVars = { }

AddMixinNetworkVars(InfestationMixin, networkVars)

Shared.LinkClassToMap("Shade", Shade.kMapName, networkVars)