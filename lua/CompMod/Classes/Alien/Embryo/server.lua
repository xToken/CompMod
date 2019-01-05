-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Alien\Embryo\server.lua
-- - Dragon

local originalEmbryoSetGestationData
originalEmbryoSetGestationData = Class_ReplaceMethod("Embryo", "SetGestationData",
	function(self, techIds, previousTechId, healthScalar, armorScalar)
		local currentUpgrades = self:GetUpgrades()
		local allowedUpgrades = GetNumberOfAllowedUpgrades(self)
		local gestateId = kTechId.None

		for i = #techIds, 1, -1 do
	        if LookupTechData(techIds[i], kTechDataGestateName) then
	        	gestateId = techIds[i]
	        	table.remove(techIds, i)
	        	break
	        end
	    end

	    if #techIds > allowedUpgrades then
		    for i = #techIds, 1, -1 do
		    	if #techIds > allowedUpgrades then
		    		Print(string.format("Removing upgrade %s as client is over their limit!", techIds[i]))
		    		table.remove(techIds, i)
		    	else
		    		break
		    	end
		    end
		end
	    if gestateId ~= kTechId.None then
	    	table.insert(techIds, gestateId)
	    end

		originalEmbryoSetGestationData(self, techIds, previousTechId, healthScalar, armorScalar)
		
		local lifeformTime = ConditionalValue(self.gestationTypeTechId ~= previousTechId, self:GetGestationTime(self.gestationTypeTechId), 0)
    
		local newUpgradesAmount = 0
		local replacementUpgrades = { }
		
		for _, upgradeId in ipairs(self.evolvingUpgrades) do
		
			if not table.contains(currentUpgrades, upgradeId) then
				newUpgradesAmount = newUpgradesAmount + 1
			end
			-- Only pay for swapping upgrades if not gestating into new lifeform.
			if lifeformTime == 0 then
				local currentCategory = LookupTechData(upgradeId, kTechDataCategory, kTechId.None)
				for _, cId in ipairs(currentUpgrades) do
					if LookupTechData(cId, kTechDataCategory, kTechId.None) == currentCategory and not table.contains(self.evolvingUpgrades, cId) and not table.contains(replacementUpgrades, cId) then
						table.insert(replacementUpgrades, cId)
					end
				end
			end
		end
		
		self.gestationTime = math.max(lifeformTime + (newUpgradesAmount * kUpgradeGestationTime) + (#replacementUpgrades * kUpgradeSwapGestateTime), 2)

		if Embryo.gFastEvolveCheat then
			self.gestationTime = 5
		elseif Shared.GetDevMode() or GetGameInfoEntity():GetWarmUpActive() then
			self.gestationTime = 1
		end
	
	end
)