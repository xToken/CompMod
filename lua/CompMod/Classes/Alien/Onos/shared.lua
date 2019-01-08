-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Alien\Onos\shared.lua
-- - Dragon

-- Disable all of this nonsense...
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
        
        self:DeductAbilityEnergy(Onos.kChargeEnergyCost * input.time)
        
        if self:GetEnergy() == 0 then
        
            self:EndCharge()
            
        end
        
    end
    
    if self.autoCrouching then
        self.crouching = self.autoCrouching
    end
    
end

Onos.kMaxSpeed = kOnosMaxGroundSpeed
Onos.kChargeSpeed = kOnosMaxChargeSpeed
Onos.kChargeUpDuration = kOnosChargeUpTime
Onos.kChargeDelay = kOnosChargeDelay