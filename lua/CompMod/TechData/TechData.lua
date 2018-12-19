-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\TechData\TechData.lua
-- - Dragon

-- This file contains all the updated tech data.  In mostly one place to make my life easier!
function BuildCompModTechDataUpdates()
	local newTechTable = { }
	local techIdUpdates = { }
	-- New Tech Data
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.FlamethrowerUpgrade1,
			[kTechDataCostKey] = kFlamethrowerUpgrade1Cost,
			[kTechDataResearchTimeKey] = kFlamethrowerUpgrade1ResearchTime,
			[kTechDataDisplayName] = "MARINE_FT_1",
			[kTechDataTooltipInfo] = "MARINE_FT_1_TOOLTIP",
			[kTechDataButtonID] = 86
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.ShotgunUpgrade1,
			[kTechDataCostKey] = kShotgunUpgrade1Cost,
			[kTechDataResearchTimeKey] = kShotgunUpgrade1ResearchTime,
			[kTechDataDisplayName] = "MARINE_SHOTGUN_1",
			[kTechDataTooltipInfo] = "MARINE_SHOTGUN_1_TOOLTIP",
			[kTechDataButtonID] = 85
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.ShotgunUpgrade2,
			[kTechDataCostKey] = kShotgunUpgrade2Cost,
			[kTechDataResearchTimeKey] = kShotgunUpgrade2ResearchTime,
			[kTechDataDisplayName] = "MARINE_SHOTGUN_2",
			[kTechDataTooltipInfo] = "MARINE_SHOTGUN_2_TOOLTIP",
			[kTechDataButtonID] = 85
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.MGUpgrade1,
			[kTechDataCostKey] = kMGUpgrade1Cost,
			[kTechDataResearchTimeKey] = kMGUpgrade1ResearchTime,
			[kTechDataDisplayName] = "MARINE_MG_1",
			[kTechDataTooltipInfo] = "MARINE_MG_1_TOOLTIP",
			[kTechDataButtonID] = 171
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.MGUpgrade2,
			[kTechDataCostKey] = kMGUpgrade2Cost,
			[kTechDataResearchTimeKey] = kMGUpgrade2ResearchTime,
			[kTechDataDisplayName] = "MARINE_MG_2",
			[kTechDataTooltipInfo] = "MARINE_MG_2_TOOLTIP",
			[kTechDataButtonID] = 171
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.GLUpgrade1,
			[kTechDataCostKey] = kGLUpgrade1Cost,
			[kTechDataResearchTimeKey] = kGLUpgrade1ResearchTime,
			[kTechDataDisplayName] = "MARINE_GL_1",
			[kTechDataTooltipInfo] = "MARINE_GL_1_TOOLTIP",
			[kTechDataButtonID] = 87
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.JetpackUpgrade1,
			[kTechDataCostKey] = kJetpackUpgrade1Cost,
			[kTechDataResearchTimeKey] = kJetpackUpgrade1ResearchTime,
			[kTechDataDisplayName] = "MARINE_JP_1",
			[kTechDataTooltipInfo] = "MARINE_JP_1_TOOLTIP",
			[kTechDataImplemented] = false,
			[kTechDataButtonID] = 89
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.ExoUpgrade1,
			[kTechDataCostKey] = kExoUpgrade1Cost,
			[kTechDataResearchTimeKey] = kExoUpgrade1ResearchTime,
			[kTechDataDisplayName] = "MARINE_EXO_1",
			[kTechDataTooltipInfo] = "MARINE_EXO_1_TOOLTIP",
			[kTechDataImplemented] = false,
			[kTechDataButtonID] = 25
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.ExoUpgrade2,
			[kTechDataCostKey] = kExoUpgrade2Cost,
			[kTechDataResearchTimeKey] = kExoUpgrade2ResearchTime,
			[kTechDataDisplayName] = "MARINE_EXO_2",
			[kTechDataTooltipInfo] = "MARINE_EXO_2_TOOLTIP",
			[kTechDataImplemented] = false,
			[kTechDataButtonID] = 25
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.MinigunUpgrade1,
			[kTechDataCostKey] = kMinigunUpgrade1Cost,
			[kTechDataResearchTimeKey] = kMinigunUpgrade1ResearchTime,
			[kTechDataDisplayName] = "MARINE_MINIGUN_1",
			[kTechDataTooltipInfo] = "MARINE_MINIGUN_1_TOOLTIP",
			[kTechDataImplemented] = false,
			[kTechDataButtonID] = 84
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.MinigunUpgrade2,
			[kTechDataCostKey] = kMinigunUpgrade2Cost,
			[kTechDataResearchTimeKey] = kMinigunUpgrade2ResearchTime,
			[kTechDataDisplayName] = "MARINE_MINIGUN_2",
			[kTechDataTooltipInfo] = "MARINE_MINIGUN_2_TOOLTIP",
			[kTechDataImplemented] = false,
			[kTechDataButtonID] = 84
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.RailgunUpgrade1,
			[kTechDataCostKey] = kRailgunUpgrade1Cost,
			[kTechDataResearchTimeKey] = kRailgunUpgrade1ResearchTime,
			[kTechDataDisplayName] = "MARINE_RAILGUN_1",
			[kTechDataTooltipInfo] = "MARINE_RAILGUN_1_TOOLTIP",
			[kTechDataImplemented] = false,
			[kTechDataButtonID] = 116
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.ARCUpgrade1,
			[kTechDataCostKey] = kARCUpgrade1Cost,
			[kTechDataResearchTimeKey] = kARCUpgrade1ResearchTime,
			[kTechDataDisplayName] = "MARINE_ARC_1",
			[kTechDataTooltipInfo] = "MARINE_ARC_1_TOOLTIP",
			[kTechDataButtonID] = 32
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.ARCUpgrade2,
			[kTechDataCostKey] = kARCUpgrade2Cost,
			[kTechDataResearchTimeKey] = kARCUpgrade2ResearchTime,
			[kTechDataDisplayName] = "MARINE_ARC_2",
			[kTechDataTooltipInfo] = "MARINE_ARC_2_TOOLTIP",
			[kTechDataButtonID] = 32
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.SentryUpgrade1,
			[kTechDataCostKey] = kSentryUpgrade1Cost,
			[kTechDataResearchTimeKey] = kSentryUpgrade1ResearchTime,
			[kTechDataDisplayName] = "MARINE_SENTRY_1",
			[kTechDataTooltipInfo] = "MARINE_SENTRY_1_TOOLTIP",
			[kTechDataImplemented] = false,
			[kTechDataButtonID] = 5
		})
	table.insert(newTechTable,	
		{
            [kTechDataId] = kTechId.Weapons1Upgrade,
            [kTechDataCostKey] = kWeapons1ResearchCost,
            [kTechDataResearchTimeKey] = kWeapons1ResearchTime,
            [kTechDataDisplayName] = "MARINE_WEAPONS1",
            [kTechDataHotkey] = Move.Z,
            [kTechDataTooltipInfo] = "MARINE_WEAPONS1_TOOLTIP",
			[kTechDataButtonID] = 80
        })
	table.insert(newTechTable,
        {
            [kTechDataId] = kTechId.Weapons2Upgrade,
            [kTechDataCostKey] = kWeapons2ResearchCost,
            [kTechDataResearchTimeKey] = kWeapons2ResearchTime,
            [kTechDataDisplayName] = "MARINE_WEAPONS2",
            [kTechDataHotkey] = Move.Z,
            [kTechDataTooltipInfo] = "MARINE_WEAPONS2_TOOLTIP",
			[kTechDataButtonID] = 81
        })
	table.insert(newTechTable,
        {
            [kTechDataId] = kTechId.Weapons3Upgrade,
            [kTechDataCostKey] = kWeapons3ResearchCost,
            [kTechDataResearchTimeKey] = kWeapons3ResearchTime,
            [kTechDataDisplayName] = "MARINE_WEAPONS3",
            [kTechDataHotkey] = Move.Z,
            [kTechDataTooltipInfo] = "MARINE_WEAPONS3_TOOLTIP",
			[kTechDataButtonID] = 82
        })
	table.insert(newTechTable,	
		{
            [kTechDataId] = kTechId.Armor1Upgrade,
            [kTechDataCostKey] = kArmor1ResearchCost,
            [kTechDataResearchTimeKey] = kArmor1ResearchTime,
            [kTechDataDisplayName] = "MARINE_ARMOR1",
            [kTechDataTooltipInfo] = "MARINE_ARMOR1_TOOLTIP",
			[kTechDataButtonID] = 77
        })
	table.insert(newTechTable,
        {
            [kTechDataId] = kTechId.Armor2Upgrade,
            [kTechDataCostKey] = kArmor2ResearchCost,
            [kTechDataResearchTimeKey] = kArmor2ResearchTime,
            [kTechDataDisplayName] = "MARINE_ARMOR2",
            [kTechDataTooltipInfo] = "MARINE_ARMOR2_TOOLTIP",
			[kTechDataButtonID] = 78
        })
	table.insert(newTechTable,
        {
            [kTechDataId] = kTechId.Armor3Upgrade,
            [kTechDataCostKey] = kArmor3ResearchCost,
            [kTechDataResearchTimeKey] = kArmor3ResearchTime,
            [kTechDataDisplayName] = "MARINE_ARMOR3",
            [kTechDataTooltipInfo] = "MARINE_ARMOR3_TOOLTIP",
			[kTechDataButtonID] = 79
        })

	-- Existing tech updates below!
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Harvester,
			[kTechDataRequiresInfestation] = false
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Crag,
			[kTechDataRequiresInfestation] = false
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Shift,
			[kTechDataRequiresInfestation] = false
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Shade,
			[kTechDataRequiresInfestation] = false
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Veil,
			[kTechDataRequiresInfestation] = false
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Spur,
			[kTechDataRequiresInfestation] = false
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Shell,
			[kTechDataRequiresInfestation] = false
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.NanoShieldTech,
			[kTechDataImplemented] = false
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.PowerSurgeTech,
			[kTechDataImplemented] = false
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TwoShells,
			[kTechDataBioMass] = kShellBiomass,
			[kTechDataHint] = "SHELL_HINT",
			[kTechDataGhostModelClass] = "AlienGhostModel",
			[kTechDataMapName] = Shell.kMapName,
			[kTechDataDisplayName] = "SHELL",
			[kTechDataCostKey] = kTwoShellsCost,
			[kTechDataRequiresInfestation] = true,
			[kTechDataHotkey] = Move.C,
			[kTechDataBuildTime] = kShellBuildTime,
			[kTechDataModel] = Shell.kModelName,
			[kTechDataMaxHealth] = kShellHealth,
			[kTechDataMaxArmor] = kShellArmor,
			[kTechDataPointValue] = kShellPointValue,
			[kTechDataTooltipInfo] = "SHELL_TOOLTIP",
			[kTechDataGrows] = true,
			[kTechDataObstacleRadius] = 0.75,
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.ThreeShells,
			[kTechDataBioMass] = kShellBiomass,
			[kTechDataHint] = "SHELL_HINT",
			[kTechDataGhostModelClass] = "AlienGhostModel",
			[kTechDataMapName] = Shell.kMapName,
			[kTechDataDisplayName] = "SHELL",
			[kTechDataCostKey] = kThreeShellsCost,
			[kTechDataRequiresInfestation] = true,
			[kTechDataHotkey] = Move.C,
			[kTechDataBuildTime] = kShellBuildTime,
			[kTechDataModel] = Shell.kModelName,
			[kTechDataMaxHealth] = kShellHealth,
			[kTechDataMaxArmor] = kShellArmor,
			[kTechDataPointValue] = kShellPointValue,
			[kTechDataTooltipInfo] = "SHELL_TOOLTIP",
			[kTechDataGrows] = true,
			[kTechDataObstacleRadius] = 0.75,
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TwoSpurs,
			[kTechDataBioMass] = kSpurBiomass,
			[kTechDataHint] = "SPUR_HINT",
			[kTechDataGhostModelClass] = "AlienGhostModel",
			[kTechDataMapName] = Spur.kMapName,
			[kTechDataDisplayName] = "SPUR",
			[kTechDataCostKey] = kTwoSpursCost,
			[kTechDataRequiresInfestation] = true,
			[kTechDataHotkey] = Move.C,
			[kTechDataBuildTime] = kSpurBuildTime,
			[kTechDataModel] = Spur.kModelName,
			[kTechDataMaxHealth] = kSpurHealth,
			[kTechDataMaxArmor] = kSpurArmor,
			[kTechDataPointValue] = kSpurPointValue,
			[kTechDataTooltipInfo] = "SPUR_TOOLTIP",
			[kTechDataGrows] = true,
			[kTechDataObstacleRadius] = 0.75,
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.ThreeSpurs,
			[kTechDataBioMass] = kSpurBiomass,
			[kTechDataHint] = "SPUR_HINT",
			[kTechDataGhostModelClass] = "AlienGhostModel",
			[kTechDataMapName] = Spur.kMapName,
			[kTechDataDisplayName] = "SPUR",
			[kTechDataCostKey] = kThreeSpursCost,
			[kTechDataRequiresInfestation] = true,
			[kTechDataHotkey] = Move.C,
			[kTechDataBuildTime] = kSpurBuildTime,
			[kTechDataModel] = Spur.kModelName,
			[kTechDataMaxHealth] = kSpurHealth,
			[kTechDataMaxArmor] = kSpurArmor,
			[kTechDataPointValue] = kSpurPointValue,
			[kTechDataTooltipInfo] = "SPUR_TOOLTIP",
			[kTechDataGrows] = true,
			[kTechDataObstacleRadius] = 0.75,
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TwoVeils,
			[kTechDataBioMass] = kVeilBiomass,
			[kTechDataHint] = "VEIL_HINT",
			[kTechDataGhostModelClass] = "AlienGhostModel",
			[kTechDataMapName] = Veil.kMapName,
			[kTechDataDisplayName] = "VEIL",
			[kTechDataCostKey] = kTwoVeilsCost,
			[kTechDataRequiresInfestation] = true,
			[kTechDataHotkey] = Move.C,
			[kTechDataBuildTime] = kVeilBuildTime,
			[kTechDataModel] = Veil.kModelName,
			[kTechDataMaxHealth] = kVeilHealth,
			[kTechDataMaxArmor] = kVeilArmor,
			[kTechDataPointValue] = kVeilPointValue,
			[kTechDataTooltipInfo] = "VEIL_TOOLTIP",
			[kTechDataGrows] = true,
			[kTechDataObstacleRadius] = 0.5,
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.ThreeVeils,
			[kTechDataBioMass] = kVeilBiomass,
			[kTechDataHint] = "VEIL_HINT",
			[kTechDataGhostModelClass] = "AlienGhostModel",
			[kTechDataMapName] = Veil.kMapName,
			[kTechDataDisplayName] = "VEIL",
			[kTechDataCostKey] = kThreeVeilsCost,
			[kTechDataRequiresInfestation] = true,
			[kTechDataHotkey] = Move.C,
			[kTechDataBuildTime] = kVeilBuildTime,
			[kTechDataModel] = Veil.kModelName,
			[kTechDataMaxHealth] = kVeilHealth,
			[kTechDataMaxArmor] = kVeilArmor,
			[kTechDataPointValue] = kVeilPointValue,
			[kTechDataTooltipInfo] = "VEIL_TOOLTIP",
			[kTechDataGrows] = true,
			[kTechDataObstacleRadius] = 0.5,
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.ShiftEnergize,
			[kTechDataCooldown] = kShiftEnergizeCooldown,
			[kTechDataCostKey] = kShiftEnergizeCost,
			[kTechDataOneAtATime] = true,
		})		
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Weapons1,
			[kTechDataCostKey] = kArmsLabCost + kWeapons1ResearchCost,
			[kTechDataRequiresPower] = true,
			[kTechIDShowEnables] = false,
			[kTechDataMapName] = Weapons1ArmsLab.kMapName,
			[kTechDataModel] = ArmsLab.kModelName,
			[kTechDataBuildTime] = kArmsLabBuildTime,
			[kTechDataMaxHealth] = kArmsLabHealth,
			[kTechDataMaxArmor] = kArmsLabArmor,
			[kTechDataEngagementDistance] = kArmsLabEngagementDistance,
			[kTechDataNotOnInfestation] = kPreventMarineStructuresOnInfestation,
			[kTechDataHint] = "MARINE_WEAPONS1",
			[kTechDataDisplayName] = "MARINE_WEAPONS1",
			[kTechDataTooltipInfo] = "MARINE_WEAPONS1_TOOLTIP",
			[kTechDataObstacleRadius] = 0.25,
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Weapons2,
			[kTechDataCostKey] = kArmsLabCost + kWeapons2ResearchCost + kWeapons1ResearchCost,
			[kTechDataRequiresPower] = true,
			[kTechIDShowEnables] = false,
			[kTechDataMapName] = Weapons2ArmsLab.kMapName,
			[kTechDataModel] = ArmsLab.kModelName,
			[kTechDataBuildTime] = kArmsLabBuildTime,
			[kTechDataMaxHealth] = kArmsLabHealth,
			[kTechDataMaxArmor] = kArmsLabArmor,
			[kTechDataEngagementDistance] = kArmsLabEngagementDistance,
			[kTechDataNotOnInfestation] = kPreventMarineStructuresOnInfestation,
			[kTechDataHint] = "MARINE_WEAPONS2",
			[kTechDataDisplayName] = "MARINE_WEAPONS2",
			[kTechDataTooltipInfo] = "MARINE_WEAPONS2_TOOLTIP",
			[kTechDataObstacleRadius] = 0.25,
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Weapons3,
			[kTechDataCostKey] = kArmsLabCost + kWeapons3ResearchCost + kWeapons2ResearchCost + kWeapons1ResearchCost,
			[kTechDataRequiresPower] = true,
			[kTechIDShowEnables] = false,
			[kTechDataMapName] = Weapons3ArmsLab.kMapName,
			[kTechDataModel] = ArmsLab.kModelName,
			[kTechDataBuildTime] = kArmsLabBuildTime,
			[kTechDataMaxHealth] = kArmsLabHealth,
			[kTechDataMaxArmor] = kArmsLabArmor,
			[kTechDataEngagementDistance] = kArmsLabEngagementDistance,
			[kTechDataNotOnInfestation] = kPreventMarineStructuresOnInfestation,
			[kTechDataHint] = "MARINE_WEAPONS3",
			[kTechDataDisplayName] = "MARINE_WEAPONS3",
			[kTechDataTooltipInfo] = "MARINE_WEAPONS3_TOOLTIP",
			[kTechDataObstacleRadius] = 0.25,
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Armor1,
			[kTechDataCostKey] = kArmsLabCost + kArmor1ResearchCost,
			[kTechDataRequiresPower] = true,
			[kTechIDShowEnables] = false,
			[kTechDataMapName] = Armor1ArmsLab.kMapName,
			[kTechDataModel] = ArmsLab.kModelName,
			[kTechDataBuildTime] = kArmsLabBuildTime,
			[kTechDataMaxHealth] = kArmsLabHealth,
			[kTechDataMaxArmor] = kArmsLabArmor,
			[kTechDataEngagementDistance] = kArmsLabEngagementDistance,
			[kTechDataNotOnInfestation] = kPreventMarineStructuresOnInfestation,
			[kTechDataHint] = "MARINE_ARMOR1",
			[kTechDataDisplayName] = "MARINE_ARMOR1",
			[kTechDataTooltipInfo] = "MARINE_ARMOR1_TOOLTIP",
			[kTechDataObstacleRadius] = 0.25,
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Armor2,
			[kTechDataCostKey] = kArmsLabCost + kArmor2ResearchCost + kArmor1ResearchCost,
			[kTechDataRequiresPower] = true,
			[kTechIDShowEnables] = false,
			[kTechDataMapName] = Armor2ArmsLab.kMapName,
			[kTechDataModel] = ArmsLab.kModelName,
			[kTechDataBuildTime] = kArmsLabBuildTime,
			[kTechDataMaxHealth] = kArmsLabHealth,
			[kTechDataMaxArmor] = kArmsLabArmor,
			[kTechDataEngagementDistance] = kArmsLabEngagementDistance,
			[kTechDataNotOnInfestation] = kPreventMarineStructuresOnInfestation,
			[kTechDataHint] = "MARINE_ARMOR2",
			[kTechDataDisplayName] = "MARINE_ARMOR2",
			[kTechDataTooltipInfo] = "MARINE_ARMOR2_TOOLTIP",
			[kTechDataObstacleRadius] = 0.25,
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Armor3,
			[kTechDataCostKey] = kArmsLabCost + kArmor3ResearchCost + kArmor2ResearchCost + kArmor1ResearchCost,
			[kTechDataRequiresPower] = true,
			[kTechIDShowEnables] = false,
			[kTechDataMapName] = Armor3ArmsLab.kMapName,
			[kTechDataModel] = ArmsLab.kModelName,
			[kTechDataBuildTime] = kArmsLabBuildTime,
			[kTechDataMaxHealth] = kArmsLabHealth,
			[kTechDataMaxArmor] = kArmsLabArmor,
			[kTechDataEngagementDistance] = kArmsLabEngagementDistance,
			[kTechDataNotOnInfestation] = kPreventMarineStructuresOnInfestation,
			[kTechDataHint] = "MARINE_ARMOR3",
			[kTechDataDisplayName] = "MARINE_ARMOR3",
			[kTechDataTooltipInfo] = "MARINE_ARMOR3_TOOLTIP",
			[kTechDataObstacleRadius] = 0.25,
		})
	return newTechTable, techIdUpdates
end