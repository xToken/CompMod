
for _, v in ipairs( { 'Return', 'GorgeTunnelEntrance', 'GorgeTunnelExit', 'EvolutionChamber', 
					  'MetabolizeEnergy', 'MetabolizeHealth', 'HeavyMachineGunTech', 'HeavyMachineGun', 'DropHeavyMachineGun', 'ExoWelder' } ) do
	AppendToEnum( kTechId, v )
end

AppendToEnum( kMinimapBlipType, 'TunnelExit' )
AppendToEnum( kPlayerStatus, 'HMG' )

//This is relevant, not only to this but to any functions - it explains Reference/Value in lua function calls
//Tables, functions, threads, and (full) userdata values are objects: variables do not actually contain these values, only references to them.

local function AddCompModTechChanges(techData)
	// Comp Mod change, add tech crap
	table.insert(techData, { 	[kTechDataId] = kTechId.Return,
								[kTechDataDisplayName] = "Return",
								[kTechDataTooltipInfo] = "Returns to previous menu."})
								
	table.insert(techData, { 	[kTechDataId] = kTechId.MetabolizeEnergy,           
								[kTechDataCategory] = kTechId.Fade,
								[kTechDataMapName] = Metabolize.kMapName,
								[kTechDataCostKey] = kMetabolizeEnergyResearchCost, 
								[kTechDataResearchTimeKey] = kMetabolizeEnergyResearchTime,        
								[kTechDataDisplayName] = "Metabolize", 
								[kTechDataTooltipInfo] = "Allows fades to regen energy faster."})

	table.insert(techData, { 	[kTechDataId] = kTechId.MetabolizeHealth,           
								[kTechDataCategory] = kTechId.Fade,        
								[kTechDataCostKey] = kMetabolizeHealthResearchCost, 
								[kTechDataResearchTimeKey] = kMetabolizeHealthResearchTime,          
								[kTechDataDisplayName] = "Advanced Metabolize", 
								[kTechDataTooltipInfo] = "Allows fades to regen health and energy."})
								
	table.insert(techData, { 	[kTechDataId] = kTechId.EvolutionChamber,    
								[kTechDataHint] = "Evolution Chamber", 
								[kTechDataGhostModelClass] = "AlienGhostModel",    
								[kTechDataMapName] = EvolutionChamber.kMapName,                         
								[kTechDataDisplayName] = "Evolution Chamber",  
								[kTechDataCostKey] = 0,         
								[kTechDataBuildTime] = 0, 
								[kTechDataModel] = EvolutionChamber.kModelName,           
								[kTechDataMaxHealth] = 0, 
								[kTechDataMaxArmor] = 0,    
								[kTechDataTooltipInfo] = "Evolution Chamber"})
								
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
								
								
	for index, record in ipairs(techData) do 
        if record[kTechDataId] == kTechId.BabblerTech then
			record[kTechDataCostKey] = kBabblersResearchCost	
			record[kTechDataResearchTimeKey] = kBabblersResearchTime
			record[kTechDataDisplayName] = "Babblers"
			record[kTechDataTooltipInfo] = "Allows gorges to create babblers."
		end
		if record[kTechDataId] == kTechId.WebTech then
			record[kTechDataCostKey] = kWebResearchCost	
			record[kTechDataResearchTimeKey] = kWebResearchTime
			record[kTechDataDisplayName] = "Webs"
			record[kTechDataTooltipInfo] = "Allows gorges to create webs."
		end
		if record[kTechDataId] == kTechId.PrototypeLab then
			record[kTechDataMaxArmor] = kPrototypeLabArmor
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