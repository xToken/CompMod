//Dont want to always replace random files, so this.

function Crag:TryHeal(target)

    local unclampedHeal = target:GetMaxHealth() * Crag.kHealPercentage
	
	if target.GetBaseHealth then
		//Shared.Message(string.format("Healing reduced to %s from %s", target:GetBaseHealth() * Crag.kHealPercentage, unclampedHeal))
		unclampedHeal = target:GetBaseHealth() * Crag.kHealPercentage
	end
	
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