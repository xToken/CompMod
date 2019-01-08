-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Harvester\server.lua
-- - Dragon

-- Harvester
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

function Harvester:GetDestroyOnKill()
	return false
end

function Harvester:OnKill(attacker, doer, point, direction)
	self:SetModel(nil)
	local attached = self:GetAttached()
	if attached then
		attached:ClearAttached()
	end
	self:ClearAttached()
	local team = self:GetTeam()
	if team then
		team:OnTeamEntityDestroyed(self)
	end
end

function Harvester:OnTeleport()
	self:SetDesiredInfestationRadius(0)
end

function Harvester:OnTeleportFailed()
	self:SetDesiredInfestationRadius(self:GetInfestationMaxRadius())
end

function Harvester:OnTeleportEnd(destinationEntity)
	self:CleanupInfestation()
end

function Harvester:GetPassiveBuild()
	return self:GetGameEffectMask(kGameEffect.OnInfestation)
end