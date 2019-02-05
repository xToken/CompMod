-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Alien\Onos\shared.lua
-- - Dragon

local kOnosScale = 0.85

local networkVars = {
    timeRageChanged = "private time",
    rageAtChange = "private float (0 to 1 by 0.001)",
}

local originalOnosOnCreate
originalOnosOnCreate = Class_ReplaceMethod("Onos", "OnCreate",
    function(self)
        originalOnosOnCreate(self)
        self.timeRageChanged = 0
        self.rageAtChange = 0
        if Server then
            self.rageTriggers = { }
            self.rageTriggerTime = { }
        end
    end
)

local function TimeoutOldRageSources(self)
    local toRemove = {}
    for _, id in ipairs(self.rageTriggers) do
        
        if self.rageTriggerTime[id] + kOnosRageSourceTimeout < Shared.GetTime() then
            self.rageTriggerTime[id] = nil
            table.insert(toRemove, id)
        end
        
    end
    
    -- removed timed out
    for _, id in ipairs(toRemove) do
        table.removevalue(self.rageTriggers, id)
    end
end

function Onos:Stampede()
end

-- Required by ControllerMixin.
function Onos:GetMovePhysicsMask()
    return PhysicsMask.OnosMovement
end

function Onos:GetAdrenalineRecuperationRate()
	return kOnosAdrenalineRecuperationScalar
end

function Onos:AddRageAmount(rage)
   self:SetRageAmount(self:GetRage() + rage)
end

function Onos:SetRageAmount(rage)
   self.timeRageChanged = Shared.GetTime()
   self.rageAtChange = Clamp(rage, 0, 1)
end

function Onos:GetRage()
    return Clamp(self.rageAtChange - (math.max(Shared.GetTime() - self.timeRageChanged - kOnosRageGracePeriod, 0) / kOnosRageLifetime), 0, 1)
end

function Onos:PreUpdateMove(input, runningPrediction)
    
    if self.charging then
    
        -- fiddle here to determine strafing
        input.move.x = input.move.x * math.max(0, 1 - math.pow(self:GetChargeFraction(), 2))
        input.move.z = 1
        
        self:DeductAbilityEnergy(Onos.kChargeEnergyCost * input.time * self:GetChargeFraction())
        
        if self:GetEnergy() == 0 then
        
            self:EndCharge()
            
        end
        
    end
    
    if self.autoCrouching then
        self.crouching = self.autoCrouching
    end
    
end

function Onos:GetRageAttackSpeedIncrease()
    return self:GetRage() * kOnosMaxRageAttackSpeedIncrease
end

function Onos:GetRageRegenerationRate()
    return self:GetRage() * kOnosRageRegenerationRate
end

function Onos:UpdateRageHeal(deltaTime)

    PROFILE("Onos:UpdateRageHeal")

    if self:GetIsHealable() and (not self.timeLastRageHeal or self.timeLastRageHeal + kOnosRageRegenerationTime <= Shared.GetTime()) and not self:GetIsBoneShieldActive() then

        self:AddHealth(self:GetBaseHealth() * kOnosRageRegenerationRate * self:GetRage(), false, false, true)
        self.timeLastRageHeal = Shared.GetTime()
    
    end 

end

function Onos:ModifyAttackSpeed(attackSpeedTable)

    local activeWeapon = self:GetActiveWeapon()
    if activeWeapon and activeWeapon:isa("Gore") then
        --Gore
        attackSpeedTable.attackSpeed = attackSpeedTable.attackSpeed * 0.8
        --Smash
        if activeWeapon:GetAttackType() == Gore.kAttackType.Smash then
            attackSpeedTable.attackSpeed = attackSpeedTable.attackSpeed * 1.2
        end
    end

    attackSpeedTable.attackSpeed = attackSpeedTable.attackSpeed * (1 + (kOnosMaxRageAttackSpeedIncrease * self:GetRage()))

end

function Onos:OnProcessMove(input)
    
    Alien.OnProcessMove(self, input)    

    if self.stooping then
        self.stoopIntensity = math.min(1, self.stoopIntensity + Onos.kStoopingAnimationSpeed * input.time)
    else
        self.stoopIntensity = math.max(0, self.stoopIntensity - Onos.kStoopingAnimationSpeed * input.time)
    end
    
    self:UpdateRumbleSound()

    if Server then

        self:UpdateRageHeal(input.time)

    end
    
end

