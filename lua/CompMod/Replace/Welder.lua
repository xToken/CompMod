// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\NewTech\Welder.lua
// Originally Created by 'Andreas Urwalek' for Natural Selection 2 - Unknown Worlds Entertainment, Inc. (http://www.unknownworlds.com)
// - Dragon

Script.Load("lua/Weapons/Weapon.lua")
Script.Load("lua/PickupableWeaponMixin.lua")
Script.Load("lua/LiveMixin.lua")

class 'Welder' (Weapon)

Welder.kMapName = "welder"

Welder.kModelName = PrecacheAsset("models/marine/welder/welder.model")
local kViewModels = GenerateMarineViewModelPaths("welder")
local kAnimationGraph = PrecacheAsset("models/marine/welder/welder_view.animation_graph")
local kWelderEffectRate = 0.45
local kFireLoopingSound = PrecacheAsset("sound/NS2.fev/marine/welder/weld")
local kHealScoreAdded = 2
local kAmountHealedForPoints = 600

local networkVars =
{
    welding = "boolean",
    loopingSoundEntId = "entityid",
    deployed = "boolean"
}

AddMixinNetworkVars(LiveMixin, networkVars)

function Welder:OnCreate()

    Weapon.OnCreate(self)
    
    self.welding = false
    self.deployed = false
    
    InitMixin(self, PickupableWeaponMixin)
    InitMixin(self, LiveMixin)
    
    self.loopingSoundEntId = Entity.invalidId
    
    if Server then
    
        self.loopingFireSound = Server.CreateEntity(SoundEffect.kMapName)
        self.loopingFireSound:SetAsset(kFireLoopingSound)
        // SoundEffect will automatically be destroyed when the parent is destroyed (the Welder).
        self.loopingFireSound:SetParent(self)
        self.loopingSoundEntId = self.loopingFireSound:GetId()
        
    end
    
end

function Welder:OnInitialized()

    self:SetModel(Welder.kModelName)
    
    Weapon.OnInitialized(self)
    
    self.timeWeldStarted = 0
    self.timeLastWeld = 0
    
end

function Welder:GetIsValidRecipient(recipient)

    if self:GetParent() == nil and recipient and not GetIsVortexed(recipient) and recipient:isa("Marine") then
    
        local welder = recipient:GetWeapon(Welder.kMapName)
        return welder == nil
        
    end
    
    return false
    
end

function Welder:GetViewModelName(sex, variant)
    return kViewModels[sex][variant]
end

function Welder:GetAnimationGraphName()
    return kAnimationGraph
end

function Welder:GetHUDSlot()
    return kTertiaryWeaponSlot
end

function Welder:GetIsDroppable()
    return true
end

function Welder:OnHolster(player)

    Weapon.OnHolster(self, player)
    
    self.welding = false
    self.deployed = false
    // cancel muzzle effect
    self:TriggerEffects("welder_holster")
    
end

function Welder:OnDraw(player, previousWeaponMapName)

    Weapon.OnDraw(self, player, previousWeaponMapName)
    
    self:SetAttachPoint(Weapon.kHumanAttachPoint)
    self.welding = false
    self.deployed = false
    
end

// for marine third person model pose, "builder" fits perfectly for this.
function Welder:OverrideWeaponName()
    return "builder"
end

function Welder:OnTag(tagName)

    if tagName == "deploy_end" then
        self.deployed = true
    end

end

function Welder:GetIsAffectedByWeaponUpgrades()
    return false
end

// don't play 'welder_attack' and 'welder_attack_end' too often, would become annoying with the sound effects and also client fps
function Welder:OnPrimaryAttack(player)
    
    PROFILE("Welder:OnPrimaryAttack")
	
    if GetIsVortexed(player) or not self.deployed then
        return
    end
	
	local t = Shared.GetTime()
    if self.timeLastWeld + kWelderFireDelay < t then
		
		local dt = t - self.timeLastWeld
		if not self.welding then
			self:TriggerEffects("welder_start")
			self.timeWeldStarted = t
			dt = kWelderFireDelay
			if Server then
				self.loopingFireSound:Start()
			end
		end
    
        self:PerformWeld(player, dt)
        self.timeLastWeld = t
    end
	
	self.welding = true
    
    if not self.timeLastWeldEffect or self.timeLastWeldEffect + kWelderEffectRate < t then
    
        self:TriggerEffects("welder_muzzle")
        self.timeLastWeldEffect = t
        
    end
    
end

function Welder:GetSprintAllowed()
    return true
end

// welder wont break sprinting
function Welder:GetTryingToFire(input)
    return false
end

function Welder:GetDeathIconIndex()
    return kDeathMessageIcon.Welder
end

function Welder:OnPrimaryAttackEnd(player)

    if self.welding then
        self:TriggerEffects("welder_end")
    end
    
    self.welding = false
    
    if Server then
        self.loopingFireSound:Stop()
    end
    
end

function Welder:Dropped(prevOwner)

    Weapon.Dropped(self, prevOwner)
    
    if Server then
        self.loopingFireSound:Stop()
    end
    
    self.welding = false
    self.deployed = false
    
end

