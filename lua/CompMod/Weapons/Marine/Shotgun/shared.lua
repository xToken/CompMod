-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Marine\Shotgun\shared.lua
-- - Dragon

-- Recalc this
Shotgun.kSpreadVectors =
{
    GetNormalizedVector(Vector(-0.1, 0.1, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0.1, -0.1, kShotgunSpreadDistance)),
    
    GetNormalizedVector(Vector(-0.15, 0, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0.15, 0, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0, -0.15, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0, 0.15, kShotgunSpreadDistance)),
	
	GetNormalizedVector(Vector(-0.175, -0.175, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(-0.175, 0.175, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0.175, 0.175, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0.175, -0.175, kShotgunSpreadDistance))
}

local kBulletSize = 0.016

local networkVars =
{
    shotgun_upg1 = "boolean",
	shotgun_upg2 = "boolean",
}

local originalShotgunOnInitialized
originalShotgunOnInitialized = Class_ReplaceMethod("Shotgun", "OnInitialized",
	function(self)
		originalShotgunOnInitialized(self)
		self.shotgun_upg1 = false
		self.shotgun_upg2 = false
		
		if Server then
			self:AddTimedCallback(Shotgun.OnTechOrResearchUpdated, 0.1)
		end
		
	end
)

function Shotgun:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.ShotgunUpgrade1) then
		self.shotgun_upg1 = true
	else
		self.shotgun_upg1 = false
	end
	if GetHasTech(self, kTechId.ShotgunUpgrade2) then
		self.shotgun_upg2 = true
	else
		self.shotgun_upg2 = false
	end
end

function Shotgun:GetUpgradeTier()
	if self.shotgun_upg2 then
		return kTechId.ShotgunUpgrade2, 2
	elseif self.shotgun_upg1 then
		return kTechId.ShotgunUpgrade1, 1
	end
    return kTechId.None, 0
end

function Shotgun:GetCatalystSpeedBase()
    return self.shotgun_upg1 and kShotgunUpgradedReloadSpeed or 1
end

function Shotgun:GetBulletDamage(player, endPoint)
	local distanceTo = (player:GetEyePos() - endPoint):GetLength()
	if distanceTo > kShotgunMaxRange then
		return 1
	elseif distanceTo <= kShotgunDropOffStartRange then
		return kShotgunDamage
	else
		return kShotgunDamage * (1 - (distanceTo - kShotgunDropOffStartRange) / (kShotgunMaxRange - kShotgunDropOffStartRange))
	end
end

function Shotgun:GetBaseAttackSpeed()
    return self.shotgun_upg2 and kShotgunUpgradedROF or kShotgunBaseROF
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
        --startPoint = player:GetEyePos() + shootCoords.xAxis * self.kSpreadVectors[bullet].x * self.kStartOffset + shootCoords.yAxis * self.kSpreadVectors[bullet].y * self.kStartOffset
        
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
			
			if Server then
				--Print(string.format("Pellet %s dealt %s damage to %s entity %sm away", bullet, damage, target:GetClassName(), (player:GetEyePos() - hitPoint):GetLength()))
			end
			
            self:ApplyBulletGameplayEffects(player, target, hitPoint - hitOffset, direction, damage, "", showTracer and i == numTargets)
            
            local client = Server and player:GetClient() or Client
            if not Shared.GetIsRunningPrediction() and client.hitRegEnabled then
                RegisterHitEvent(player, bullet, startPoint, trace, damage)
            end
        
        end
        
    end

end

Shared.LinkClassToMap("Shotgun", Shotgun.kMapName, networkVars)