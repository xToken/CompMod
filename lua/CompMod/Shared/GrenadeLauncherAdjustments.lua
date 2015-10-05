// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\GrenadeLauncherAdjustments.lua
// - Dragon

Grenade.kDetonateRadius = 0.13
local kGrenadeScale = 5
local kGrenadeGravity = 1
local kGrenadeSpeed = 25
local kFullGravity = 9.81

/*
function Grenade:OnAdjustModelCoords(modelCoords)

    local coords = modelCoords
    coords.xAxis = coords.xAxis * kGrenadeScale
    coords.yAxis = coords.yAxis * kGrenadeScale
    coords.zAxis = coords.zAxis * kGrenadeScale
    return coords
	
end*/

function Grenade:OnInitialized()

	PredictedProjectile.OnInitialized(self)
	
	if Client then
        InitMixin(self, HiveVisionMixin)
	end
	
end

function Grenade:ProcessHit(targetHit, surface, normal, endPoint )

	if targetHit and GetAreEnemies(self, targetHit) or self.clearOnImpact then
		self:Detonate(targetHit, hitPoint )
	else
		if self:GetVelocity():GetLength() > 2 then
			self:TriggerEffects("grenade_bounce")
		end
		//Reset Gravity for bounces.
		self.gravity = kFullGravity
	end
	
end

local oldPredictedProjectileShooterMixinCreatePredictedProjectile = PredictedProjectileShooterMixin.CreatePredictedProjectile
function PredictedProjectileShooterMixin:CreatePredictedProjectile(className, startPoint, velocity, bounce, friction, gravity, impactClear, minLifeTime )

    local projectile = oldPredictedProjectileShooterMixinCreatePredictedProjectile(self, className, startPoint, velocity, bounce, friction, gravity)
	
	if projectile then
		projectile.clearOnImpact = ConditionalValue(impactClear, true, false)
		projectile.minLifeTime = minLifeTime or projectile.minLifeTime
	end
    
    return projectile

end

function GrenadeLauncher:GetHasSecondary(player)
    return true
end

local originalGrenadeLauncherOnTag
originalGrenadeLauncherOnTag = Class_ReplaceMethod("GrenadeLauncher", "OnTag",
	function(self, tagName)
		originalGrenadeLauncherOnTag(self, tagName)
		if tagName == "end" then
			self.secondaryAttacking = false
		end
	end
)

local function ShootGrenade(self, player)

    PROFILE("ShootGrenade")
    
    self:TriggerEffects("grenadelauncher_attack")

    if Server or (Client and Client.GetIsControllingPlayer()) then

        local viewCoords = player:GetViewCoords()
        local eyePos = player:GetEyePos()

        local startPointTrace = Shared.TraceCapsule(eyePos, eyePos + viewCoords.zAxis, 0.2, 0, CollisionRep.Move, PhysicsMask.PredictedProjectileGroup, EntityFilterTwo(self, player))
        local startPoint = startPointTrace.endPoint

        local direction = viewCoords.zAxis
        
        if startPointTrace.fraction ~= 1 then
            direction = GetNormalizedVector(direction:GetProjection(startPointTrace.normal))
        end
		
		if self.primaryAttacking then
			player:CreatePredictedProjectile("Grenade", startPoint, direction * kGrenadeSpeed, 0.7, 0.45, kGrenadeGravity, true,  0)
		else
			player:CreatePredictedProjectile("Grenade", startPoint, direction * kGrenadeSpeed, 0.7, 0.45, kGrenadeGravity, false,  Grenade.kMinLifeTime)
		end
    
    end
    
    TEST_EVENT("Grenade Launcher primary attack")
    
end

function GrenadeLauncher:FirePrimary(player)
    ShootGrenade(self, player)    
end

function GrenadeLauncher:OnUpdateAnimationInput(modelMixin)

    ClipWeapon.OnUpdateAnimationInput(self, modelMixin)
	local stunned = false
    local player = self:GetParent()
	
    if player then
        if HasMixin(player, "Stun") and player:GetIsStunned() then
            stunned = true
        end
	end
	
	if self.secondaryAttacking and not stunned then
		modelMixin:SetAnimationInput("activity", "primary")
	end
    
    modelMixin:SetAnimationInput("loaded_shells", self:GetClip())
    modelMixin:SetAnimationInput("reserve_ammo_empty", self:GetAmmo() == 0)
    
end