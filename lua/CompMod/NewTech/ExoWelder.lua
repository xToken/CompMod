//
// lua\ExoWelder.lua
//

Script.Load("lua/DamageMixin.lua")
Script.Load("lua/Weapons/Marine/ExoWeaponSlotMixin.lua")
Script.Load("lua/TechMixin.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/EffectsMixin.lua")

class 'ExoWelder' (Entity)

ExoWelder.kMapName = "exowelder"

//ExoWelder.kModelName = PrecacheAsset("models/marine/welder/welder.model")
//local kAnimationGraph = PrecacheAsset("models/marine/welder/welder_view.animation_graph")

local networkVars =
{
    welding = "private boolean",
	loopingSoundEntId = "entityid"
}

local kWelderTraceExtents = Vector(0.4, 0.4, 0.4)
local kWeldRange = 2.4
local kWelderEffectRate = 0.45
local kFireLoopingSound = PrecacheAsset("sound/NS2.fev/marine/welder/weld")
local kHealScoreAdded = 2
local kAmountHealedForPoints = 600

AddMixinNetworkVars(TechMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)
AddMixinNetworkVars(ExoWeaponSlotMixin, networkVars)

function ExoWelder:OnCreate()

    Entity.OnCreate(self)
    
    InitMixin(self, TechMixin)
    InitMixin(self, TeamMixin)
    InitMixin(self, DamageMixin)
    InitMixin(self, ExoWeaponSlotMixin)
	InitMixin(self, EffectsMixin)
    
    self.welding = false
	
	self.loopingSoundEntId = Entity.invalidId
    
    if Server then
    
        self.loopingFireSound = Server.CreateEntity(SoundEffect.kMapName)
        self.loopingFireSound:SetAsset(kFireLoopingSound)
        // SoundEffect will automatically be destroyed when the parent is destroyed (the Welder).
        self.loopingFireSound:SetParent(self)
        self.loopingSoundEntId = self.loopingFireSound:GetId()
        
    end
    
end

function ExoWelder:OnInitialized()

    Entity.OnInitialized(self)
    
    self.timeWeldStarted = 0
    self.timeLastWeld = 0

	
end

function ExoWelder:GetViewModelName(sex, variant)
    return ExoWelder.kModelName
end

function ExoWelder:GetAnimationGraphName()
    return kAnimationGraph
end

function ExoWelder:GetMeleeBase()
    return 2, 2
end

function ExoWelder:GetMeleeOffset()
    return 0.0
end

function ExoWelder:GetRange()
    return kWeldRange
end

function ExoWelder:OnHolster(player)

    Weapon.OnHolster(self, player)
    
    self.welding = false
    // cancel muzzle effect
    self:TriggerEffects("welder_holster")
    
end

function ExoWelder:OnDraw(player, previousWeaponMapName)

    Weapon.OnDraw(self, player, previousWeaponMapName)
    
    self:SetAttachPoint(Weapon.kHumanAttachPoint)
    self.welding = false
    
end

function ExoWelder:GetIsAffectedByWeaponUpgrades()
    return false
end

function ExoWelder:OverrideWeaponName()
    return "claw"
end

function ExoWelder:OnPrimaryAttack(player)

    if GetIsVortexed(player) then
        return
    end
    
    PROFILE("ExoWelder:OnPrimaryAttack")
    
    if not self.welding then
    
        //self:TriggerEffects("exowelder_start", {effecthostcoords = Coords.GetTranslation(self:GetBarrelPoint())})
        self.timeWeldStarted = Shared.GetTime()
        
        if Server then
            self.loopingFireSound:Start()
        end
        
    end
    
    self.welding = true
    local hitPoint = nil
    
    if self.timeLastWeld + kWelderFireDelay < Shared.GetTime () then
    
        hitPoint = self:PerformWeld(player)
        self.timeLastWeld = Shared.GetTime()
        
    end
    
    if not self.timeLastWeldEffect or self.timeLastWeldEffect + kWelderEffectRate < Shared.GetTime() then
    
        //self:TriggerEffects("exowelder_muzzle", {effecthostcoords = Coords.GetTranslation(self:GetBarrelPoint())})
        self.timeLastWeldEffect = Shared.GetTime()
        
    end
    
end

function ExoWelder:OnPrimaryAttackEnd(player)

    if self.welding then
        self:TriggerEffects("welder_end")
    end
    
    self.welding = false
    
    if Server then
        self.loopingFireSound:Stop()
    end
    
end

function ExoWelder:GetRepairRate(repairedEntity)

    local repairRate = kPlayerWeldRate
    if repairedEntity.GetReceivesStructuralDamage and repairedEntity:GetReceivesStructuralDamage() then
        repairRate = kStructureWeldRate
    end
    
    return repairRate
    
