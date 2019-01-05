-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Crag\shared.lua
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

function Crag:TryHeal(target)

    local unclampedHeal = target:GetMaxHealth() * Crag.kHealPercentage * self:GetMaturityScaling()
    local heal = Clamp(unclampedHeal, Crag.kMinHeal, Crag.kMaxHeal)
    
    if self.healWaveActive then
        heal = heal * Crag.kHealWaveMultiplier
    end
    
    if target:GetHealthScalar() ~= 1 and (not target.timeLastCragHeal or target.timeLastCragHeal + Crag.kHealInterval <= Shared.GetTime()) then
    
        local amountHealed = target:AddHealth(heal)
        target.timeLastCragHeal = Shared.GetTime()
        return amountHealed
        
    else
        return 0
    end
    
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

function Crag:ShouldGenerateInfestation()
    return not self.moving
end

local networkVars = { }

AddMixinNetworkVars(InfestationMixin, networkVars)

Shared.LinkClassToMap("Crag", Crag.kMapName, networkVars)