function Onos:GetMaxSpeed(possible)

    if possible then
        return Onos.kMaxSpeed
    end

    local boneShieldSlowdown = self:GetIsBoneShieldActive() and kBoneShieldMoveFraction or 1
    local chargeExtra = self:GetChargeFraction() * (Onos.kChargeSpeed - Onos.kMaxSpeed)
    local rageExtra = self:GetRage() * (kOnosBonusRageSpeed)
    
    return ( Onos.kMaxSpeed + chargeExtra + rageExtra ) * boneShieldSlowdown

end

function Onos:OnTakeDamage(_, attacker, doer, _)

    if Server then

        TimeoutOldRageSources(self)

        if attacker and not self:GetIsBoneShieldActive() and GetAreEnemies(self, attacker) then

            if not table.contains(self.rageTriggers, attacker:GetId()) then
                -- Its new
                table.insertunique(self.rageTriggers, attacker:GetId())
                self:AddRageAmount(kOnosRageUniqueDamage)
            else
                -- Old source
                self:AddRageAmount(kOnosRageDamage)
            end
            self.rageTriggerTime[attacker:GetId()] = Shared.GetTime()
        end

    end

end

function Onos:OnDamageDone(doer, target)

    if Server then

        TimeoutOldRageSources(self)
        
        if target and GetAreEnemies(self, target) then
            
            local newTarget = table.contains(self.rageTriggers, target:GetId())
            if target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage() then
                self:AddRageAmount(newTarget and kOnosRageUniqueStructureHit or kOnosRageStructureHit)
            else
                self:AddRageAmount(newTarget and kOnosRageUniqueHit or kOnosRageOnHit)
            end
            if newTarget then
                table.insertunique(self.rageTriggers, target:GetId())
            end
            self.rageTriggerTime[target:GetId()] = Shared.GetTime()
        end

    end

end

function Onos:OnAdjustModelCoords(modelCoords)
    modelCoords.xAxis = modelCoords.xAxis * kOnosScale
    modelCoords.yAxis = modelCoords.yAxis * kOnosScale
    modelCoords.zAxis = modelCoords.zAxis * kOnosScale
    return modelCoords
end

function Onos:ModifyHeal(healTable)
    
    if self.lasthealingtable == nil then
        self.lasthealingtable = {time = 0, healing = 0}
    end
    
    local curtime = Shared.GetTime()
    
    if curtime < self.lasthealingtable.time + kAlienHealRateTimeLimit then
        --Within timer, check values.
        --Check current max limit
        local tHeal = 0     --Previous heals within timer.
        local rHeal = 0     --Unmodded heal from this heal instance.
        local mHeal = 0     --Modded heal from this instance.
        local pHeal = 0     --Current percentage of healing within timer, including this heal instance.
        local nHeal = 0     --Final effective heal after all modifications.
        tHeal = self.lasthealingtable.healing
        rHeal = healTable.health
        pHeal = (tHeal + rHeal) / self:GetBaseHealth()
        if pHeal >= kOnosHealRatePercentLimit then
            --We're over the limit, reduce.
            --Get correct amount of HP to reduce if just exceeding cap.
            mHeal = Clamp((tHeal + rHeal) - (self:GetBaseHealth() * kOnosHealRatePercentLimit), 0, rHeal)
            --Lower 'real' unmodded healing accordingly.
            rHeal = math.max(rHeal - mHeal, 0)
        end
        nHeal = rHeal + math.max(mHeal * kOnosHealRateOverLimitReduction, 0)
        --Shared.Message(string.format("Healing cap information - Total Amount :%s - CurrentHeal :%s - Current Heal Percent :%s - Effective Heal :%s - 'Real' Heal :%s - 'Mod' Heal :%s - Healing Window :%s ", tHeal, healTable.health, pHeal, nHeal, rHeal, mHeal, kAlienHealRateTimeLimit))
        --Add to current limit
        healTable.health = nHeal
        self.lasthealingtable.healing = tHeal + nHeal
    else
        --Not under limit, clear table
        self.lasthealingtable.time = curtime
        self.lasthealingtable.healing = healTable.health
    end
    
end 

Onos.kMaxSpeed = kOnosMaxGroundSpeed
Onos.kChargeSpeed = kOnosMaxChargeSpeed
Onos.kChargeUpDuration = kOnosChargeUpTime
Onos.kChargeDelay = kOnosChargeDelay

Class_Reload("Onos", networkVars)