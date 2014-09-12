//Dont want to always replace random files, so this.

local function UpdateAirBrake(self, input, velocity, deltaTime)

    // more control when moving forward
    local holdingShift = bit.band(input.commands, Move.MovementModifier) ~= 0
    if input.move.z ~= 0 and holdingShift then
        
        if velocity:GetLengthXZ() > kLerkAirFrictionMinSpeed then
            local yVel = velocity.y
			local newScale = math.max(velocity:GetLengthXZ() - (8 * deltaTime), kLerkAirFrictionMinSpeed)
            velocity.y = 0
            velocity:Normalize()
            velocity:Scale(newScale)
            velocity.y = yVel
        end

    end

end

local kGlideAccel = GetUpValue( Lerk.ModifyVelocity,   "kGlideAccel", { LocateRecurse = true } )
local kMaxSpeed = GetUpValue( Lerk.GetMaxSpeed,   "kMaxSpeed" )

local function UpdateGlide(self, input, velocity, deltaTime)

    // more control when moving forward
    local holdingGlide = bit.band(input.commands, Move.Jump) ~= 0 and self.glideAllowed
    if input.move.z == 1 and holdingGlide then
    
        local useMove = Vector(input.move)
        useMove.x = useMove.x * 0.5
        
        local wishDir = GetNormalizedVector(self:GetViewCoords():TransformVector(useMove))
        // slow down when moving in another XZ direction, accelerate when falling down
        local currentDir = GetNormalizedVector(velocity)
        local glideAccel = -currentDir.y * deltaTime * (kGlideAccel - self:GetFrictionMod() * kLerkGlideFrictionBleedAmount)
		
        local maxSpeedTable = { maxSpeed = kMaxSpeed }
        self:ModifyMaxSpeed(maxSpeedTable, input)
        
        local speed = velocity:GetLength() // velocity:DotProduct(wishDir) * 0.1 + velocity:GetLength() * 0.9
        local useSpeed = math.min(maxSpeedTable.maxSpeed, speed + glideAccel)
        
        // when speed falls below 1, set horizontal speed to 1, and vertical speed to zero, but allow dive to regain speed
        if useSpeed < 4 then
            useSpeed = 4
            local newY = math.min(wishDir.y, 0)
            wishDir.y = newY
            wishDir = GetNormalizedVector(wishDir)
        end
        
        // when gliding we always have 100% control
        local redirectVelocity = wishDir * useSpeed
        VectorCopy(redirectVelocity, velocity)
        
        self.gliding = not self:GetIsOnGround()

    else
        self.gliding = false
    end
	
	UpdateAirBrake(self, input, velocity, deltaTime)

end

ReplaceLocals(Lerk.ModifyVelocity, { UpdateGlide = UpdateGlide })

function Lerk:GetSpeedMod()
	local speed = self:GetVelocity():GetLengthXZ()
	if speed < kLerkAirFrictionMinSpeed then
		return 0
	end
	//Whoa, call the cops on this clown
	return Clamp( (speed - kLerkAirFrictionMinSpeed) / (kMaxSpeed - kLerkAirFrictionMinSpeed), 0, 1)
end

function Lerk:GetFrictionMod()
	return Clamp(Shared.GetTime() - self:GetTimeOfLastFlap() / kLerkAirFrictionBleedTime, 0, 1) * self:GetSpeedMod()
end

local originalLerkGetAirFriction
originalLerkGetAirFriction = Class_ReplaceMethod("Lerk", "GetAirFriction",
	function(self)
		return self:GetFrictionMod() * kLerkAirFrictionBleedAmount + 0.1 - (GetHasCelerityUpgrade(self) and GetSpurLevel(self:GetTeamNumber()) or 0) * 0.02
	end
)

function Lerk:PreUpdateMove(input, runningPrediction)

    PROFILE("Lerk:PreUpdateMove")

    local wallGripPressed = bit.band(input.commands, Move.MovementModifier) ~= 0 and bit.band(input.commands, Move.Jump) == 0
    local wallGripDesired = self:GetVelocity():GetLengthXZ() <= kLerkWallGripMaxSpeed or input.move.z == 0
	
    if not self:GetIsWallGripping() and wallGripPressed and self.wallGripAllowed and wallGripDesired then

        // check if we can grab anything around us
        local wallNormal = self:GetAverageWallWalkingNormal(Lerk.kWallGripRange, Lerk.kWallGripFeelerSize)
        
        if wallNormal then
        
            self.wallGripTime = Shared.GetTime()
            self.wallGripNormalGoal = wallNormal
            self:SetVelocity(Vector(0,0,0))
            
        end
    
    else
        
        // we always abandon wall gripping if we flap (even if we are sliding to a halt)
        local breakWallGrip = bit.band(input.commands, Move.Jump) ~= 0 or input.move:GetLength() > 0 or self:GetCrouching()
        
        if breakWallGrip then
        
            self.wallGripTime = 0
            self.wallGripNormal = nil
            self.wallGripAllowed = false
            
        end
        
    end
    
end

local networkVars = { flySoundId = "entityid" }

Shared.LinkClassToMap("Lerk", Lerk.kMapName, networkVars, true)