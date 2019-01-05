-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Marine\Exo\shared.lua
-- - Dragon

local kExoScale = 0.9
local kExoDeployDuration = GetUpValue(Exo.HandleButtons, "kExoDeployDuration")

local networkVars =
{
    exo_upg1 = "boolean",
	exo_upg2 = "boolean",
    shieldActive = "boolean",
    repairActive = "boolean"
}

AddMixinNetworkVars(DetectableMixin, networkVars)

local originalExoOnInitialized
originalExoOnInitialized = Class_ReplaceMethod("Exo", "OnInitialized",
	function(self)
		originalExoOnInitialized(self)
        InitMixin(self, DetectableMixin)
		self.exo_upg1 = false
		self.exo_upg2 = false
		self.shieldActive = false
		self.repairActive = false
		self.timeAutoRepairHealed = 0
        self.lastActivatedRepair = 0
        self.lastActivatedShield = 0
		if Server then
			self:AddTimedCallback(Exo.OnTechOrResearchUpdated, 0.1)
            -- Prevent people from ejecting to get fuel back instantly
            self:SetFuel(0.2)
		end
		
	end
)

function Exo:OnAdjustModelCoords(modelCoords)
	modelCoords.xAxis = modelCoords.xAxis * kExoScale
	modelCoords.yAxis = modelCoords.yAxis * kExoScale
	modelCoords.zAxis = modelCoords.zAxis * kExoScale
    return modelCoords
end

function Exo:SensorBlipType()
    return AlienSensorBlip.kMapName
end

function Exo:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.ExoUpgrade1) then
		self.exo_upg1 = true
	else
		self.exo_upg1 = false
	end
	if GetHasTech(self, kTechId.ExoUpgrade2) then
		self.exo_upg2 = true
	else
		self.exo_upg2 = false
	end
end

function Exo:GetMaxBackwardSpeedScalar()
    return 0.6
end

function Exo:ConsumingFuel()
    return self.thrustersActive or self.shieldActive or self.repairActive
end

function Exo:GetFuel()
    if self:ConsumingFuel() then
        return Clamp(self.fuelAtChange - (Shared.GetTime() - self.timeFuelChanged) / self:GetFuelUsageRate(), 0, 1)
    else
        return Clamp(self.fuelAtChange + (Shared.GetTime() - self.timeFuelChanged) / self:GetFuelRechargeRate(), 0, 1)
    end
end

function Exo:GetFuelRechargeRate()
	return kExoFuelRechargeRate
end

function Exo:GetFuelUsageRate()
    if self.thrustersActive then
    	return kExoThrusterFuelUsageRate
    elseif self.shieldActive then
    	return kExoShieldFuelUsageRate
    elseif self.repairActive then
    	return kExoRepairFuelUsageRate
    else
    	-- wut
    	return 1
    end
end

function Exo:GetShieldAllowed()
    return not self.thrustersActive and not self.repairActive and self.exo_upg1 
end

function Exo:GetRepairAllowed()
    return not self.thrustersActive and not self.shieldActive
end

function Exo:UpdateShields(input)

    local buttonPressed = bit.band(input.commands, Move.Use) ~= 0
    if buttonPressed and self:GetShieldAllowed() then

        if self:GetFuel() >= kExoShieldMinFuel and not self.shieldActive and self.lastActivatedShield + 1 < Shared.GetTime() then
        	self:SetFuel(self:GetFuel())
            self.shieldActive = true
            self.lastActivatedShield = Shared.GetTime()
            self:ActivateNanoShield()
        end
    end

    if self.shieldActive and (self:GetFuel() == 0 or not buttonPressed) then
    	self:SetFuel(self:GetFuel())
        self:DeactivateNanoShield()
        self.shieldActive = false
    end

end

function Exo:NanoShieldDamageReductionOverride()
	return kExoShieldDamageReductionScalar
end

function Exo:UpdateRepairs(input)

    local buttonPressed = bit.band(input.commands, Move.Reload) ~= 0
    local repairDesired = self:GetArmor() < self:GetMaxArmor()
    if buttonPressed and self:GetRepairAllowed() and repairDesired then

    	if self:GetFuel() >= kExoRepairMinFuel and not self.repairActive and self.lastActivatedRepair + 1 < Shared.GetTime() then
    		self:SetFuel(self:GetFuel())
            self.lastActivatedRepair = Shared.GetTime()
        	self.repairActive = true
        end
    end

    if self.repairActive and (self:GetFuel() == 0 or not buttonPressed or not repairDesired) then
    	self:SetFuel(self:GetFuel())
        self.repairActive = false
    end

    if not self:GetIsInCombat() and self.repairActive and self.timeAutoRepairHealed + kExoRepairInterval < Shared.GetTime() then            
        self:SetArmor(self:GetArmor() + kExoRepairInterval * kExoRepairPerSecond, false)
		self.timeAutoRepairHealed = Shared.GetTime()
    end

end

function Exo:HandleButtons(input)

    if self.ejecting or self.creationTime + kExoDeployDuration > Shared.GetTime() then

        input.commands = bit.band(input.commands, bit.bnot(bit.bor(Move.Use, Move.Buy, Move.Jump,
                                                                   Move.PrimaryAttack, Move.SecondaryAttack,
                                                                   Move.SelectNextWeapon, Move.SelectPrevWeapon, Move.Reload,
                                                                   Move.Taunt, Move.Weapon1, Move.Weapon2,
                                                                   Move.Weapon3, Move.Weapon4, Move.Weapon5, Move.Crouch, Move.MovementModifier)))
                                                                   
        input.move:Scale(0)
    
    end

    Player.HandleButtons(self, input)
    
    self:UpdateThrusters(input)
    self:UpdateRepairs(input)
    self:UpdateShields(input)

    if bit.band(input.commands, Move.Drop) ~= 0 then
       self:EjectExo()
    end
    
end

function Exo:GetIsThrusterAllowed()
    return not self.shieldActive and not self.repairActive
end

function Exo:GetCanBeWeldedOverride()
    return false, false
end

function Exo:OnWeldOverride(doer, elapsedTime)

	-- BIG exo takes LOTS of welding
    local weldRate = 1
    if HasMixin(self, "Combat") and self:GetIsInCombat() then
    	weldRate = 0.25
    end
    if doer and doer:isa("MAC") then
		weldRate = weldRate * 0.5
	end

    if self:GetArmor() < self:GetMaxArmor() then
    
        local addArmor = kExoArmorWeldRate * elapsedTime * weldRate
        --self:SetArmor(self:GetArmor() + addArmor)
        
    end
    
end

Shared.LinkClassToMap("Exo", Exo.kMapName, networkVars, true)

-- Actually set these values since locals
ReplaceLocals(Exo.GetMaxSpeed, { kMaxSpeed = kExoMaxSpeed })
ReplaceLocals(Exo.GetMaxSpeed, { kWalkMaxSpeed = 4.5 })
ReplaceLocals(Exo.UpdateThrusters, { kThrusterMinimumFuel = kExoThrusterMinFuel })
ReplaceLocals(Exo.ModifyVelocity, { kHorizontalThrusterAddSpeed = kExoThrusterMaxSpeed })
ReplaceLocals(Exo.ModifyVelocity, { kThrusterHorizontalAcceleration = kExoThrusterLateralAccel })
ReplaceLocals(Exo.ModifyVelocity, { kThrusterUpwardsAcceleration = kExoThrusterVerticleAccel })