//Dont want to always replace random files, so this.

local oldGameEffectsMixinGetGameEffectMask = GameEffectsMixin.GetGameEffectMask
function GameEffectsMixin:GetGameEffectMask(effect)
    if effect == kGameEffect.OnFire and self.BlockFireState then
		return false
	end
	return oldGameEffectsMixinGetGameEffectMask(self, effect)
end

local oldFireMixinOnUpdate = FireMixin.OnUpdate  
function FireMixin:OnUpdate(deltaTime)
	self.timeLastFireDamageUpdate = Shared.GetTime()
	oldFireMixinOnUpdate(self, deltaTime)
end

local oldAlienTriggerEnzyme = Alien.TriggerEnzyme
function Alien:TriggerEnzyme(duration)
	self.BlockFireState = true
	oldAlienTriggerEnzyme(self, duration)
	self.BlockFireState = false
end

local oldUmbraMixinSetHasUmbra = UmbraMixin.SetHasUmbra
function UmbraMixin:SetHasUmbra(state, umbraTime, force)
	self.BlockFireState = true
	oldUmbraMixinSetHasUmbra(self, state, umbraTime, force)
	self.BlockFireState = false
end

local oldCragUpdateHealing = Crag.UpdateHealing
function Crag:UpdateHealing()
	self.BlockFireState = true
    oldCragUpdateHealing(self)
	self.BlockFireState = false
end

local oldShadeUpdateCloaking = Shade.UpdateCloaking
function Shade:UpdateCloaking()
	local continue
    self.BlockFireState = true
    continue = oldShadeUpdateCloaking(self)
	self.BlockFireState = false
	return continue
end

local oldShiftEnergizeInRange = Shift.EnergizeInRange
function Shift:EnergizeInRange()
	local continue
    self.BlockFireState = true
    continue = oldShiftEnergizeInRange(self)
	self.BlockFireState = false
	return continue
end

local oldWhipUpdateOrders = Whip.UpdateOrders
function Whip:UpdateOrders(deltaTime)
    self.BlockFireState = true
    oldWhipUpdateOrders(self, deltaTime)
	self.BlockFireState = false
end

local oldHydraOnUpdate = Hydra.OnUpdate
function Hydra:OnUpdate(deltaTime)
    self.BlockFireState = true
    oldHydraOnUpdate(self, deltaTime)
	self.BlockFireState = false
end

function Flamethrower:OnProcessMove(input)
	ClipWeapon.OnProcessMove(self, input)
end