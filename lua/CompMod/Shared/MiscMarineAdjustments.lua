// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\MiscMarineAdjustments.lua
// - Dragon

TeamInfo.kRelevantTechIdsMarine =
{

    kTechId.ShotgunTech,
	kTechId.FlamethrowerTech,
    kTechId.MinesTech,
    kTechId.WelderTech,
    kTechId.GrenadeTech,
    
    kTechId.AdvancedArmory,
    kTechId.AdvancedArmoryUpgrade,
    kTechId.HeavyMachineGunTech,
	kTechId.GrenadeLauncherTech,

    kTechId.Weapons1,
    kTechId.Weapons2,
    kTechId.Weapons3,
    kTechId.Armor1,
    kTechId.Armor2,
    kTechId.Armor3,

    kTechId.PrototypeLab,
    kTechId.JetpackTech,
    kTechId.ExosuitTech,

    kTechId.ARCRoboticsFactory,
    kTechId.UpgradeRoboticsFactory,
    kTechId.MACEMPTech,
    kTechId.MACSpeedTech,
    
    kTechId.Observatory,
    kTechId.PhaseTech,
    
    kTechId.CatPackTech,
    kTechId.NanoShieldTech,
    
}

Shared.LinkClassToMap("Minigun", Minigun.kMapName, { heatAmount = "float (0 to 1 by 0.001)" })