-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Shell\server.lua
-- - Dragon

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

function Shell:OnTeleport()
	self:SetDesiredInfestationRadius(0)
end

function Shell:OnTeleportEnd(destinationEntity)
	self:CleanupInfestation()
end

function Shell:OnTeleportFailed()
    self:SetDesiredInfestationRadius(self:GetInfestationMaxRadius())
end

function Shell:GetDestroyOnKill()
	return false
end

function Shell:OnKill(attacker, doer, point, direction)
	self:SetModel(nil)
	local team = self:GetTeam()
	if team then
		team:OnTeamEntityDestroyed(self)
	end
end

function Shell:GetPassiveBuild()
	return self:GetGameEffectMask(kGameEffect.OnInfestation)
end