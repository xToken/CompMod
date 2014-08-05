//Dont want to always replace random files, so this.

//Comp Mod change, remove double jump to jetpack requirement.
function JetpackMarine:UpdateJetpack(input)
    
    local jumpPressed = (bit.band(input.commands, Move.Jump) ~= 0)
    
    local enoughTimePassed = not self:GetIsOnGround() and self:GetTimeGroundTouched() + 0.3 <= Shared.GetTime() or false

    self:UpdateJetpackMode()
    
    // handle jetpack start, ensure minimum wait time to deal with sound errors
    if not self.jetpacking and (Shared.GetTime() - self.timeJetpackingChanged > 0.2) and jumpPressed and self:GetFuel()> 0 then
    
        self:HandleJetpackStart()
        
        if Server then
            self.jetpackLoop:Start()
        end
        
    end
    
    // handle jetpack stop, ensure minimum flight time to deal with sound errors
    if self.jetpacking and (Shared.GetTime() - self.timeJetpackingChanged) > 0.2 and (self:GetFuel()== 0 or not jumpPressed) then
        self:HandleJetPackEnd()
    end
    
    if Client then
    
        local jetpackLoop = Shared.GetEntity(self.jetpackLoopId)
        if jetpackLoop then
        
            local fuel = self:GetFuel()
            if self:GetIsWebbed() then
                fuel = 0
            end
        
            jetpackLoop:SetParameter("fuel", fuel, 1)
        end
        
    end

end

// Comp Mod change, tweaking jetpack acceleration
// Jetpacking verticle movement will not start until the frame after the jetpack is triggered.
local kFlySpeed = 9
local kFlyFriction = 0.0
local kFlyAcceleration = 28

function JetpackMarine:GetCanJump()
    return not self:GetIsWebbed() and ( self:GetIsOnGround() or (self.timeJetpackingChanged == Shared.GetTime() and self.startedFromGround) or self:GetIsOnLadder() )
end

function JetpackMarine:ModifyVelocity(input, velocity, deltaTime)

    if self:GetIsJetpacking() then
        
        local verticalAccel = 22
        
        if self:GetIsWebbed() then
            verticalAccel = 5
        elseif input.move:GetLength() == 0 then
            verticalAccel = 26
        end
    
        self.onGround = false
        local thrust = math.max(0, -velocity.y) / 6
        velocity.y = math.min(5, velocity.y + verticalAccel * deltaTime * (1 + thrust * 2.5))
 
    end
    
    if not self.onGround then
    
        // do XZ acceleration
        local prevXZSpeed = velocity:GetLengthXZ()
        local maxSpeedTable = { maxSpeed = math.max(kFlySpeed, prevXZSpeed) }
        self:ModifyMaxSpeed(maxSpeedTable)
        local maxSpeed = maxSpeedTable.maxSpeed        
        
        if not self:GetIsJetpacking() then
            maxSpeed = prevXZSpeed
        end
        
        local wishDir = self:GetViewCoords():TransformVector(input.move)
        local acceleration = 0
        wishDir.y = 0
        wishDir:Normalize()
        
        acceleration = kFlyAcceleration
        
        velocity:Add(wishDir * acceleration * self:GetInventorySpeedScalar() * deltaTime)

        if velocity:GetLengthXZ() > maxSpeed then
        
            local yVel = velocity.y
            velocity.y = 0
            velocity:Normalize()
            velocity:Scale(maxSpeed)
            velocity.y = yVel
            
        end 
        
        if self:GetIsJetpacking() then
            velocity:Add(wishDir * kJetpackingAccel * deltaTime)
        end
    
    end

end

function JetpackMarine:ModifyJump(input, velocity, jumpVelocity)

    jumpVelocity.y = jumpVelocity.y * 0.8
    Marine.ModifyJump(self, input, velocity, jumpVelocity)

end