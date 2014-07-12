//Dont want to always replace random files, so this.

local function SetupUpgradeChamberChanges()
	local kIndexToUpgrades = GetUpValue( GUIUpgradeChamberDisplay.Update,   "kIndexToUpgrades" )
	//Attempt to make changes
	for i = 1, 3 do
		if kIndexToUpgrades[i][1] == kTechId.Veil then
			//Remove phantom if it exists
			for j = 1, #kIndexToUpgrades[i] do
				if kIndexToUpgrades[i][j] == kTechId.Phantom then
					table.remove(kIndexToUpgrades[i], j)
				end
			end
			//Add new upgrades
			table.insert(kIndexToUpgrades[i], kTechId.Silence)
			table.insert(kIndexToUpgrades[i], kTechId.Camouflage)
		end
	end
	//ReplaceLocals(GUIUpgradeChamberDisplay.Update, { kIndexToUpgrades = kIndexToUpgrades }) 
end

AddPostInitOverride("GUIUpgradeChamberDisplay", SetupUpgradeChamberChanges)