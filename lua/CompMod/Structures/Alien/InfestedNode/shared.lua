-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\InfestedNode\shared.lua
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

class 'InfestedNode' (ScriptActor)

InfestedNode.kMapName = "infestednode"

local kInfestedNodeScale = 1.5

InfestedNode.kModelName = PrecacheAsset("models/alien/cyst/cyst.model")
InfestedNode.kAnimationGraph = PrecacheAsset("models/alien/cyst/cyst.animation_graph")

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

function InfestedNode:OnCreate()

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

function InfestedNode:OnInitialized()

    ScriptActor.OnInitialized(self)
    
    if Server then

        self:SetModel(InfestedNode.kModelName, InfestedNode.kAnimationGraph)

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

function InfestedNode:GetReceivesStructuralDamage()
    return true
end

function InfestedNode:GetCanSleep()
    return true
end

function InfestedNode:GetIsSocketed()
    return false
end

function InfestedNode:OnConstructionComplete()

    local attachedPowerPoint = self:GetAttached()
    if attachedPowerPoint then
        attachedPowerPoint:InfestPowerNode()
    end
    local team = self:GetTeam()
    if team then
        team:UpdateNumCapturedPowerPoints()
    end
end

function InfestedNode:CustomAttach(structure)
    local angles = structure:GetAngles()
    angles.pitch = angles.pitch + math.pi/2
    --local coords = Angles(3 * math.pi / 2, 0, 0):GetCoords()
    local coords = angles:GetCoords()
    coords.origin = structure:GetOrigin() - GetNormalizedVector(structure:GetCoords().zAxis) * 0.25
    coords.origin.y = coords.origin.y + 0.1
    self:SetCoords(coords)
end

function InfestedNode:OnAdjustModelCoords(modelCoords)
    modelCoords.xAxis = modelCoords.xAxis * kInfestedNodeScale
    modelCoords.yAxis = modelCoords.yAxis * kInfestedNodeScale
    modelCoords.zAxis = modelCoords.zAxis * kInfestedNodeScale
    return modelCoords
end

function InfestedNode:OnKill()

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

function InfestedNode:OnGetMapBlipInfo()
    return true, kMinimapBlipType.PowerPoint, self:GetTeamNumber(), self:GetIsInCombat()
end

function InfestedNode:GetEngagementPointOverride()
    return self:GetOrigin() + Vector(0, 0.8, 0)
end

Shared.LinkClassToMap("InfestedNode", InfestedNode.kMapName, networkVars, true)