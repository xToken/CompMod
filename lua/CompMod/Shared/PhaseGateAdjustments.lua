// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\PhaseGateAdjustments.lua
// - Dragon

local oldPhaseGateOnCreate = PhaseGate.OnCreate
function PhaseGate:OnCreate()
	oldPhaseGateOnCreate(self)
	self.phasepossible = false
end

local oldPhaseGatePhase = PhaseGate.Phase
function PhaseGate:Phase(user)
	
	local success
	if HasMixin(user, "PhaseGateUser") and self.linked and self.phasepossible then
		success = oldPhaseGatePhase(self, user)
		//Shared.Message(string.format("Phase allowed at %s, succeeded %s on %s", Shared.GetTime(), success, ConditionalValue(Client, "Client", "Server")))
		if success and Server then
			self.phasepossible = false
		end
	else
		//Shared.Message(string.format("Denied phase because %s %s %s on %s", HasMixin(user, "PhaseGateUser"), self.linked, self.phasepossible, ConditionalValue(Client, "Client", "Server")))
	end
	return success
	
end

function PhaseGate:OnUpdateRender()

    PROFILE("PhaseGate:OnUpdateRender")

    if self.clientLinked ~= self.linked or self.clientPhasePossible ~= self.phasepossible then
    
        self.clientLinked = self.linked
		self.clientPhasePossible = self.phasepossible
        
        local effects = ConditionalValue(self.linked and self.phasepossible and self:GetIsVisible(), "phase_gate_linked", "phase_gate_unlinked")
        self:TriggerEffects(effects)
        
    end

end

Shared.LinkClassToMap("PhaseGate", nil, {phasepossible = "boolean"})

local kPhaseDelay = GetUpValue( PhaseGateUserMixin.GetCanPhase,  "kPhaseDelay")

function PhaseGateUserMixin:__initmixin()    
    self.timeOfLastPhase = 0
	if Client then
		self.timeOfLastPhaseClient = 0
	end
end

// Comp Mod change, added client side variable check to maybe fix phaseback issue?
function PhaseGateUserMixin:GetCanPhase()
	/*if Client and #GetEntitiesForTeamWithinRange("PhaseGate", self:GetTeamNumber(), self:GetOrigin(), 0.5) > 0 then
		Shared.Message(string.format("Client can phase per networked time - %s, time - %s", (Shared.GetTime() > self.timeOfLastPhase + kPhaseDelay), self.timeOfLastPhase))
		Shared.Message(string.format("Client can phase per client time - %s, time - %s", (Shared.GetTime() > self.timeOfLastPhaseClient + kPhaseDelay), self.timeOfLastPhaseClient))
	end*/
    return self:GetIsAlive() and Shared.GetTime() > self.timeOfLastPhase + kPhaseDelay and Shared.GetTime() > (self.timeOfLastPhaseClient or 0) + kPhaseDelay
end

if Client then
	//Phasing not-predicted anymore - doesnt really make sense.  The client has no idea what is on the other side anyways.
	function PhaseGateUserMixin:OnProcessMove(input)
	end
	
end