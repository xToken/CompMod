-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\SkulkAdjustments.lua
-- - Dragon

-- Skulk
function Skulk:GetAirControl()
    return 32
end

function Skulk:ModifyJump(input, velocity, jumpVelocity)

    if self:GetCanWallJump() then
    
        local direction = input.move.z == -1 and -1 or 1
    
        -- we add the bonus in the direction the move is going
        local viewCoords = self:GetViewAngles():GetCoords()
        self.bonusVec = viewCoords.zAxis * direction
        self.bonusVec.y = 0
        self.bonusVec:Normalize()
        
        jumpVelocity.y = 3 + math.min(1, 1 + viewCoords.zAxis.y) * 2

        local fraction = 1 - Clamp( velocity:GetLengthXZ() / self:GetMaxWallJumpSpeed(), 0, 1)        
        
        local force = math.max(Skulk.kMinWallJumpForce, Skulk.kWallJumpForce * fraction)
          
        self.bonusVec:Scale(force)      

        if not self:GetRecentlyWallJumped() or fraction > 0.1 then
        
            self.bonusVec.y = viewCoords.zAxis.y * Skulk.kVerticalWallJumpForce
            jumpVelocity:Add(self.bonusVec)

        end
        
        self.timeLastWallJump = Shared.GetTime()
        
    end
    
end