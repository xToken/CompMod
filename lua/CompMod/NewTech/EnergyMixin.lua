// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\NewTech\EnergyMixin.lua
// - Dragon

EnergyMixin = CreateMixin(EnergyMixin)
EnergyMixin.type = "Energy"
local kMaxEnergy = 100
local kEnergyUpdateTime = 1

EnergyMixin.expectedMixins =
{
    Tech = "Needed for the Tech Id"
}

EnergyMixin.optionalCallbacks =
{
    OverrideGetEnergyUpdateRate = "Return custom updaterate."
}

EnergyMixin.expectedCallbacks =
{
    GetCanUpdateEnergy = "Return true to update the energy."
}

EnergyMixin.networkVars =
{
    // We need to store as floating point to accumulate fractional values correctly, but
    // the client only cares about integer precision.
    energy = string.format("float (0 to %s by 1)", kMaxEnergy)
}

function EnergyMixin:__initmixin()

    self.energy = LookupTechData(self:GetTechId(), kTechDataInitialEnergy, 0)
    self.maxEnergy = math.min(LookupTechData(self:GetTechId(), kTechDataMaxEnergy, 0), kMaxEnergy)
    if Server then
        self:AddTimedCallback(EnergyMixin.Update, kEnergyUpdateTime)
    end
    assert(self.maxEnergy <= kMaxEnergy)
    
end

function EnergyMixin:GetEnergy()
    return self.energy
end

function EnergyMixin:SetEnergy(newEnergy)
    self.energy = Clamp(newEnergy, 0, self.maxEnergy)
end

function EnergyMixin:AddEnergy(amount)
    self.energy = Clamp(self.energy + amount, 0, self.maxEnergy)
end

function EnergyMixin:GetMaxEnergy()
    return self.maxEnergy
end

function EnergyMixin:GetEnergyFraction()
    return self.energy / self.maxEnergy
end

function EnergyMixin:Update()
    if GetGamerules():GetGameStarted() then
		if self:GetCanUpdateEnergy() then      
			self:AddEnergy(kEnergyUpdateTime)
		else
			self:AddEnergy(-kEnergyUpdateTime)
		end
		if self.energy == 0 and HasMixin(self, "PowerConsumer") then
			if self.OnPowerOff then
                self:OnPowerOff()
            end
		end
    end
    return self:GetIsAlive()
end