-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Hydra\shared.lua
-- - Dragon

local kHydraScale = 1.4

function Hydra:OnAdjustModelCoords(modelCoords)
	modelCoords.xAxis = modelCoords.xAxis * kHydraScale
	modelCoords.yAxis = modelCoords.yAxis * kHydraScale
	modelCoords.zAxis = modelCoords.zAxis * kHydraScale
    return modelCoords
end

function Hydra:GetRateOfFire()
	return kHydraRateOfFire
end

if Server then
	
	local CreateSpikeProjectile = GetUpValue(Hydra.AttackTarget, "CreateSpikeProjectile")
	function Hydra:AttackTarget()

		self:TriggerUncloak()
		
		CreateSpikeProjectile(self)    
		self:TriggerEffects("hydra_attack")
		
		self.timeOfNextFire = Shared.GetTime() + self:GetRateOfFire()
		
	end

end