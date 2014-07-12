//Dont want to always replace random files, so this.

// Comp Mod change, add initial bone shield energy cost
function BoneShield:OnProcessMove(input)

    if self.primaryAttacking then
		
        local player = self:GetParent()
        if player then
		        
			if self.firstboneshieldframe then
				player:DeductAbilityEnergy(self:GetEnergyCost())
				self.firstboneshieldframe = false
			end
        
            local energy = player:GetEnergy()
            player:DeductAbilityEnergy(input.time * kBoneShieldEnergyPerSecond)
            
            if player:GetEnergy() == 0 then
                self.primaryAttacking = false
                self.timeLastBoneShield = Shared.GetTime()
            end
        end
    else
	
		self.firstboneshieldframe = true
		
    end

end

// Comp Mod change, bone shield doesnt block all damage.
local kBlockDoers =
{
    "Minigun",
    "Pistol",
    "Rifle",
    "HeavyMachineGun",
    "Shotgun",
    "Axe",
    "Welder",
    "Sentry",
    "Claw"
}

local function GetHitsBoneShield(self, doer, hitPoint)

    if table.contains(kBlockDoers, doer:GetClassName()) then
    
        local viewDirection = GetNormalizedVectorXZ(self:GetViewCoords().zAxis)
        local zPosition = viewDirection:DotProduct(GetNormalizedVector(hitPoint - self:GetOrigin()))

        return zPosition > -0.1
    
    end
    
    return false

end

function Onos:ModifyDamageTaken(damageTable, attacker, doer, damageType, hitPoint)

    if hitPoint ~= nil and self:GetIsBoneShieldActive() and GetHitsBoneShield(self, doer, hitPoint) then
    
        damageTable.damage = damageTable.damage * kBoneShieldDamageReduction
        self:TriggerEffects("boneshield_blocked", {effecthostcoords = Coords.GetTranslation(hitPoint)} )
        
    end

end

// Comp Mod change, onos != garbage truck - increased from .5
function Onos:GetMaxBackwardSpeedScalar()
    return 1
end

// Comp Mod change, onos != garbage truck - increased from 3.3
function Onos:GetAcceleration()
    return 6.5
end

// Comp Mod change, onos != garbage truck - increased from 0.2
function Onos:GetAirControl()
    return 4
end

// Comp Mod change, onos != garbage truck - increased from 3
function Onos:GetGroundFriction()
    return 6
end

ReplaceLocals(Onos.PlayerCameraCoordsAdjustment, { kOnosHeadMoveAmount = 0 })