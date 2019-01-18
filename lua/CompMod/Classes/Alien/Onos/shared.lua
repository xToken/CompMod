-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Alien\Onos\shared.lua
-- - Dragon

-- Disable all of this nonsense...
local kOnosScale = 0.85
function Onos:Stampede()
end

-- Required by ControllerMixin.
function Onos:GetMovePhysicsMask()
    return PhysicsMask.OnosMovement
end

function Onos:GetAdrenalineRecuperationRate()
	return kOnosAdrenalineRecuperationScalar
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

function Onos:ModifyAttackSpeed(attackSpeedTable)

    local activeWeapon = self:GetActiveWeapon()
    if activeWeapon and activeWeapon:isa("Gore") and activeWeapon:GetAttackType() == Gore.kAttackType.Smash then
        attackSpeedTable.attackSpeed = attackSpeedTable.attackSpeed * 1.6
    end

end

function Onos:OnAdjustModelCoords(modelCoords)
    modelCoords.xAxis = modelCoords.xAxis * kOnosScale
    modelCoords.yAxis = modelCoords.yAxis * kOnosScale
    modelCoords.zAxis = modelCoords.zAxis * kOnosScale
    return modelCoords
end

Onos.kMaxSpeed = kOnosMaxGroundSpeed
Onos.kChargeSpeed = kOnosMaxChargeSpeed
Onos.kChargeUpDuration = kOnosChargeUpTime
Onos.kChargeDelay = kOnosChargeDelay