end

local function PrioritizeDamagedFriends(weapon, player, newTarget, oldTarget)
    return not oldTarget or (HasMixin(newTarget, "Team") and newTarget:GetTeamNumber() == player:GetTeamNumber() and (HasMixin(newTarget, "Weldable") and newTarget:GetCanBeWelded(weapon)))
end

function ExoWelder:PerformWeld(player)

    local attackDirection = player:GetViewCoords().zAxis
    local success = false
    // prioritize friendlies
    local didHit, target, endPoint, direction, surface = CheckMeleeCapsule(self, player, 0, self:GetRange(), nil, true, 1, PrioritizeDamagedFriends, nil, PhysicsMask.Flame)
    
    if didHit and target and HasMixin(target, "Live") then
        
        if GetAreEnemies(player, target) then
            self:DoDamage(kWelderDamagePerSecond * kWelderFireDelay, target, endPoint, attackDirection)
            success = true     
        elseif player:GetTeamNumber() == target:GetTeamNumber() and HasMixin(target, "Weldable") then
        
            if target:GetHealthScalar() < 1 then
                
                local prevHealthScalar = target:GetHealthScalar()
                local prevHealth = target:GetHealth()
                local prevArmor = target:GetArmor()
                target:OnWeld(self, kWelderFireDelay, player)
                success = prevHealthScalar ~= target:GetHealthScalar()
                
                if success then
                
                    local addAmount = (target:GetHealth() - prevHealth) + (target:GetArmor() - prevArmor)
                    player:AddContinuousScore("WeldHealth", addAmount, kAmountHealedForPoints, kHealScoreAdded)
                    
                    // weld owner as well
                    player:SetArmor(player:GetArmor() + kWelderFireDelay * kSelfWeldAmount)
                    
                end
                
            end
            
            if HasMixin(target, "Construct") and target:GetCanConstruct(player) then
                target:Construct(kWelderFireDelay, player)
            end
            
        end
        
    end
    
    if success then    
        return endPoint
    end
    
end

function ExoWelder:GetDeathIconIndex()
    return kDeathMessageIcon.Welder
end

function ExoWelder:ProcessMoveOnWeapon(player, input)
end

function ExoWelder:GetWeight()
    return 0
end

function ExoWelder:OnTag(tagName)
end

function ExoWelder:OnUpdateAnimationInput(modelMixin)

    PROFILE("ExoWelder:OnUpdateAnimationInput")
    
    local activity = self.welding and "primary" or "none"
    
    modelMixin:SetAnimationInput("activity", activity)
    modelMixin:SetAnimationInput("welder", true)
    
end

function ExoWelder:UpdateViewModelPoseParameters(viewModel)
    viewModel:SetPoseParam("welder", 1)    
end

function ExoWelder:OnUpdatePoseParameters(viewModel)

    PROFILE("ExoWelder:OnUpdatePoseParameters")
    self:SetPoseParam("welder", 1)
    
end

function ExoWelder:OnUpdateRender()
 
    if self.ammoDisplayUI then
    
        local progress = PlayerUI_GetUnitStatusPercentage()
        self.ammoDisplayUI:SetGlobal("weldPercentage", progress)
        
    end
    
    local parent = self:GetParent()
    if parent and self.welding then

        if (not self.timeLastWeldHitEffect or self.timeLastWeldHitEffect + 0.06 < Shared.GetTime()) then
        
            local viewCoords = parent:GetViewCoords()
        
            local trace = Shared.TraceRay(viewCoords.origin, viewCoords.origin + viewCoords.zAxis * self:GetRange(), CollisionRep.Damage, PhysicsMask.Flame, EntityFilterTwo(self, parent))
            if trace.fraction ~= 1 then
            
                local coords = Coords.GetTranslation(trace.endPoint - viewCoords.zAxis * .1)
                
                local className = nil
                if trace.entity then
                    className = trace.entity:GetClassName()
                end
                
                self:TriggerEffects("welder_hit", { classname = className, effecthostcoords = coords})
                
            end
            
            self.timeLastWeldHitEffect = Shared.GetTime()
            
        end
        
    end
    
end

function ExoWelder:GetBarrelPoint()
    
	local player = self:GetParent()
	if player then
	
		local origin = player:GetEyePos()
		local viewCoords= player:GetViewCoords()
		
		return origin + viewCoords.zAxis * -0.6 + viewCoords.xAxis * -0.5 + viewCoords.yAxis * -0.3
		
	end
	
	return self:GetOrigin()
	
end

Shared.LinkClassToMap("ExoWelder", ExoWelder.kMapName, networkVars)