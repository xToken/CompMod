// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\MarineCommanderAdjustments.lua
// - Dragon

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