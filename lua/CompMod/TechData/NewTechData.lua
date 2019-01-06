-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\TechData\NewTechData.lua
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
			[kTechDataButtonID] = 89
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.ExoUpgrade1,
			[kTechDataCostKey] = kExoUpgrade1Cost,
			[kTechDataResearchTimeKey] = kExoUpgrade1ResearchTime,
			[kTechDataDisplayName] = "MARINE_EXO_1",
			[kTechDataTooltipInfo] = "MARINE_EXO_1_TOOLTIP",
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
			[kTechDataId] = kTechId.StructureMenu,
			[kTechDataDisplayName] = "BUILD_STRUCTURES",
			[kTechDataTooltipInfo] = "BUILD_STRUCTURES_TOOLTIP",
			[kTechDataButtonID] = 157
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.AdvancedStructureMenu,
			[kTechDataDisplayName] = "BUILD_ADV_STRUCTURES",
			[kTechDataTooltipInfo] = "BUILD_ADV_STRUCTURES_TOOLTIP",
			[kTechDataButtonID] = 11
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.OffensiveTraits,
			[kTechDataCostKey] = kOffensiveTraitCost,
			[kTechDataResearchTimeKey] = kOffensiveTraitResearchTime,
			[kTechDataDisplayName] = "OFFENSE_TRAITS",
			[kTechDataTooltipInfo] = "OFFENSE_TRAITS_TOOLTIP",
			[kTechDataButtonID] = 23
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.DefensiveTraits,
			[kTechDataCostKey] = kDefensiveTraitCost,
			[kTechDataResearchTimeKey] = kDefensiveTraitResearchTime,
			[kTechDataDisplayName] = "DEFENSE_TRAITS",
			[kTechDataTooltipInfo] = "DEFENSE_TRAITS_TOOLTIP",
			[kTechDataButtonID] = 22
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.MovementTraits,
			[kTechDataCostKey] = kMovementTraitCost,
			[kTechDataResearchTimeKey] = kMovementTraitResearchTime,
			[kTechDataDisplayName] = "MOVEMENT_TRAITS",
			[kTechDataTooltipInfo] = "MOVEMENT_TRAITS_TOOLTIP",
			[kTechDataButtonID] = 11
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.AdditionalTraitSlot1,
			[kTechDataCostKey] = kAdditionalTraitSlot1Cost,
			[kTechDataResearchTimeKey] = kAdditionalTraitSlot1ResearchTime,
			[kTechDataDisplayName] = "ADDITIONAL_TRAIT_SLOT",
			[kTechDataTooltipInfo] = "ADDITIONAL_TRAIT_SLOT_TOOLTIP",
			[kTechDataButtonID] = 70
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.AdditionalTraitSlot2,
			[kTechDataCostKey] = kAdditionalTraitSlot2Cost,
			[kTechDataResearchTimeKey] = kAdditionalTraitSlot2ResearchTime,
			[kTechDataDisplayName] = "ADDITIONAL_TRAIT_SLOT_2",
			[kTechDataTooltipInfo] = "ADDITIONAL_TRAIT_SLOT_2_TOOLTIP",
			[kTechDataButtonID] = 65
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.HealingRoost,
			[kTechDataCostKey] = kHealingRoostCost,
			[kTechDataResearchTimeKey] = kHealingRoostResearchTime,
			[kTechDataDisplayName] = "HEALING_ROOST",
			[kTechDataTooltipInfo] = "HEALING_ROOST_TOOLTIP",
			[kTechDataButtonID] = 166
		})
	table.insert(newTechTable,
		{
			[kTechDataId] = kTechId.ParasiteCloud,
			[kTechDataCooldown] = kParasiteCloudCooldown,
            [kTechDataMapName] = ParasiteCloud.kMapName,
            [kTechDataDisplayName] = "PARASITE_CLOUD",
            [kTechDataCostKey] = kParasiteCloudCost,
            [kTechDataTooltipInfo] = "PARASITE_CLOUD_TOOLTIP",
            [kVisualRange] = ParasiteCloud.kRadius,
            [kTechDataGhostModelClass] = "AlienGhostModel",
            [kTechDataIgnorePathingMesh] = true,
            [kTechDataAllowStacking] = true,
            [kTechDataModel] = BoneWall.kModelName,
			[kTechDataButtonID] = 70
		})
	table.insert(newTechTable,
		{
            [kTechDataId] = kTechId.TeleportStructure,
            [kTechIDShowEnables] = false,
            [kTechDataGhostModelClass] = "TeleportAlienGhostModel",
            [kTechDataDisplayName] = "ECHO_STRUCTURE",
            [kTechDataTooltipInfo] = "ECHO_TOOLTIP",
            [kTechDataCollideWithWorldOnly] = true,
            [kTechDataIgnorePathingMesh] = true,
            [kTechDataAllowStacking] = true,
            [kTechDataModel] = BoneWall.kModelName,
            [kVisualRange] = 0.5,
            [kTechDataButtonID] = 40,
            [kCommanderSelectRadius] = 0.375,
            [kTechDataRequiresSecondPlacement] = true
        })
	table.insert(newTechTable, 
		{
            [kTechDataId] = kTechId.TeleportEmbryo,
            [kTechIDShowEnables] = false,
            [kTechDataGhostModelClass] = "TeleportAlienGhostModel",
            [kTechDataDisplayName] = "ECHO_EMBRYO",
            [kTechDataCostKey] = kEchoEmbryoCost,
            [kTechDataRequiresInfestation] = false,
            [kTechDataModel] = Egg.kModelName,
            [kTechDataTooltipInfo] = "ECHO_TOOLTIP",
            [kTechDataCollideWithWorldOnly] = true,
            [kTechDataImplemented] = false,
            [kTechDataRequiresSecondPlacement] = true
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
			[kTechDataId] = kTechId.NutrientMist,
			[kCommanderSelectRadius] = 0.375
		})
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TeleportHarvester,
            [kTechDataRequiresInfestation] = false,
            [kTechDataRequiresSecondPlacement] = true
        })
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TeleportHydra,
            [kTechDataRequiresSecondPlacement] = true
        })
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TeleportWhip,
            [kTechDataRequiresSecondPlacement] = true
        })
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TeleportTunnel,
            [kTechDataRequiresSecondPlacement] = true
        })
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TeleportCrag,
            [kTechDataRequiresSecondPlacement] = true
        })
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TeleportShade,
            [kTechDataRequiresSecondPlacement] = true
        })
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TeleportShift,
            [kTechDataRequiresSecondPlacement] = true
        })
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TeleportVeil,
            [kTechDataRequiresSecondPlacement] = true
        })
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TeleportSpur,
            [kTechDataRequiresSecondPlacement] = true
        })
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TeleportShell,
            [kTechDataRequiresSecondPlacement] = true
        })
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TeleportHive,
			[kTechDataImplemented] = true,
			[kTechDataMaxExtents] = Vector(2, 1, 2),
			[kTechDataCollideWithWorldOnly] = false,
            [kTechDataRequiresSecondPlacement] = true
        })
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.TeleportEgg,
            [kTechDataRequiresSecondPlacement] = true
        })
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Egg,
            [kTechDataRequiresInfestation] = false
        })
	table.insert(techIdUpdates,
		{
			[kTechDataId] = kTechId.Drifter,
			[kTechDataBuildTime] = kDrifterBuildTime,
			[kTechDataResearchTimeKey] = kDrifterBuildTime,
			[kTechDataCooldown] = kDrifterCooldown
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
            [kTechDataId] = kTechId.Carapace,
            [kTechDataCategory] = kTechId.DefensiveTraits
        })
	table.insert(techIdUpdates,
        {
            [kTechDataId] = kTechId.Regeneration,
            [kTechDataCategory] = kTechId.DefensiveTraits
        })
	table.insert(techIdUpdates,
        {
            [kTechDataId] = kTechId.Aura,
            [kTechDataCategory] = kTechId.OffensiveTraits
        })
	table.insert(techIdUpdates,
        {
            [kTechDataId] = kTechId.Celerity,
            [kTechDataCategory] = kTechId.MovementTraits
        })
	table.insert(techIdUpdates,
        {
            [kTechDataId] = kTechId.Adrenaline,
            [kTechDataCategory] = kTechId.MovementTraits
        })
	table.insert(techIdUpdates,
        {
            [kTechDataId] = kTechId.Crush,
            [kTechDataCategory] = kTechId.OffensiveTraits
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