function Welder:GetRange()
	return kWelderFriendlyRange
end

// repair rate increases over time
function Welder:GetRepairRate(repairedEntity)

    local repairRate = kPlayerWeldRate
    if repairedEntity.GetReceivesStructuralDamage and repairedEntity:GetReceivesStructuralDamage() then
        repairRate = kStructureWeldRate
    end
    
    return repairRate
    
end

function Welder:GetMeleeBase()
	if self.friendlies then
		return 2, 2
	end
	return Weapon.kMeleeBaseWidth, Weapon.kMeleeBaseHeight
end

local function PrioritizeDamagedFriends(weapon, player, newTarget, oldTarget)
    return not oldTarget or (HasMixin(newTarget, "Team") and newTarget:GetTeamNumber() == player:GetTeamNumber() and (HasMixin(newTarget, "Weldable") and newTarget:GetCanBeWelded(weapon)))
end

local function CheckForTeammatesToWeld(self, player, attackDirection, weldTime)
	//This kinda sucks, but its the easiest way.
	local success
	self.friendlies = true
	local didHit, target, endPoint, direction, surface = CheckMeleeCapsule(self, player, 0, kWelderFriendlyRange, nil, true, 1, PrioritizeDamagedFriends, nil, PhysicsMask.Flame)
    if didHit and target and HasMixin(target, "Live") then
		if player:GetTeamNumber() == target:GetTeamNumber() and HasMixin(target, "Weldable") then
			if target:GetHealthScalar() < 1 then
                
                local prevHealthScalar = target:GetHealthScalar()
                local prevHealth = target:GetHealth()
                local prevArmor = target:GetArmor()
                target:OnWeld(self, weldTime, player)
                success = prevHealthScalar ~= target:GetHealthScalar()
                
                if success then
                
                    local addAmount = (target:GetHealth() - prevHealth) + (target:GetArmor() - prevArmor)
                    player:AddContinuousScore("WeldHealth", addAmount, kAmountHealedForPoints, kHealScoreAdded)
                    
                    // weld owner as well
                    player:SetArmor(player:GetArmor() + weldTime * kSelfWeldAmount)
                    
                end
                
            end
            
            if HasMixin(target, "Construct") and target:GetCanConstruct(player) then
                target:Construct(weldTime, player)
				success = true
            end
		end
	end
	self.friendlies = false
	return success, endPoint
end

local function CheckForEnemiesToDamage(self, player, attackDirection, weldTime)
	local success
	local didHit, target, endPoint, direction, surface = CheckMeleeCapsule(self, player, 0, kWelderAttackRange, nil, true, 1, nil, nil, PhysicsMask.Flame)
	if didHit and target and HasMixin(target, "Live") then
        if GetAreEnemies(player, target) then
			if target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage() then
				self:DoDamage(kWelderStructureDamagePerSecond * weldTime, target, endPoint, attackDirection)
			else
				self:DoDamage(kWelderDamagePerSecond * weldTime, target, endPoint, attackDirection)
			end
            success = true
		end
	end
	return success, endPoint
end

function Welder:PerformWeld(player, weldTime)

    local attackDirection = player:GetViewCoords().zAxis
    local success = false
	local endPoint
	success, endPoint = CheckForTeammatesToWeld(self, player, attackDirection, weldTime)
	if not success then
		success, endPoint = CheckForEnemiesToDamage(self, player, attackDirection, weldTime)
	end
    return endPoint
	
end

function Welder:GetShowDamageIndicator()
    return true
end

function Welder:GetReplacementWeaponMapName()
    return Axe.kMapName
end

function Welder:OnUpdateAnimationInput(modelMixin)

    PROFILE("Welder:OnUpdateAnimationInput")
    
    local parent = self:GetParent()
    local sprinting = parent ~= nil and HasMixin(parent, "Sprint") and parent:GetIsSprinting()
    local activity = (self.welding and not sprinting) and "primary" or "none"
    
    modelMixin:SetAnimationInput("activity", activity)
    modelMixin:SetAnimationInput("welder", true)
    
end

function Welder:UpdateViewModelPoseParameters(viewModel)
    viewModel:SetPoseParam("welder", 1)    
end

function Welder:OnUpdatePoseParameters(viewModel)

    PROFILE("Welder:OnUpdatePoseParameters")
    self:SetPoseParam("welder", 1)
    
end

function Welder:OnUpdateRender()

    Weapon.OnUpdateRender(self)
    
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

function Welder:ModifyDamageTaken(damageTable, attacker, doer, damageType)
    if damageType ~= kDamageType.Corrode then
        damageTable.damage = 0
    end
end

function Welder:GetCanTakeDamageOverride()
    return self:GetParent() == nil
end

if Server then

    function Welder:OnKill()
        DestroyEntity(self)
    end
    
    function Welder:GetSendDeathMessageOverride()
        return false
    end    
    
end

function Welder:GetIsWelding()
    return self.welding
end

if Client then

    function Welder:GetUIDisplaySettings()
        return { xSize = 512, ySize = 512, script = "lua/GUIWelderDisplay.lua" }
    end
    
end

Shared.LinkClassToMap("Welder", Welder.kMapName, networkVars)