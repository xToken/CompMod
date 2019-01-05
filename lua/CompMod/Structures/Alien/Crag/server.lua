-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Crag\server.lua
-- - Dragon

local originalCragOnUpdate
originalCragOnUpdate = Class_ReplaceMethod("Crag", "OnUpdate",
	function(self, deltaTime)
		originalCragOnUpdate(self, deltaTime)
		
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

function Crag:OnTeleport()
	self:SetDesiredInfestationRadius(0)
end

function Crag:GetDestroyOnKill()
	return false
end

local originalCragOnTeleportEnd
originalCragOnTeleportEnd = Class_ReplaceMethod("Crag", "OnTeleportEnd",
	function(self, destinationEntity)
		originalCragOnTeleportEnd(self, destinationEntity)
		self:CleanupInfestation()
	end
)

function Crag:OnKill(attacker, doer, point, direction)
	self:SetModel(nil)
	local team = self:GetTeam()
	if team then
		team:OnTeamEntityDestroyed(self)
	end
end