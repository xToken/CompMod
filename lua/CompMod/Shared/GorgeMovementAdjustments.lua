// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\GorgeMovementAdjustments.lua
// - Dragon

//I dont know if I should be happy about this.
//Or sad.
//Why do you play with my emotions like this, its not fair.

function Gorge:GetAirControl()
    return 30
end

function Gorge:GetAirFriction()
	local speedFraction = self:GetVelocity():GetLengthXZ() / self:GetMaxSpeed()
    return math.max(0.15 * speedFraction, 0.12)
end

//ReplaceUpValue( GroundMoveMixin.UpdateMove, "kMaxAirAccel", Player.GetMaxAirAccel, { LocateRecurse = true } )