// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Server\PlayingTeamAdjustments.lua
// - Dragon

local relevantResearchIds = nil
local function GetIsResearchRelevant(techId)

    if not relevantResearchIds then
    
        relevantResearchIds = {}
        relevantResearchIds[kTechId.ShotgunTech] = 2
        relevantResearchIds[kTechId.GrenadeLauncherTech] = 2
        relevantResearchIds[kTechId.AdvancedWeaponry] = 2
        relevantResearchIds[kTechId.FlamethrowerTech] = 2
		relevantResearchIds[kTechId.HeavyMachineGunTech] = 2
        relevantResearchIds[kTechId.WelderTech] = 2
        relevantResearchIds[kTechId.GrenadeTech] = 2
        relevantResearchIds[kTechId.MinesTech] = 2
        relevantResearchIds[kTechId.ShotgunTech] = 2
        relevantResearchIds[kTechId.ExosuitTech] = 3
        relevantResearchIds[kTechId.JetpackTech] = 3
        relevantResearchIds[kTechId.DualMinigunTech] = 3
        relevantResearchIds[kTechId.ClawRailgunTech] = 3
        relevantResearchIds[kTechId.DualRailgunTech] = 3
        
        relevantResearchIds[kTechId.DetonationTimeTech] = 2
        relevantResearchIds[kTechId.FlamethrowerRangeTech] = 2
        
        relevantResearchIds[kTechId.Armor1] = 1
        relevantResearchIds[kTechId.Armor2] = 1
        relevantResearchIds[kTechId.Armor3] = 1
        
        relevantResearchIds[kTechId.Weapons1] = 1
        relevantResearchIds[kTechId.Weapons2] = 1
        relevantResearchIds[kTechId.Weapons3] = 1
        
        relevantResearchIds[kTechId.BabblerTech] = 1
		relevantResearchIds[kTechId.MetabolizeEnergy] = 1
		relevantResearchIds[kTechId.Charge] = 1
		relevantResearchIds[kTechId.BileBomb] = 1
		
        relevantResearchIds[kTechId.Leap] = 1
        relevantResearchIds[kTechId.Umbra] = 1
        relevantResearchIds[kTechId.MetabolizeHealth] = 1
		relevantResearchIds[kTechId.BoneShield] = 1
		relevantResearchIds[kTechId.Spores] = 1
        
        relevantResearchIds[kTechId.Stab] = 1
        relevantResearchIds[kTechId.WebTech] = 1
        relevantResearchIds[kTechId.Stomp] = 1
		relevantResearchIds[kTechId.Xenocide] = 1
    
    end
    
    return relevantResearchIds[techId]

end

ReplaceLocals(PlayingTeam.OnResearchComplete, { GetIsResearchRelevant = GetIsResearchRelevant })