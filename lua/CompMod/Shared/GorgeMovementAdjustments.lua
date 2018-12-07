-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\GorgeMovementAdjustments.lua
-- - Dragon

-- Give gorges some more mobility (Default is 6)
function Gorge:GetAirControl()
    return 18
end

-- Slow down gorges going over the max speed from slidejumping (Default is 0.2)
function Gorge:GetAirFriction()
	local speedFraction = self:GetVelocity():GetLengthXZ() / self:GetMaxSpeed()
    return math.max(0.15 * speedFraction, 0.12)
end