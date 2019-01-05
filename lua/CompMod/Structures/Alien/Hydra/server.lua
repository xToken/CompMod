-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Hydra\shared.lua
-- - Dragon

local CreateSpikeProjectile = GetUpValue(Hydra.AttackTarget, "CreateSpikeProjectile")
function Hydra:AttackTarget()

	self:TriggerUncloak()
	
	CreateSpikeProjectile(self)    
	self:TriggerEffects("hydra_attack")
	
	self.timeOfNextFire = Shared.GetTime() + self:GetRateOfFire()
	
end