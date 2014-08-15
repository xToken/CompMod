//Dont want to always replace random files, so this.

local originalAlienOnCreate
originalAlienOnCreate = Class_ReplaceMethod("Alien", "OnCreate",
	function(self)
		originalAlienOnCreate(self)
		InitMixin(self, MucousableMixin)
	end
)

// Add healing per second cap to aliens.
// This also implements lower healing if onfire.
local originalAlienModifyHeal
originalAlienModifyHeal = Class_ReplaceMethod("Alien", "ModifyHeal",
	function(self, healTable)

		if self.isOnFire then
			healTable.health = healTable.health * kOnFireHealingScalar
		end
		
		if self.lasthealingtable == nil then
			self.lasthealingtable = {time = 0, healing = 0}
		end
		
		local curtime = Shared.GetTime()
		
		if curtime < self.lasthealingtable.time + kAlienHealRateTimeLimit then
			//Within timer, check values.
			//Check current max limit
			local tHeal = 0 	//Previous heals within timer.
			local rHeal = 0		//Unmodded heal from this heal instance.
			local mHeal = 0		//Modded heal from this instance.
			local pHeal = 0		//Current percentage of healing within timer, including this heal instance.
			local nHeal = 0		//Final effective heal after all modifications.
			tHeal = self.lasthealingtable.healing
			rHeal = healTable.health
			pHeal = (tHeal + rHeal) / self:GetBaseHealth()
			if (tHeal + rHeal) > kAlienHealRateLimit then
				//We're over the limit, reduce.
				//Get amount of health to mod, can only mod max amount recieving this heal.
				mHeal = Clamp((tHeal + rHeal) - kAlienHealRateLimit, 0, rHeal)
				//Adjust 'real' heal accordingly for partial amounts that were under limit
				rHeal = math.max(rHeal - mHeal, 0)
			elseif pHeal >= kAlienHealRatePercentLimit then
				//We're over the limit, reduce.
				//Get correct amount of HP to reduce if just exceeding cap.
				mHeal = Clamp((tHeal + rHeal) - (self:GetBaseHealth() * kAlienHealRatePercentLimit), 0, rHeal)
				//Lower 'real' unmodded healing accordingly.
				rHeal = math.max(rHeal - mHeal, 0)
			end
			nHeal = rHeal + math.max(mHeal * kAlienHealRateOverLimitReduction, 0)
			//Shared.Message(string.format("Healing cap information - Total Amount :%s - CurrentHeal :%s - Current Heal Percent :%s - Effective Heal :%s - 'Real' Heal :%s - 'Mod' Heal :%s - Healing Window :%s ", tHeal, healTable.health, pHeal, nHeal, rHeal, mHeal, kAlienHealRateTimeLimit))
			//Add to current limit
			healTable.health = nHeal
			self.lasthealingtable.healing = tHeal + nHeal
		else
			//Not under limit, clear table
			self.lasthealingtable.time = curtime
			self.lasthealingtable.healing = healTable.health
		end
		
	end
)

local networkVars = { }

AddMixinNetworkVars(MucousableMixin, networkVars)

Shared.LinkClassToMap("Alien", Alien.kMapName, networkVars, true)

//Skulk is exempt, just replace it
local originalSkulkModifyHeal
originalSkulkModifyHeal = Class_ReplaceMethod("Skulk", "ModifyHeal",
	function(self, healTable)
		if self.isOnFire then
			healTable.health = healTable.health * kOnFireHealingScalar
		end
	end
)