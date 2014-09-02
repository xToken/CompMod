//    
// lua\WalkMixin.lua    
//    

WalkMixin = CreateMixin( WalkMixin )
WalkMixin.type = "Walk"

WalkMixin.optionalCallbacks =
{
    OnWalkStateChanged = "Invoked when walk state is changed.",
}

WalkMixin.networkVars =
{
    walking = "boolean"
}

function WalkMixin:__initmixin()
    self.walking = false
end

function WalkMixin:GetIsWalking()
    return self.walking
end

function WalkMixin:GetSprintingScalar()
    return self.sprintingScalar
end

function WalkMixin:UpdateWalkMode(input)

    local walkState = bit.band(input.commands, Move.SecondaryMovementModifier) ~= 0
    if walkState ~= self.walking then
        if self.OnWalkStateChanged then
			self:OnWalkStateChanged(walkState, input)
		end
		self.walking = walkState
    end
    
end