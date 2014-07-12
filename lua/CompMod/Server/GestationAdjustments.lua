//Dont want to always replace random files, so this.

//Fix gestation times
local originalEmbryoSetGestationData
originalEmbryoSetGestationData = Class_ReplaceMethod("Embryo", "SetGestationData",
	function(self, techIds, previousTechId, healthScalar, armorScalar)
		local currentUpgrades = self:GetUpgrades()
		originalEmbryoSetGestationData(self, techIds, previousTechId, healthScalar, armorScalar)
		local lifeformTime = ConditionalValue(self.gestationTypeTechId ~= previousTechId, self:GetGestationTime(self.gestationTypeTechId), 0)
    
		local newUpgradesAmount = 0
		local replacementUpgrades = { }
		
		for _, upgradeId in ipairs(self.evolvingUpgrades) do
		
			if not table.contains(currentUpgrades, upgradeId) then
				newUpgradesAmount = newUpgradesAmount + 1
			end
			local currentChamberId = GetHiveTypeForUpgrade(upgradeId)
			for _, cId in ipairs(currentUpgrades) do
				if GetHiveTypeForUpgrade(cId) == currentChamberId and not table.contains(self.evolvingUpgrades, cId) and not table.contains(replacementUpgrades, cId) then
					table.insert(replacementUpgrades, cId)
				end
			end
			
		end
		
		self.gestationTime = lifeformTime + (newUpgradesAmount * kUpgradeGestationTime) + (#replacementUpgrades * kReplaceUpgradeGestationTime)
		
		if Embryo.gFastEvolveCheat then
			self.gestationTime = 5
		elseif Shared.GetDevMode() then
			self.gestationTime = 2
		end
	
	end
)

//Guess I shouldnt be surprised...
local originalAlienProcessBuyAction
originalAlienProcessBuyAction = Class_ReplaceMethod("Alien", "ProcessBuyAction",
	function(self, techIds)
		local reevolve = true
		if techIds and type(techIds) == "table" then
			local upgrades = self:GetUpgrades()
			if upgrades and type(upgrades) == "table" then
				for _, techId in ipairs(techIds) do
					if not table.contains(upgrades, techId) or not self:GetTechId() == techId then
						//New TechID
						reevolve = false
						break
					end
				end
				if reevolve then
					for _, techId in ipairs(upgrades) do
						if not table.contains(techIds, techId) then
							//Removed TechID
							reevolve = false
							break
						end
					end
				end
			end
		end
		if reevolve then
			//Server.SendNetworkMessage("Chat", BuildChatMessage(false, "Admin", -1, kTeamReadyRoom, kNeutralTeamType, string.format("%s attempted to re-evolve same upgrades.", self:GetName())), true)
		else
			originalAlienProcessBuyAction(self, techIds)
		end
	end
)