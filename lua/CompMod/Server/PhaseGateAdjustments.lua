//Dont want to always replace random files, so this.

local oldPhaseGateUpdate = PhaseGate.Update
function PhaseGate:Update()
	self.phasepossible = (self.timeOfLastPhase == nil) or (Shared.GetTime() > (self.timeOfLastPhase + kPhaseGateDepartureRate))
	return oldPhaseGateUpdate(self)
end

function PhaseGateUserMixin:OnUpdate(deltaTime)
end