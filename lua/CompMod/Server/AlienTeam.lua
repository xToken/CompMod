-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Server\AlienTeam.lua
-- - Dragon

-- Block spawning of cysts on round start
local function CreateNothing()
end

ReplaceLocals(AlienTeam.SpawnInitialStructures, { CreateCysts = CreateNothing })

local TrackedTechIds = { 	kTechId.Spur,
							kTechId.Shell,
							kTechId.Veil }

function AlienTeam:TrackEntity(techId)
	return table.contains(TrackedTechIds, techId)
end

function AlienTeam:InitTechTree()

    PlayingTeam.InitTechTree(self)

    -- Add special alien menus
    self.techTree:AddMenu(kTechId.MarkersMenu)
    self.techTree:AddMenu(kTechId.UpgradesMenu)
    self.techTree:AddMenu(kTechId.ShadePhantomMenu)
    self.techTree:AddMenu(kTechId.ShadePhantomStructuresMenu)
    self.techTree:AddMenu(kTechId.LifeFormMenu)
    self.techTree:AddMenu(kTechId.SkulkMenu)
    self.techTree:AddMenu(kTechId.GorgeMenu)
    self.techTree:AddMenu(kTechId.LerkMenu)
    self.techTree:AddMenu(kTechId.FadeMenu)
    self.techTree:AddMenu(kTechId.OnosMenu)
    self.techTree:AddMenu(kTechId.Return)
	
	-- Orders, passives, non tech type stuff
    self.techTree:AddOrder(kTechId.Grow)
    self.techTree:AddAction(kTechId.FollowAlien)
    self.techTree:AddPassive(kTechId.Infestation)
    self.techTree:AddPassive(kTechId.SpawnAlien)
    self.techTree:AddPassive(kTechId.CollectResources, 				kTechId.Harvester)
	self.techTree:AddPassive(kTechId.HiveHeal)
	
	-- Add markers (orders)
    self.techTree:AddSpecial(kTechId.ThreatMarker,					kTechId.None,					kTechId.None,					true)
    self.techTree:AddSpecial(kTechId.LargeThreatMarker,				kTechId.None,					kTechId.None,					true)
    self.techTree:AddSpecial(kTechId.NeedHealingMarker,				kTechId.None,					kTechId.None,					true)
    self.techTree:AddSpecial(kTechId.WeakMarker,					kTechId.None,					kTechId.None,					true)
    self.techTree:AddSpecial(kTechId.ExpandingMarker,				kTechId.None,					kTechId.None,					true)
	
	self.techTree:AddAction(kTechId.SelectDrifter)
    self.techTree:AddAction(kTechId.SelectHallucinations,			kTechId.Shade)
    self.techTree:AddAction(kTechId.SelectShift,					kTechId.Shift)
	
	self.techTree:AddMenu(kTechId.ShiftEcho,						kTechId.Shift)

    -- Commander abilities
    self.techTree:AddBuildNode(kTechId.NutrientMist)
    self.techTree:AddBuildNode(kTechId.Rupture,						kTechId.Hive)
    self.techTree:AddBuildNode(kTechId.BoneWall,					kTechId.Hive)
    self.techTree:AddBuildNode(kTechId.Contamination,				kTechId.ThreeHives)

    -- Drifter triggered abilities
    self.techTree:AddTargetedActivation(kTechId.EnzymeCloud,		kTechId.Shift,					kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.Hallucinate,		kTechId.Shade,					kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.MucousMembrane,		kTechId.Crag,					kTechId.None)
    self.techTree:AddActivation(kTechId.DestroyHallucination)

    -- Drifter passive abilities
    self.techTree:AddPassive(kTechId.DrifterCamouflage)
    self.techTree:AddPassive(kTechId.DrifterCelerity)
    self.techTree:AddPassive(kTechId.DrifterRegeneration)

    -- Hive
    self.techTree:AddBuildNode(kTechId.Hive,                    	kTechId.None,           		kTechId.None)
    self.techTree:AddSpecial(kTechId.TwoHives)
    self.techTree:AddSpecial(kTechId.ThreeHives)
	
    self.techTree:AddBuildNode(kTechId.Harvester)
    self.techTree:AddBuildNode(kTechId.DrifterEgg)
    self.techTree:AddBuildNode(kTechId.Drifter,						kTechId.None,					kTechId.None,					true)
	
	-- Whips
	self.techTree:AddBuildNode(kTechId.Whip,                      	kTechId.None,                	kTechId.None)
    self.techTree:AddUpgradeNode(kTechId.EvolveBombard,             kTechId.None,                	kTechId.None)    
	self.techTree:AddPassive(kTechId.WhipBombard)
    self.techTree:AddPassive(kTechId.Slap)
    self.techTree:AddActivation(kTechId.WhipUnroot)
    self.techTree:AddActivation(kTechId.WhipRoot)

    -- Tier 1 lifeforms
    self.techTree:AddAction(kTechId.Skulk,							kTechId.None,					kTechId.None)
    self.techTree:AddAction(kTechId.Gorge,							kTechId.None,					kTechId.None)
    self.techTree:AddAction(kTechId.Lerk,							kTechId.None,					kTechId.None)
    self.techTree:AddAction(kTechId.Fade,							kTechId.None,					kTechId.None)
    self.techTree:AddAction(kTechId.Onos,							kTechId.None,					kTechId.None)
    self.techTree:AddBuyNode(kTechId.Egg,							kTechId.None,					kTechId.None)
	
	-- Lifeform Eggs
    self.techTree:AddUpgradeNode(kTechId.GorgeEgg,					kTechId.ThreeHives)
    self.techTree:AddUpgradeNode(kTechId.LerkEgg,					kTechId.ThreeHives)
    self.techTree:AddUpgradeNode(kTechId.FadeEgg,					kTechId.ThreeHives)
    self.techTree:AddUpgradeNode(kTechId.OnosEgg,					kTechId.ThreeHives)

    -- Support Chambers
    self.techTree:AddBuildNode(kTechId.Crag,						kTechId.Hive,					kTechId.None)
    self.techTree:AddBuildNode(kTechId.Shift,						kTechId.Hive,					kTechId.None)
    self.techTree:AddBuildNode(kTechId.Shade,						kTechId.Hive,					kTechId.None)

    -- Alien upgrade structure
    self.techTree:AddBuildNode(kTechId.Shell,						kTechId.Crag, 					kTechId.None,					true)
    self.techTree:AddBuildNode(kTechId.TwoShells,					kTechId.TwoHives, 				kTechId.Crag,					true)
    self.techTree:AddBuildNode(kTechId.ThreeShells,					kTechId.ThreeHives, 			kTechId.Crag,					true)

    self.techTree:AddBuildNode(kTechId.Veil,						kTechId.Shade, 					kTechId.None,					true)
    self.techTree:AddBuildNode(kTechId.TwoVeils,					kTechId.TwoHives, 				kTechId.Shade,					true)
    self.techTree:AddBuildNode(kTechId.ThreeVeils,					kTechId.ThreeHives, 			kTechId.Shade,					true)

    self.techTree:AddBuildNode(kTechId.Spur,						kTechId.Shift, 					kTechId.None,					true)
    self.techTree:AddBuildNode(kTechId.TwoSpurs,					kTechId.TwoHives, 				kTechId.Shift,					true)
    self.techTree:AddBuildNode(kTechId.ThreeSpurs,					kTechId.ThreeHives, 			kTechId.Shift,					true)

    -- personal upgrades (all alien types)
    self.techTree:AddBuyNode(kTechId.Vampirism,						kTechId.Shell,					kTechId.None,					kTechId.AllAliens)
    self.techTree:AddBuyNode(kTechId.Carapace,						kTechId.Shell,					kTechId.None,					kTechId.AllAliens)
    self.techTree:AddBuyNode(kTechId.Regeneration,					kTechId.Shell,					kTechId.None,					kTechId.AllAliens)

    self.techTree:AddBuyNode(kTechId.Focus,							kTechId.Veil,					kTechId.None,					kTechId.AllAliens)
    self.techTree:AddBuyNode(kTechId.Aura,							kTechId.Veil,					kTechId.None,					kTechId.AllAliens)
    self.techTree:AddBuyNode(kTechId.Camouflage,					kTechId.Veil,					kTechId.None,					kTechId.AllAliens)

    self.techTree:AddBuyNode(kTechId.Crush,							kTechId.Spur,					kTechId.None,					kTechId.AllAliens)
    self.techTree:AddBuyNode(kTechId.Celerity,						kTechId.Spur,					kTechId.None,					kTechId.AllAliens)
    self.techTree:AddBuyNode(kTechId.Adrenaline,					kTechId.Spur,					kTechId.None,					kTechId.AllAliens)

    -- Crag
    self.techTree:AddPassive(kTechId.CragHeal)
    self.techTree:AddActivation(kTechId.HealWave,					kTechId.Crag,					kTechId.None)

    -- Shift
    self.techTree:AddActivation(kTechId.ShiftHatch,					kTechId.None,					kTechId.None)
    self.techTree:AddActivation(kTechId.ShiftEnergize,				kTechId.Shift,					kTechId.None)

    self.techTree:AddTargetedActivation(kTechId.TeleportHydra,		kTechId.Shift,					kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportWhip,		kTechId.Shift,					kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportTunnel,		kTechId.Shift,					kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportCrag,		kTechId.Shift,					kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportShade,		kTechId.Shift,					kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportShift,		kTechId.Shift,					kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportVeil,		kTechId.Shift,					kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportSpur,		kTechId.Shift,					kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportShell,		kTechId.Shift,					kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportHive,		kTechId.Shift,					kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportEgg,		kTechId.Shift,					kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportHarvester,	kTechId.Shift,					kTechId.None)

    -- Shade
    self.techTree:AddPassive(kTechId.ShadeDisorient)
    self.techTree:AddPassive(kTechId.ShadeCloak)
    self.techTree:AddActivation(kTechId.ShadeInk,					kTechId.Shade,					kTechId.None)

    -- skulk researches
	--self.techTree:AddResearchNode(kTechId.Something,				kTechId.Hive,					kTechId.None,					kTechId.AllAliens) -- Early game skulk upg?
    self.techTree:AddResearchNode(kTechId.Leap,						kTechId.TwoHives,				kTechId.None,					kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.Xenocide,					kTechId.ThreeHives,				kTechId.None,					kTechId.AllAliens)

    -- gorge researches
	self.techTree:AddResearchNode(kTechId.GorgeTunnelTech,			kTechId.Hive,					kTechId.None,					kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.BileBomb,					kTechId.TwoHives,				kTechId.None,					kTechId.AllAliens)
	--self.techTree:AddResearchNode(kTechId.Something,				kTechId.ThreeHives,				kTechId.None,					kTechId.AllAliens) -- Need third hive abil
	
	-- Gorge abilities
	self.techTree:AddBuyNode(kTechId.Web,							kTechId.None)
    self.techTree:AddBuyNode(kTechId.BabblerAbility,				kTechId.None)
    self.techTree:AddBuyNode(kTechId.BabblerEgg,					kTechId.None)
	
	self.techTree:AddBuildNode(kTechId.GorgeTunnel,					kTechId.GorgeTunnelTech)
    self.techTree:AddBuildNode(kTechId.Hydra)
    self.techTree:AddBuildNode(kTechId.Clog)

    -- lerk researches
	--self.techTree:AddResearchNode(kTechId.Spikes,					kTechId.Hive,					kTechId.None,					kTechId.AllAliens)	-- Need something here too
    self.techTree:AddResearchNode(kTechId.Umbra,					kTechId.TwoHives,				kTechId.None,					kTechId.AllAliens)
	self.techTree:AddResearchNode(kTechId.Spores,					kTechId.ThreeHives,				kTechId.None,					kTechId.AllAliens)

    -- fade researches
    self.techTree:AddResearchNode(kTechId.MetabolizeEnergy,			kTechId.Hive,					kTechId.None,					kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.MetabolizeHealth,			kTechId.TwoHives,				kTechId.MetabolizeEnergy,		kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.Stab,						kTechId.ThreeHives,				kTechId.None,					kTechId.AllAliens)

    -- onos researches
    self.techTree:AddResearchNode(kTechId.Charge,					kTechId.Hive,					kTechId.None,					kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.BoneShield,				kTechId.TwoHives,				kTechId.None,					kTechId.AllAliens)
	self.techTree:AddResearchNode(kTechId.Stomp,					kTechId.ThreeHives,				kTechId.None,					kTechId.AllAliens)

    self.techTree:SetComplete()

end