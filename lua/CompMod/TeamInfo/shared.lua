-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\TeamInfo\shared.lua
-- - Dragon

local originalTeamInfoOnCreate
originalTeamInfoOnCreate = Class_ReplaceMethod("TeamInfo", "OnCreate",
    function(self)
        originalTeamInfoOnCreate(self)
        self.numCapturedPowerPoints = 0
    end
)

-- Just Override these, we change too much here anyways
TeamInfo.kRelevantTechIdsMarine =
{
    
    kTechId.AdvancedArmory,
    kTechId.AdvancedArmoryUpgrade,
	
	kTechId.FlamethrowerUpgrade1,
	kTechId.ShotgunUpgrade1,
	kTechId.ShotgunUpgrade2,
	kTechId.MGUpgrade1,
	kTechId.MGUpgrade2,
    kTechId.GLUpgrade1,
	kTechId.MinigunUpgrade1,
	kTechId.MinigunUpgrade2,
    kTechId.RailgunUpgrade1,

    kTechId.Weapons1,
    kTechId.Weapons2,
    kTechId.Weapons3,
    kTechId.Armor1,
    kTechId.Armor2,
    kTechId.Armor3,

    kTechId.PrototypeLab,
	
	kTechId.JetpackUpgrade1,
    kTechId.ExoUpgrade1,
	kTechId.ExoUpgrade2,
	kTechId.NanoArmor,

    kTechId.ARCRoboticsFactory,
    kTechId.UpgradeRoboticsFactory,
	kTechId.SentryUpgrade1,
	kTechId.ARCUpgrade1,
	kTechId.ARCUpgrade2,
    
    kTechId.Observatory,
    kTechId.PhaseTech,
    
    kTechId.AdvancedMarineSupport,

}

TeamInfo.kRelevantTechIdsAlien =
{
    
    kTechId.Shell,
    kTechId.TwoShells,
    kTechId.ThreeShells,
    
    kTechId.Veil,
    kTechId.TwoVeils,
    kTechId.ThreeVeils,
	
    kTechId.Spur,
    kTechId.TwoSpurs,
    kTechId.ThreeSpurs,
 
    kTechId.Leap,
    kTechId.Xenocide,
    kTechId.GorgeTunnelTech,
    kTechId.BileBomb,
    kTechId.HealingRoost,
    kTechId.Umbra,
    kTechId.Spores,
    kTechId.MetabolizeEnergy,
    kTechId.MetabolizeHealth,
    kTechId.Stab,
    kTechId.Charge,
    kTechId.BoneShield,
    kTechId.Stomp,
	
	kTechId.TwoHives,
    kTechId.ThreeHives,

    kTechId.OffensiveTraits,
    kTechId.DefensiveTraits,
    kTechId.MovementTraits,
    kTechId.AdditionalTraitSlot1,
    kTechId.AdditionalTraitSlot2,
    
}

function TeamInfo:GetNumCapturedPowerPoints()
    return self.numCapturedPowerPoints
end

local originalTeamInfoOnUpdate
originalTeamInfoOnUpdate = Class_ReplaceMethod("TeamInfo", "OnUpdate",
    function(self, deltaTime)
        originalTeamInfoOnUpdate(self, deltaTime)
        if self.team and Server then
            self.numCapturedPowerPoints = self.team:GetNumCapturedPowerPoints()
        end
    end
)

Shared.LinkClassToMap("TeamInfo", TeamInfo.kMapName, {numCapturedPowerPoints = "integer (0 to 99)"})