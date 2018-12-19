-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\Crag.lua
-- - Dragon

Crag.kHealRadius = kCragHealRange
Crag.kHealPercentage = kCragHealPercentage
Crag.kMinHeal = kCragkMinHeal
Crag.kMaxHeal = kCragkMaxHeal
Crag.kHealWaveDuration = kCragHealWaveDuration
Crag.kHealWaveMultiplier = kCragHealWaveMultiplier
Crag.kHealInterval = kCragHealingInterval

-- CRAG
local originalCragOnInitialized
originalCragOnInitialized = Class_ReplaceMethod("Crag", "OnInitialized",
	function(self)
		InitMixin(self, InfestationMixin)
		originalCragOnInitialized(self)
	end
)

function Crag:GetInfestationRadius()
    return kStructureInfestationRadius
end

function Crag:GetInfestationMaxRadius()
    return kStructureInfestationRadius
end

function Crag:GetAllowedInfestationDestruction()
	return self.moving
end

function Crag:UpdateHealing()

    local time = Shared.GetTime()
    
    if ( self.timeOfLastHeal == nil or (time > self.timeOfLastHeal + Crag.kHealInterval) ) then    
        self:PerformHealing()        
    end
    
end

function Crag:GetTechAllowed(techId, techNode, player)
    return ScriptActor.GetTechAllowed(self, techId, techNode, player)
end

if Client then

	local originalCragOnUpdate
	originalCragOnUpdate = Class_ReplaceMethod("Crag", "OnUpdate",
		function(self, deltaTime)
			originalCragOnUpdate(self, deltaTime)

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

	function Crag:OnKill(attacker, doer, point, direction)
		self:SetModel(nil)
		local team = self:GetTeam()
		if team then
			team:OnTeamEntityDestroyed(self)
		end
	end
	
	function Crag:GetPassiveBuild()
		return self:GetGameEffectMask(kGameEffect.OnInfestation)
	end

end

local networkVars = { }

AddMixinNetworkVars(InfestationMixin, networkVars)

Shared.LinkClassToMap("Crag", Crag.kMapName, networkVars)