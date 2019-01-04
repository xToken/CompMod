-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Alien\Alien\server.lua
-- - Dragon

local originalAlienUpdateAutoHeal
originalAlienUpdateAutoHeal = Class_ReplaceMethod("Alien", "UpdateAutoHeal",
	function(self)

		PROFILE("Alien:UpdateAutoHeal")

		if self:GetIsHealable() and ( not self.timeLastAlienAutoHeal or self.timeLastAlienAutoHeal + kAlienRegenerationTime <= Shared.GetTime() ) then

			local healRate = 1
			local shellLevel = self:GetShellLevel()
			local hasRegenUpgrade = shellLevel > 0 and GetHasRegenerationUpgrade(self)
			local maxHealth = self:GetBaseHealth()
			
			if hasRegenUpgrade then
				healRate = Clamp(kAlienRegenerationPercentage * maxHealth, kAlienMinRegeneration, kAlienMaxRegeneration) * (shellLevel / 3)
			else
				healRate = Clamp(kAlienInnateRegenerationPercentage * maxHealth, kAlienMinInnateRegeneration, kAlienMaxInnateRegeneration) 
			end

			self:AddHealth(healRate, false, false, not hasRegenUpgrade)  
			self.timeLastAlienAutoHeal = Shared.GetTime()

		end 

	end
)