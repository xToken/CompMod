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
	return newTechTable, techIdUpdates
end