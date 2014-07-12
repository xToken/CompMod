//Dont want to always replace random files, so this.

// FLY YOU BIG HULKING BEAST
local kThrusterUpwardsAcceleration = 1
local kInitialThrusterUpwardsAcceleration = 10
local kThrusterHorizontalAcceleration = 23
local kHorizontalThrusterAddSpeed = 2.5
local kThrusterDuration = 1.5

local kDeploy2DSound = PrecacheAsset("sound/NS2.fev/marine/heavy/deploy_2D")

local originalExoModifyVelocity
originalExoModifyVelocity = Class_ReplaceMethod("Exo", "ModifyVelocity",
	function(self, input, velocity, deltaTime)
	
		if self.thrustersActive then
    
			if self.thrusterMode == kExoThrusterMode.Vertical then   
				
				local Initialboost = 1 - math.min((Shared.GetTime() - self.timeThrustersStarted) / (kThrusterDuration * 0.35), 1)
				local UpwardsAccel = kThrusterUpwardsAcceleration + (kInitialThrusterUpwardsAcceleration * Initialboost)
				velocity:Add(kUpVector * UpwardsAccel * deltaTime)
				//velocity.y = math.min(1.5, velocity.y)
			
			elseif self.thrusterMode == kExoThrusterMode.Horizontal then
			
				input.move:Scale(0)
			
				local maxSpeed = self:GetMaxSpeed() + kHorizontalThrusterAddSpeed
				local wishDir = self:GetViewCoords().zAxis
				wishDir.y = 0
				wishDir:Normalize()
				
				local currentSpeed = wishDir:DotProduct(velocity)
				local addSpeed = math.max(0, maxSpeed - currentSpeed)
				
				if addSpeed > 0 then
						
					local accelSpeed = kThrusterHorizontalAcceleration * deltaTime               
					accelSpeed = math.min(addSpeed, accelSpeed)
					velocity:Add(wishDir * accelSpeed)
				
				end
			
			end
		else
			//Run old code when no thrusters active, to maintain any overrides people might have added.
			originalExoModifyVelocity(self, input, velocity, deltaTime)
		end
		
	end
)

local originalExoOnCreate
originalExoOnCreate = Class_ReplaceMethod("Exo", "OnCreate",
	function(self)
		originalExoOnCreate(self)
		InitMixin(self, PhaseGateUserMixin)
	end
)

function Exo:InitWeapons()

	Player.InitWeapons(self)
    
    local weaponHolder = self:GetWeapon(ExoWeaponHolder.kMapName)
    
    if not weaponHolder then
        weaponHolder = self:GiveItem(ExoWeaponHolder.kMapName, false)   
    end    
    
    if self.layout == "ClawMinigun" then
        weaponHolder:SetWeapons(ExoWelder.kMapName, Minigun.kMapName)
    elseif self.layout == "ClawRailgun" then
        weaponHolder:SetWeapons(ExoWelder.kMapName, Railgun.kMapName)
    else
    
        Print("Warning: incorrect layout set for exosuit")
        weaponHolder:SetWeapons(ExoWelder.kMapName, Minigun.kMapName)
        
    end
    
    weaponHolder:TriggerEffects("exo_login")
    self.inventoryWeight = weaponHolder:GetInventoryWeight(self)
    self:SetActiveWeapon(ExoWeaponHolder.kMapName)
    StartSoundEffectForPlayer(kDeploy2DSound, self)
    
end

function Exo:OnAdjustModelCoords(modelCoords)
    local coords = modelCoords
    coords.xAxis = coords.xAxis * kExosuitScale
    coords.yAxis = coords.yAxis * kExosuitScale
    coords.zAxis = coords.zAxis * kExosuitScale
    return coords
end

function Exo:GetWebSlowdownScalar()
    return 1
end

function Exo:GetAirControl()
    return 11 * self:GetSlowSpeedModifier()
end

function Exo:GetGroundFriction()
    return self.thrustersActive and 2 or 9
end

function Exo:GetMaxBackwardSpeedScalar()
    return 0.5
end

local networkVars = { }

AddMixinNetworkVars(PhaseGateUserMixin, networkVars)

Shared.LinkClassToMap("Exo", Exo.kMapName, networkVars, true)