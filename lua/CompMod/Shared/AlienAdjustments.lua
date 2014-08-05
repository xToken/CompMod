//Dont want to always replace random files, so this.

// Add healing per second cap to aliens.
// This also implements lower healing if onfire.
local originalAlienModifyHeal
originalAlienModifyHeal = Class_ReplaceMethod("Alien", "ModifyHeal",
	function(self, healTable)
		
		if self.lasthealingtable == nil then
			self.lasthealingtable = {time = 0, healing = 0}
		end
		
		local curtime = Shared.GetTime()
		
		if curtime < self.lasthealingtable.time + kAlienHealRateTimeLimit then
			//Check current max limit
			if self.lasthealingtable.healing >= kAlienHealRateLimit then
				//We're over the limit, reduce.
				//Shared.Message(string.format("Healing reduced after exceeding rate limit to %s from %s", healTable.health * kAlienHealRateOverLimitReduction, healTable.health))
				healTable.health = healTable.health * kAlienHealRateOverLimitReduction
			elseif self.lasthealingtable.healing >= (self:GetBaseHealth() * kAlienHealRatePercentLimit) then	//Check current % limit
				//We're over the limit, reduce.
				//Shared.Message(string.format("Healing reduced after exceeding rate percentage to %s from %s", healTable.health * kAlienHealRateOverLimitReduction, healTable.health))
				healTable.health = healTable.health * kAlienHealRateOverLimitReduction
			end
			//Add to current limit
			self.lasthealingtable.healing = self.lasthealingtable.healing + healTable.health
		else
			//Not under limit, clear table
			self.lasthealingtable.time = curtime
			self.lasthealingtable.healing = healTable.health
		end
		
	end
)