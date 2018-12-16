-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\Shift.lua
-- - Dragon

-- SHIFT
local originalShiftOnInitialized
originalShiftOnInitialized = Class_ReplaceMethod("Shift", "OnInitialized",
	function(self)
		InitMixin(self, InfestationMixin)
		originalShiftOnInitialized(self)
	end
)

function Shift:GetInfestationRadius()
    return kStructureInfestationRadius
end

function Shift:GetInfestationMaxRadius()
    return kStructureInfestationRadius
end

function Shift:GetAllowedInfestationDestruction()
	return self.moving
end

function Shift:GetIsFlameAble()
    return true
end

if Client then

	local originalShiftOnUpdate
	originalShiftOnUpdate = Class_ReplaceMethod("Shift", "OnUpdate",
		function(self, deltaTime)
			originalShiftOnUpdate(self, deltaTime)

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

local networkVars = { }

AddMixinNetworkVars(InfestationMixin, networkVars)

Shared.LinkClassToMap("Shift", Shift.kMapName, networkVars)