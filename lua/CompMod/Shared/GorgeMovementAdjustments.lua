//I dont know if I should be happy about this.
//Or sad.
//Why do you play with my emotions like this, its not fair.

//Here goes nothing, replacing a local constant with a function call
//Nothing can go wrong...
//It all went wrong :S

function Gorge:GetAirControl()
    return 30
end

function Gorge:GetAirFriction()
	local speedFraction = self:GetVelocity():GetLengthXZ() / self:GetMaxSpeed()
    return math.max(0.15 * speedFraction, 0.12)
end

//ReplaceUpValue( GroundMoveMixin.UpdateMove, "kMaxAirAccel", Player.GetMaxAirAccel, { LocateRecurse = true } )