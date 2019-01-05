-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Veil\server.lua
-- - Dragon

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

function Veil:GetDestroyOnKill()
	return false
end

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