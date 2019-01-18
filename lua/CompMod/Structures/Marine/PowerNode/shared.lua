-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Marine\PowerNode\shared.lua
-- - Dragon

Script.Load("lua/Mixins/ModelMixin.lua")
Script.Load("lua/LiveMixin.lua")
Script.Load("lua/PointGiverMixin.lua")
Script.Load("lua/AchievementGiverMixin.lua")
Script.Load("lua/GameEffectsMixin.lua")
Script.Load("lua/SelectableMixin.lua")
Script.Load("lua/FlinchMixin.lua")
Script.Load("lua/LOSMixin.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/EntityChangeMixin.lua")
Script.Load("lua/ConstructMixin.lua")
Script.Load("lua/ScriptActor.lua")
Script.Load("lua/RagdollMixin.lua")
Script.Load("lua/SleeperMixin.lua")
Script.Load("lua/ObstacleMixin.lua")
Script.Load("lua/CombatMixin.lua")
Script.Load("lua/SpawnBlockMixin.lua")

class 'PowerNode' (ScriptActor)

PowerNode.kMapName = "powernode"

PowerNode.kModelName = PrecacheAsset("models/system/editor/power_node.model")
PowerNode.kAnimationGraph = PrecacheAsset("models/system/editor/power_node.animation_graph")

local networkVars = {
    attachedId = "entityid",
}

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ClientModelMixin, networkVars)
AddMixinNetworkVars(LiveMixin, networkVars)
AddMixinNetworkVars(GameEffectsMixin, networkVars)
AddMixinNetworkVars(FlinchMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)
AddMixinNetworkVars(LOSMixin, networkVars)
AddMixinNetworkVars(ConstructMixin, networkVars)
AddMixinNetworkVars(ObstacleMixin, networkVars)
AddMixinNetworkVars(CombatMixin, networkVars)
AddMixinNetworkVars(SelectableMixin, networkVars)

function PowerNode:OnCreate()

    ScriptActor.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ClientModelMixin)
    InitMixin(self, LiveMixin)
    InitMixin(self, GameEffectsMixin)
    InitMixin(self, FlinchMixin, { kPlayFlinchAnimations = true })
    InitMixin(self, TeamMixin)
    InitMixin(self, PointGiverMixin)
    InitMixin(self, AchievementGiverMixin)
    InitMixin(self, SelectableMixin)
    InitMixin(self, EntityChangeMixin)
    InitMixin(self, LOSMixin)
    InitMixin(self, ConstructMixin)
    InitMixin(self, RagdollMixin)
    InitMixin(self, ObstacleMixin)
    InitMixin(self, CombatMixin)
    
    if Server then
        InitMixin(self, SpawnBlockMixin)
    end
    
    self:SetLagCompensated(true)
    self:SetPhysicsType(PhysicsType.Kinematic)
    self:SetPhysicsGroup(PhysicsGroup.BigStructuresGroup)
    
end

function PowerNode:OnInitialized()

    ScriptActor.OnInitialized(self)
    
    if Server then

        self:SetModel(PowerNode.kModelName, PowerNode.kAnimationGraph)

        InitMixin(self, SleeperMixin)
        InitMixin(self, StaticTargetMixin)

        if not HasMixin(self, "MapBlip") then
            InitMixin(self, MapBlipMixin)
        end
        
    end

    if Client then
        InitMixin(self, UnitStatusMixin)
    end
    
end

function PowerNode:GetReceivesStructuralDamage()
    return true
end

function PowerNode:GetCanSleep()
    return true
end

function PowerNode:GetIsSocketed()
    return true
end

function PowerNode:OnConstructionComplete()

    local attachedPowerPoint = self:GetAttached()
    if attachedPowerPoint then
        attachedPowerPoint:SocketPowerNode()
    end
    local team = self:GetTeam()
    if team then
        team:UpdateNumCapturedPowerPoints()
    end

    self:TriggerEffects("fixed_power_up")

end

function PowerNode:OnKill()

    local attachedPowerPoint = self:GetAttached()
    if attachedPowerPoint then
        attachedPowerPoint:ClearAttachedNode()
    end

    ScriptActor.OnKill(self)

    local team = self:GetTeam()
    if team then
        team:UpdateNumCapturedPowerPoints()
    end

end

function PowerNode:GetEngagementPointOverride()
    return self:GetOrigin() + Vector(0, 0.8, 0)
end

function PowerNode:OnGetMapBlipInfo()
    return true, kMinimapBlipType.PowerPoint, self:GetTeamNumber(), self:GetIsInCombat()
end

function PowerNode:OnUpdatePoseParameters()
    self:SetPoseParam("build", self:GetBuiltFraction() * 100)
end

Shared.LinkClassToMap("PowerNode", PowerNode.kMapName, networkVars, true)