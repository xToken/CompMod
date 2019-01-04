-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Veil\shared.lua
-- - Dragon

-- VEIL
local originalVeilOnInitialized
originalVeilOnInitialized = Class_ReplaceMethod("Veil", "OnInitialized",
	function(self)
		InitMixin(self, InfestationMixin)
		originalVeilOnInitialized(self)
	end
)

function Veil:GetInfestationRadius()
    return kStructureInfestationRadius
end

function Veil:GetInfestationMaxRadius()
    return kStructureInfestationRadius
end

if Client then

	local originalVeilOnUpdate
	originalVeilOnUpdate = Class_ReplaceMethod("Veil", "OnUpdate",
		function(self, deltaTime)
			originalVeilOnUpdate(self, deltaTime)
			if self.isTeleporting ~= self.lastisTeleporting then
				-- This isnt good coding, but these is all over the place in vanilla
				if not self.isTeleporting then
					-- We are not moving, trigger clear, then infest start.
					self:CleanupInfestation()
				end
				self.lastisTeleporting = self.isTeleporting
			end
		end
	)

end

if Server then

	local originalVeilOnUpdate
	originalVeilOnUpdate = Class_ReplaceMethod("Veil", "OnUpdate",
		function(self, deltaTime)
			originalVeilOnUpdate(self, deltaTime)
			
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

	function Veil:OnKill(attacker, doer, point, direction)
		self:SetModel(nil)
		local team = self:GetTeam()
		if team then
			team:OnTeamEntityDestroyed(self)
		end
	end
	
	function Veil:OnTeleport()
		self:SetDesiredInfestationRadius(0)
	end
	
	function Veil:OnTeleportEnd(destinationEntity)
		self:CleanupInfestation()
	end
	
	function Veil:GetPassiveBuild()
		return self:GetGameEffectMask(kGameEffect.OnInfestation)
	end

end

local networkVars = { }

AddMixinNetworkVars(InfestationMixin, networkVars)

Shared.LinkClassToMap("Veil", Veil.kMapName, networkVars)