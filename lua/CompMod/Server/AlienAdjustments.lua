//Dont want to always replace random files, so this.

//Not truly healable if you're not hurt...
function Alien:GetIsHealableOverride()
	return self:GetIsAlive() and self:AmountDamaged() > 0
end

local originalAlienGetIsHealableOverride
originalAlienGetIsHealableOverride = Class_ReplaceMethod("Alien", "UpdateAutoHeal",
	function(self)
	
		PROFILE("Alien:UpdateAutoHeal")
		local stime = Shared.GetTime()
		
		if self:GetIsHealable() and ( not self.timeLastAlienAutoHeal or self.timeLastAlienAutoHeal + kAlienRegenerationTime <= stime ) then

			local healRate = 1
			local hasRegenUpgrade = GetHasRegenerationUpgrade(self)
			local shellLevel = GetShellLevel(self:GetTeamNumber())
			local maxHealth = self:GetBaseHealth()
			
			hasRegenUpgrade = hasRegenUpgrade and (self.lastTakenDamageTime == nil or stime > self.lastTakenDamageTime + kAlienRegenBlockonDamage)
			
			if hasRegenUpgrade and shellLevel > 0 then
				healRate = Clamp(kAlienRegenerationPercentage * maxHealth, kAlienMinRegeneration, kAlienMaxRegeneration) * (shellLevel/3)
			else
				healRate = Clamp(kAlienInnateRegenerationPercentage * maxHealth, kAlienMinInnateRegeneration, kAlienMaxInnateRegeneration) 
			end
			
			if self:GetIsInCombat() then
				healRate = healRate * kAlienRegenerationCombatModifier
			end

			self:AddHealth(healRate, false, false, not hasRegenUpgrade)  
			self.timeLastAlienAutoHeal = stime
		
		end 

	end
)