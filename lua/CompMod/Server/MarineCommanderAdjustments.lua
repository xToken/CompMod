// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Server\MarineCommanderAdjustments.lua
// - Dragon

local GetIsEquipment = GetUpValue( MarineCommander.ProcessTechTreeActionForEntity,   "GetIsEquipment" )

local function ExtendedGetIsEquipment(techId)
	return GetIsEquipment(techId) or techId == kTechId.DropHeavyMachineGun
end

ReplaceLocals(MarineCommander.ProcessTechTreeActionForEntity, { GetIsEquipment = ExtendedGetIsEquipment })