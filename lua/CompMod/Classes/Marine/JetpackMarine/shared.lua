-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Marine\JetpackMarine\shared.lua
-- - Dragon

JetpackMarine.kJetpackFuelReplenishDelay = kJetpackFuelReplenishDelay
JetpackMarine.kJetpackGravity = -13

local networkVars =
{
    jetpack_upg1 = "boolean",
	jetpack_upg2 = "boolean",
}

local originalJetpackMarineOnInitialized
originalJetpackMarineOnInitialized = Class_ReplaceMethod("JetpackMarine", "OnInitialized",
	function(self)
		originalJetpackMarineOnInitialized(self)
		self.jetpack_upg1 = false
		self.jetpack_upg2 = false
		
		if Server then
			self:AddTimedCallback(JetpackMarine.OnTechOrResearchUpdated, 0.1)
		end
		
	end
)

function JetpackMarine:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.JetpackUpgrade1) then
		self.jetpack_upg1 = true
	else
		self.jetpack_upg1 = false
	end
end

function JetpackMarine:GetFuelUseRate()
    return self.jetpack_upg1 and kUpgradedJetpackUseFuelRate or kJetpackUseFuelRate
end

function JetpackMarine:GetFuelReplenishRate()
    return self.jetpack_upg1 and kUpgradedJetpackReplenishFuelRate or kJetpackReplenishFuelRate
end

function JetpackMarine:GetFuel()

    local dt = Shared.GetTime() - self.timeJetpackingChanged

    local rate = -self:GetFuelUseRate()
    if not self.jetpacking then
        rate = self:GetFuelReplenishRate()
        dt = math.max(0, dt - JetpackMarine.kJetpackFuelReplenishDelay)
    end
    
    if self:GetDarwinMode() then
        return 1
    else
        return Clamp(self.jetpackFuelOnChange + rate * dt, 0, 1)
    end
    
end

function JetpackMarine:GetAirControl()
    return 30
end

function JetpackMarine:ModifyVelocity(input, velocity, deltaTime)

    if self:GetIsJetpacking() then
        
        local verticalAccel = kJetpackingVerticleThrust
        
        if self:GetIsWebbed() then
            verticalAccel = 5
        elseif input.move:GetLength() == 0 then
            verticalAccel = verticalAccel + 6
        end
    
        self.onGround = false
		
		-- Finalize y component
        local thrust = math.max(0, -velocity.y) / 6
		thrust = math.min(5, velocity.y + verticalAccel * deltaTime * (1 + thrust * 2.5))
        
		-- do XZ acceleration
		local prevXZSpeed = velocity:GetLengthXZ()
		local maxSpeedTable = { maxSpeed = kJetpackFlySpeed }
		self:ModifyMaxSpeed(maxSpeedTable)
		local maxSpeed = maxSpeedTable.maxSpeed
		
		local wishDir = self:GetViewCoords():TransformVector(input.move)
		wishDir.y = 0
		wishDir:Normalize()

		velocity:Add(wishDir * kJetpackLateralForce * self:GetInventorySpeedScalar() * deltaTime)

		if velocity:GetLengthXZ() > maxSpeed then
			velocity.y = 0
			velocity:Normalize()
			velocity:Scale(maxSpeed)
		end
		
		-- Finally set y component after any scaling is done.
		velocity.y = thrust
 
    end

end

Shared.LinkClassToMap("JetpackMarine", JetpackMarine.kMapName, networkVars, true)