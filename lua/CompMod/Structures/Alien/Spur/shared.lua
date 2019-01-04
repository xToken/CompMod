-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Spur\shared.lua
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

if Client then

	local originalSpurOnUpdate
	originalSpurOnUpdate = Class_ReplaceMethod("Spur", "OnUpdate",
		function(self, deltaTime)
			originalSpurOnUpdate(self, deltaTime)
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
		local team = self:GetTeam()
		if team then
			team:OnTeamEntityDestroyed(self)
		end
	end
	
	function Spur:OnTeleport()
		self:SetDesiredInfestationRadius(0)
	end
	
	function Spur:OnTeleportEnd(destinationEntity)
		self:CleanupInfestation()
	end
	
	function Spur:GetPassiveBuild()
		return self:GetGameEffectMask(kGameEffect.OnInfestation)
	end

end

local networkVars = { }

AddMixinNetworkVars(InfestationMixin, networkVars)

Shared.LinkClassToMap("Spur", Spur.kMapName, networkVars)