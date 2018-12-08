-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\ShotgunAdjustments.lua
-- - Dragon

-- Recalc this
Shotgun.kSpreadVectors =
{
    GetNormalizedVector(Vector(-0.15, 0.15, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0.15, -0.15, kShotgunSpreadDistance)),
	
    GetNormalizedVector(Vector(-0.5, -0.5, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(-0.5, 0.5, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0.5, 0.5, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0.5, -0.5, kShotgunSpreadDistance)),
    
    GetNormalizedVector(Vector(-0.35, 0, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0.35, 0, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0, -0.35, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0, 0.35, kShotgunSpreadDistance))
}

local kBulletSize = 0.016

function Shotgun:GetBulletDamage(player, endPoint)
	local distanceTo = (player:GetEyePos() - endPoint):GetLength()
	if distanceTo > kShotgunMaxRange then
		return 1
	elseif distanceTo <= kShotgunDropOffStartRange then
		return kShotgunDamage
	else
		return kShotgunDamage * (1 - math.sin((distanceTo - kShotgunDropOffStartRange) / kShotgunMaxRange))
	end
end

function Shotgun:GetBaseAttackSpeed()
    return self.primaryAttacking and kShotgunBaseROF or 1
end

function Shotgun:FirePrimary(player)

    local viewAngles = player:GetViewAngles()
    viewAngles.roll = NetworkRandom() * math.pi * 2

    local shootCoords = viewAngles:GetCoords()

    -- Filter ourself out of the trace so that we don't hit ourselves.
    local filter = EntityFilterTwo(player, self)
    local range = self:GetRange()
    
    local numberBullets = self:GetBulletsPerShot()
    local startPoint = player:GetEyePos()
    
    self:TriggerEffects("shotgun_attack_sound")
    self:TriggerEffects("shotgun_attack")
    
    for bullet = 1, math.min(numberBullets, #self.kSpreadVectors) do
    
        if not self.kSpreadVectors[bullet] then
            break
        end    
    
        local spreadDirection = shootCoords:TransformVector(self.kSpreadVectors[bullet])

        local endPoint = startPoint + spreadDirection * range
        startPoint = player:GetEyePos() + shootCoords.xAxis * self.kSpreadVectors[bullet].x * self.kStartOffset + shootCoords.yAxis * self.kSpreadVectors[bullet].y * self.kStartOffset
        
        local targets, trace, hitPoints = GetBulletTargets(startPoint, endPoint, spreadDirection, kBulletSize, filter)
        
        HandleHitregAnalysis(player, startPoint, endPoint, trace)        
            
        local direction = (trace.endPoint - startPoint):GetUnit()
        local hitOffset = direction * kHitEffectOffset
        local impactPoint = trace.endPoint - hitOffset
        local effectFrequency = self:GetTracerEffectFrequency()
        local showTracer = bullet % effectFrequency == 0
        
        local numTargets = #targets
        
        if numTargets == 0 then
            self:ApplyBulletGameplayEffects(player, nil, impactPoint, direction, 0, trace.surface, showTracer)
        end
        
        if Client and showTracer then
            TriggerFirstPersonTracer(self, impactPoint)
        end

        for i = 1, numTargets do

            local target = targets[i]
            local hitPoint = hitPoints[i]
			local damage = self:GetBulletDamage(player, hitPoint)
			
            self:ApplyBulletGameplayEffects(player, target, hitPoint - hitOffset, direction, damage, "", showTracer and i == numTargets)
            
            local client = Server and player:GetClient() or Client
            if not Shared.GetIsRunningPrediction() and client.hitRegEnabled then
                RegisterHitEvent(player, bullet, startPoint, trace, damage)
            end
        
        end
        
    end

end