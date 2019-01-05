-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Spur\server.lua
-- - Dragon

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

function Spur:GetDestroyOnKill()
	return false
end

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