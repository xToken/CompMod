//Dont want to always replace random files, so this.

local gMarineMenuButtons = GetUpValue( MarineCommander.GetQuickMenuTechButtons,   "gMarineMenuButtons" )

if gMarineMenuButtons then
	if gMarineMenuButtons[kTechId.WeaponsMenu] and type(gMarineMenuButtons[kTechId.WeaponsMenu]) == "table" then
		//Shift icons around
		gMarineMenuButtons[kTechId.WeaponsMenu][2] = kTechId.DropFlamethrower
		gMarineMenuButtons[kTechId.WeaponsMenu][3] = kTechId.DropHeavyMachineGun
		gMarineMenuButtons[kTechId.WeaponsMenu][4] = kTechId.DropGrenadeLauncher
		gMarineMenuButtons[kTechId.WeaponsMenu][5] = kTechId.DropWelder
		gMarineMenuButtons[kTechId.WeaponsMenu][6] = kTechId.DropMines
		gMarineMenuButtons[kTechId.WeaponsMenu][7] = kTechId.DropJetpack
	end
end