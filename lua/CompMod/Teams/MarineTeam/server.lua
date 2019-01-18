-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Teams\MarineTeam\server.lua
-- - Dragon

function MarineTeam:InitTechTree()
   
   PlayingTeam.InitTechTree(self)
   
   -- Passives, other utility things
    self.techTree:AddPassive(kTechId.Welding)
    self.techTree:AddPassive(kTechId.SpawnMarine)
    self.techTree:AddPassive(kTechId.CollectResources,				kTechId.Extractor)
    self.techTree:AddPassive(kTechId.Detector)
    
    self.techTree:AddSpecial(kTechId.TwoCommandStations)
    self.techTree:AddSpecial(kTechId.ThreeCommandStations)
	
	self.techTree:AddOrder(kTechId.Defend)
    self.techTree:AddOrder(kTechId.FollowAndWeld)
	
	self.techTree:AddActivation(kTechId.ARCDeploy)
    self.techTree:AddActivation(kTechId.ARCUndeploy)
	
	self.techTree:AddAction(kTechId.SelectObservatory)
	
	self.techTree:AddBuildNode(kTechId.PowerNode,					kTechId.None,					kTechId.None)
	
	-- Door actions
    self.techTree:AddBuildNode(kTechId.Door,						kTechId.None,					kTechId.None)
    self.techTree:AddActivation(kTechId.DoorOpen)
    self.techTree:AddActivation(kTechId.DoorClose)
    self.techTree:AddActivation(kTechId.DoorLock)
    self.techTree:AddActivation(kTechId.DoorUnlock)
	
	-- Menus?
    self.techTree:AddMenu(kTechId.RoboticsFactoryARCUpgradesMenu)
    self.techTree:AddMenu(kTechId.RoboticsFactoryMACUpgradesMenu)
    
    self.techTree:AddMenu(kTechId.WeaponsMenu)
	
    -- Count recycle like an upgrade so we can have multiples
    self.techTree:AddUpgradeNode(kTechId.Recycle,					kTechId.None,					kTechId.None)
    
    -- Base structures
	self.techTree:AddBuildNode(kTechId.CommandStation,				kTechId.None,					kTechId.None)
    self.techTree:AddBuildNode(kTechId.Extractor,					kTechId.CommandStation,			kTechId.None)
    self.techTree:AddBuildNode(kTechId.InfantryPortal,				kTechId.CommandStation,			kTechId.None)
	self.techTree:AddBuildNode(kTechId.Armory,						kTechId.CommandStation,			kTechId.None)
    self.techTree:AddBuildNode(kTechId.ArmsLab,						kTechId.CommandStation,			kTechId.None)
	self.techTree:AddBuildNode(kTechId.RoboticsFactory,				kTechId.CommandStation,			kTechId.None)
	
	-- Adv structures
	self.techTree:AddBuildNode(kTechId.Sentry,						kTechId.RoboticsFactory,		kTechId.None, 				true)
	self.techTree:AddBuildNode(kTechId.SentryBattery,				kTechId.RoboticsFactory,		kTechId.None)
	self.techTree:AddBuildNode(kTechId.PhaseGate,					kTechId.PhaseTech,				kTechId.None, 				true)
    self.techTree:AddBuildNode(kTechId.Observatory,					kTechId.InfantryPortal,			kTechId.None)
	self.techTree:AddBuildNode(kTechId.PrototypeLab,				kTechId.AdvancedArmory,			kTechId.None)
	
	-- Commander Support
	self.techTree:AddTargetedActivation(kTechId.Scan,				kTechId.Observatory)
    self.techTree:AddTargetedActivation(kTechId.MedPack,			kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.AmmoPack,			kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.CatPack,			kTechId.AdvancedArmory)
	
	-- Weapons T1
    self.techTree:AddBuyNode(kTechId.Axe,                         	kTechId.None,					kTechId.None)
    self.techTree:AddBuyNode(kTechId.Pistol,                      	kTechId.None,					kTechId.None)
    self.techTree:AddBuyNode(kTechId.Rifle,                       	kTechId.None,					kTechId.None)
	
	-- Weapons T1.5
	self.techTree:AddTargetedBuyNode(kTechId.Flamethrower,			kTechId.Armory)
	
	-- Weapons T2
	self.techTree:AddTargetedBuyNode(kTechId.HeavyMachineGun,		kTechId.Armory)
	self.techTree:AddTargetedBuyNode(kTechId.GrenadeLauncher,		kTechId.Armory)
	self.techTree:AddTargetedBuyNode(kTechId.Shotgun,				kTechId.Armory)
	
	-- Weapons T2.5
	self.techTree:AddBuyNode(kTechId.DualMinigunExosuit,			kTechId.RoboticsFactory)
    self.techTree:AddBuyNode(kTechId.DualRailgunExosuit,			kTechId.RoboticsFactory)
	
	-- Equipment T1
	self.techTree:AddResearchNode(kTechId.GrenadeTech,				kTechId.Armory,					kTechId.None)
	self.techTree:AddResearchNode(kTechId.MinesTech,            	kTechId.Armory,					kTechId.None)
	self.techTree:AddTargetedBuyNode(kTechId.ClusterGrenade,		kTechId.GrenadeTech)
    self.techTree:AddTargetedBuyNode(kTechId.GasGrenade,			kTechId.GrenadeTech)
    self.techTree:AddTargetedBuyNode(kTechId.PulseGrenade,			kTechId.GrenadeTech)
	self.techTree:AddTargetedBuyNode(kTechId.LayMines,				kTechId.MinesTech)
	self.techTree:AddTargetedBuyNode(kTechId.Welder,				kTechId.Armory)
	
	-- Equipment T3
	self.techTree:AddBuyNode(kTechId.Jetpack,						kTechId.JetpackTech)

    -- Armory upgrades
	-- This is the armory upgrade research
    self.techTree:AddUpgradeNode(kTechId.AdvancedArmoryUpgrade,		kTechId.Armory)
	-- This is the advanced armory itself
	self.techTree:AddBuildNode(kTechId.AdvancedArmory,				kTechId.Armory,					kTechId.None)
	self.techTree:AddResearchNode(kTechId.FlamethrowerUpgrade1,		kTechId.Armory)
	self.techTree:AddResearchNode(kTechId.ShotgunUpgrade1,			kTechId.Armory)
	self.techTree:AddResearchNode(kTechId.ShotgunUpgrade2,			kTechId.AdvancedArmory)
	self.techTree:AddResearchNode(kTechId.MGUpgrade1,				kTechId.Armory)
	self.techTree:AddResearchNode(kTechId.MGUpgrade2,				kTechId.AdvancedArmory)
    self.techTree:AddResearchNode(kTechId.GLUpgrade1,				kTechId.AdvancedArmory)
	self.techTree:AddResearchNode(kTechId.MinigunUpgrade1,			kTechId.AdvancedArmory)
	self.techTree:AddResearchNode(kTechId.MinigunUpgrade2,			kTechId.AdvancedArmory)
    self.techTree:AddResearchNode(kTechId.RailgunUpgrade1,			kTechId.AdvancedArmory)
	self.techTree:AddTechInheritance(kTechId.Armory, 				kTechId.AdvancedArmory)
	
	-- ArmsLab Techs
	self.techTree:AddResearchNode(kTechId.Weapons1,					kTechId.ArmsLab,				kTechId.None)
    self.techTree:AddResearchNode(kTechId.Weapons2,					kTechId.AdvancedArmory,			kTechId.Weapons1)
    self.techTree:AddResearchNode(kTechId.Weapons3,					kTechId.PrototypeLab,			kTechId.Weapons2)
	self.techTree:AddResearchNode(kTechId.Armor1,					kTechId.ArmsLab,				kTechId.None)
    self.techTree:AddResearchNode(kTechId.Armor2,					kTechId.AdvancedArmory,			kTechId.Armor1)
    self.techTree:AddResearchNode(kTechId.Armor3,					kTechId.PrototypeLab,			kTechId.Armor2)
	
    -- Observatory Upgrades
    self.techTree:AddResearchNode(kTechId.PhaseTech,				kTechId.Observatory,			kTechId.None)
    self.techTree:AddActivation(kTechId.DistressBeacon,				kTechId.Observatory)
	
	-- Prototype Lab Upgrades
	self.techTree:AddResearchNode(kTechId.JetpackTech,           	kTechId.PrototypeLab)
	self.techTree:AddResearchNode(kTechId.JetpackUpgrade1,			kTechId.JetpackTech)
    self.techTree:AddResearchNode(kTechId.ExoUpgrade1,				kTechId.PrototypeLab)
	self.techTree:AddResearchNode(kTechId.ExoUpgrade2,				kTechId.PrototypeLab)
	self.techTree:AddResearchNode(kTechId.NanoArmor,				kTechId.PrototypeLab)
    
	-- This is the research to upgrade the ARC factory
	self.techTree:AddUpgradeNode(kTechId.UpgradeRoboticsFactory,	kTechId.Armory,					kTechId.RoboticsFactory)
	-- This is the upgraded ARC factory itself.
    self.techTree:AddBuildNode(kTechId.ARCRoboticsFactory,			kTechId.Armory,					kTechId.RoboticsFactory)
	self.techTree:AddResearchNode(kTechId.SentryUpgrade1,			kTechId.AdvancedArmory)
	self.techTree:AddResearchNode(kTechId.ARCUpgrade1,				kTechId.RoboticsFactory)
	self.techTree:AddResearchNode(kTechId.ARCUpgrade2,				kTechId.ARCRoboticsFactory,		kTechId.ARCUpgrade1)
	-- Dunno what this does
    self.techTree:AddTechInheritance(kTechId.RoboticsFactory, 		kTechId.ARCRoboticsFactory)
	
	-- RoboFactory Products
    self.techTree:AddManufactureNode(kTechId.ARC,					kTechId.ARCRoboticsFactory,     kTechId.None,				true)        
    self.techTree:AddManufactureNode(kTechId.MAC,					kTechId.RoboticsFactory,		kTechId.None,				true)
	
	-- Comm Drops
	--self.techTree:AddResearchNode(kTechId.CatPackTech, 				kTechId.PrototypeLab)
    self.techTree:AddTargetedActivation(kTechId.DropShotgun,		kTechId.PrototypeLab)
    self.techTree:AddTargetedActivation(kTechId.DropHeavyMachineGun,kTechId.PrototypeLab)
    self.techTree:AddTargetedActivation(kTechId.DropGrenadeLauncher,kTechId.PrototypeLab)
    self.techTree:AddTargetedActivation(kTechId.DropFlamethrower,	kTechId.AdvancedArmory)
    self.techTree:AddTargetedActivation(kTechId.DropMines,			kTechId.AdvancedArmory)
    self.techTree:AddTargetedActivation(kTechId.DropWelder,			kTechId.Armory)
    self.techTree:AddTargetedActivation(kTechId.DropJetpack,		kTechId.PrototypeLab)
    
    self.techTree:SetComplete()

end