// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Client\UpgradeChamberAdjustments.lua
// - Dragon

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