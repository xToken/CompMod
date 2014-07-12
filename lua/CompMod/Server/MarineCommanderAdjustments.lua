//Dont want to always replace random files, so this.

local GetIsEquipment = GetUpValue( MarineCommander.ProcessTechTreeActionForEntity,   "GetIsEquipment" )

local function ExtendedGetIsEquipment(techId)
	return GetIsEquipment(techId) or techId == kTechId.DropHeavyMachineGun
end

ReplaceLocals(MarineCommander.ProcessTechTreeActionForEntity, { GetIsEquipment = ExtendedGetIsEquipment })