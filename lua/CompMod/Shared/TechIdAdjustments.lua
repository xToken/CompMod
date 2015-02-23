
for _, v in ipairs( { 'GorgeTunnelEntrance', 'GorgeTunnelExit', 'HeavyMachineGunTech', 'HeavyMachineGun', 'DropHeavyMachineGun', 'ARCSpeedBoost' } ) do
	AppendToEnum( kTechId, v )
end

AppendToEnum( kMinimapBlipType, 'TunnelExit' )
AppendToEnum( kPlayerStatus, 'HMG' )

//This is relevant, not only to this but to any functions - it explains Reference/Value in lua function calls
//Tables, functions, threads, and (full) userdata values are objects: variables do not actually contain these values, only references to them.

kTechDataCustomBuildTime = "custombuildtime"
kTechDataCustomBuildTimeFunction = "custombuildtimefunc"

local function AddCompModTechChanges(techData)
	// Comp Mod change, add tech crap								
	table.insert(techData, { 	[kTechDataId] = kTechId.GorgeTunnelEntrance,
								[kTechDataCategory] = kTechId.Gorge,
								[kTechDataMaxExtents] = Vector(1.2, 1.2, 1.2),
								[kTechDataTooltipInfo] = "GORGE_TUNNEL_TOOLTIP",
								[kTechDataGhostModelClass] = "AlienGhostModel",
								[kTechDataAllowConsumeDrop] = true,
								[kTechDataAllowStacking] = false,
								[kTechDataMaxAmount] = 1,
								[kTechDataMapName] = TunnelEntrance.kMapName,
								[kTechDataDisplayName] = "Gorge Tunnel Entrance",
								[kTechDataCostKey] = kGorgeTunnelCost,
								[kTechDataMaxHealth] = kTunnelEntranceHealth,
								[kTechDataMaxArmor] = kTunnelEntranceArmor,
								[kTechDataBuildTime] = kGorgeTunnelBuildTime,
								[kTechDataModel] = TunnelEntrance.kModelName,
								[kTechDataRequiresInfestation] = false,
								[kTechDataPointValue] = kTunnelEntrancePointValue })
								
	table.insert(techData, { 	[kTechDataId] = kTechId.GorgeTunnelExit,
								[kTechDataCategory] = kTechId.Gorge,
								[kTechDataMaxExtents] = Vector(1.2, 1.2, 1.2),
								[kTechDataTooltipInfo] = "GORGE_TUNNEL_TOOLTIP",
								[kTechDataGhostModelClass] = "AlienGhostModel",
								[kTechDataAllowConsumeDrop] = true,
								[kTechDataAllowStacking] = false,
								[kTechDataMaxAmount] = 1,
								[kTechDataMapName] = TunnelExit.kMapName,
								[kTechDataDisplayName] = "Gorge Tunnel Exit",
								[kTechDataCostKey] = kGorgeTunnelCost,
								[kTechDataMaxHealth] = kTunnelEntranceHealth,
								[kTechDataMaxArmor] = kTunnelEntranceArmor,
								[kTechDataBuildTime] = kGorgeTunnelBuildTime,
								[kTechDataModel] = TunnelExit.kModelName,
								[kTechDataRequiresInfestation] = false,
								[kTechDataPointValue] = kTunnelEntrancePointValue })
								
	table.insert(techData, { 	[kTechDataId] = kTechId.HeavyMachineGun,     
								[kTechDataMaxHealth] = kMarineWeaponHealth,    
								[kTechDataPointValue] = kHeavyMachineGunPointValue,      
								[kTechDataMapName] = HeavyMachineGun.kMapName,
								[kTechDataDisplayName] = "HeavyMachineGun",            
								[kTechDataTooltipInfo] =  "HeavyMachineGun",
								[kTechDataModel] = HeavyMachineGun.kModelName,
								[kTechDataDamageType] = kHeavyMachineGunDamageType,
								[kTechDataCostKey] = kHeavyMachineGunCost,
								[kStructureAttachId] = kTechId.AdvancedArmory,
								[kStructureAttachRange] = kArmoryWeaponAttachRange, 
								[kStructureAttachRequiresPower] = true })
								
	table.insert(techData, { 	[kTechDataId] = kTechId.DropHeavyMachineGun,   
								[kTechDataMapName] = HeavyMachineGun.kMapName, 
								[kTechDataDisplayName] = "HeavyMachineGun", 
								[kTechIDShowEnables] = false,  
								[kTechDataTooltipInfo] =  "Drop HeavyMachineGun", 
								[kTechDataModel] = HeavyMachineGun.kModelName, 
								[kTechDataCostKey] = kHeavyMachineGunDropCost, 
								[kStructureAttachId] = kTechId.AdvancedArmory,
								[kStructureAttachRange] = kArmoryWeaponAttachRange, 
								[kStructureAttachRequiresPower] = true })
								
	table.insert(techData, { 	[kTechDataId] = kTechId.HeavyMachineGunTech,      
								[kTechDataCostKey] = kHeavyMachineGunTechResearchCost,     
								[kTechDataResearchTimeKey] = kHeavyMachineGunTechResearchTime, 
								[kTechDataDisplayName] = "Research Heavy Machine Gun", 
								[kTechDataTooltipInfo] =  "Heavy Machine Gun"})
								
	table.insert(techData, { 	[kTechDataId] = kTechId.ARCSpeedBoost,      
								[kTechDataCostKey] = kARCSpeedBoostCost,
								[kTechDataCooldown] = kARCSpeedBoostCooldown,  
								[kTechDataDisplayName] = "ARC Speed Boost",
								[kTechDataTooltipInfo] =  [[ARC Speed Boost:  Temporarily increases the movement speed of this ARC by 15% for %]] .. ToString(kARCSpeedBoostDuration) .. "s seconds, also makes ARC immune to damage slowdown." })
								
	for index, record in ipairs(techData) do 
        if record[kTechDataId] == kTechId.BabblerTech then
			record[kTechDataCostKey] = kBabblersResearchCost	
			record[kTechDataResearchTimeKey] = kBabblersResearchTime
			record[kTechDataDisplayName] = "Babblers"
			record[kTechDataTooltipInfo] = "Allows gorges to create babblers."
		end
		if record[kTechDataId] == kTechId.DropFlamethrower then
			record[kStructureAttachId] = { kTechId.Armory, kTechId.AdvancedArmory }
		end
		if record[kTechDataId] == kTechId.Cyst then
			record[kTechDataCustomBuildTime] = true
			record[kTechDataCustomBuildTimeFunction] = GetCystConstructionTime
		end
    end
end

//You dumbass, the BuildTechData is global...
local oldBuildTechData = BuildTechData
function BuildTechData()
	local techData = oldBuildTechData()
	AddCompModTechChanges(techData)
	return techData
end