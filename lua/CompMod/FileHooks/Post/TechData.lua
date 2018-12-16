-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\FileHooks\Post\TechData.lua
-- - Dragon

-- This file contains all the updated tech data.  In mostly one place to make my life easier!
kTechDataIDName = "techdataidname"
kTechDataButtonID = "techdatabuttonid"

local techDataUpdatesBuilt = false
local techIdUpdates = { }
local newTechTable = { }

-- Take all the updated tech IDs kTechData keys, insert into single table for easy checking
local techIdUpdatedKeys = { }
local techIdUpdatedFields = { } -- LUA tables make me sad sometimes

local function BuildTechDataUpdates()
	if not techDataUpdatesBuilt then
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
				[kTechDataId] = kTechId.WeaponsArmsLab,
				[kTechDataCostKey] = kArmsLabCost + kWeapons2ResearchCost,
				[kTechDataRequiresPower] = true,
				[kTechIDShowEnables] = false,
				[kTechDataMapName] = WeaponsArmsLab.kMapName,
				[kTechDataModel] = ArmsLab.kModelName,
				[kTechDataBuildTime] = kArmsLabBuildTime,
				[kTechDataMaxHealth] = kArmsLabHealth,
				[kTechDataMaxArmor] = kArmsLabArmor,
				[kTechDataEngagementDistance] = kArmsLabEngagementDistance,
				[kTechDataNotOnInfestation] = kPreventMarineStructuresOnInfestation,
				[kTechDataHint] = "WEAPONS_ARMSLAB_HINT",
				[kTechDataDisplayName] = "WEAPONS_ARMS_LAB",
				[kTechDataTooltipInfo] = "WEAPONS_ARMS_LAB_TOOLTIP",
				[kTechDataObstacleRadius] = 0.25,
				[kTechDataButtonID] = 86
			})
		table.insert(newTechTable,
			{
				[kTechDataId] = kTechId.ArmorArmsLab,
				[kTechDataCostKey] = kArmsLabCost + kArmor2ResearchCost,
				[kTechDataRequiresPower] = true,
				[kTechIDShowEnables] = false,
				[kTechDataMapName] = ArmorArmsLab.kMapName,
				[kTechDataModel] = ArmsLab.kModelName,
				[kTechDataBuildTime] = kArmsLabBuildTime,
				[kTechDataMaxHealth] = kArmsLabHealth,
				[kTechDataMaxArmor] = kArmsLabArmor,
				[kTechDataEngagementDistance] = kArmsLabEngagementDistance,
				[kTechDataNotOnInfestation] = kPreventMarineStructuresOnInfestation,
				[kTechDataHint] = "ARMOR_ARMSLAB_HINT",
				[kTechDataDisplayName] = "ARMOR_ARMS_LAB",
				[kTechDataTooltipInfo] = "ARMOR_ARMS_LAB_TOOLTIP",
				[kTechDataObstacleRadius] = 0.25,
				[kTechDataButtonID] = 86
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

		for i = 1, #techIdUpdates do
			table.insert(techIdUpdatedKeys, techIdUpdates[i][kTechDataId])
			techIdUpdatedFields[techIdUpdates[i][kTechDataId]] = techIdUpdates[i]
			-- Clear tech ID field from key updates
			techIdUpdatedFields[techIdUpdates[i][kTechDataId]][kTechDataId] = nil
		end
		techDataUpdatesBuilt = true
	end
end
			
function ReturnNewTechButtons()
	BuildTechDataUpdates()
	local tButtons = { }
	for i = 1, #newTechTable do
		tButtons[newTechTable[i][kTechDataId]] = newTechTable[i][kTechDataButtonID]
	end
	return tButtons
end

function IsTechIDUpdated(techId)
	return table.contains(techIdUpdatedKeys, techId)
end

function ReturnUpdatedTechData(techId)
	return techIdUpdatedFields[techId]
end

local function AddCompModTechChanges(techData)
	BuildTechDataUpdates()
	for _, record in ipairs(techData) do
		-- Update any existing techIDs
        if IsTechIDUpdated(record[kTechDataId]) then
			for k, v in pairs(ReturnUpdatedTechData(record[kTechDataId])) do
				record[k] = v
			end
		end
    end
	-- Add new tech IDs
	for _, techTable in ipairs(newTechTable) do
		table.insert(techData, techTable)
	end
end

-- You dumbass, the BuildTechData is global...
local oldBuildTechData = BuildTechData
function BuildTechData()
	local techData = oldBuildTechData()
	AddCompModTechChanges(techData)
	return techData
end