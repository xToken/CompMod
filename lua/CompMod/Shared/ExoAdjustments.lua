// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\ExoAdjustments.lua
// - Dragon

//Update Exo Locals
ReplaceLocals(Exo.UpdateThrusters, { kThrustersCooldownTime = kExoThrustersCooldownTime })
ReplaceLocals(Exo.UpdateThrusters, { kThrusterDuration = kExoThrusterDuration })

local kUpVector = Vector(0, 1, 0)
function Exo:ModifyVelocity(input, velocity, deltaTime)

    if self.thrustersActive then
    
        if self.thrusterMode == kExoThrusterMode.Vertical then   
        
            velocity:Add(kUpVector * kExoThrusterUpwardsAcceleration * deltaTime)
            velocity.y = math.min(1.5, velocity.y)
            
        elseif self.thrusterMode == kExoThrusterMode.Horizontal then
                
            local maxSpeed = self:GetMaxSpeed() + kExoHorizontalThrusterAddSpeed
            local wishDir = self:GetViewCoords():TransformVector(input.move)
            wishDir.y = 0
            wishDir:Normalize()
            
            local currentSpeed = wishDir:DotProduct(velocity)
            local addSpeed = math.max(0, maxSpeed - currentSpeed)
            
            if addSpeed > 0 then
                    
                local accelSpeed = kExoThrusterHorizontalAcceleration * deltaTime               
                accelSpeed = math.min(addSpeed, accelSpeed)
                velocity:Add(wishDir * accelSpeed)
            
            end
        
        end
        
    end
    
end