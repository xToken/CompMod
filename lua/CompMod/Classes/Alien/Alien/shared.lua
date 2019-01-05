-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Alien\Alien\shared.lua
-- - Dragon

local originalAlienGetMaxEnergy
originalAlienGetMaxEnergy = Class_ReplaceMethod("Alien", "GetMaxEnergy",
	function(self)
		return kAbilityMaxEnergy
	end
)

local originalAlienGetAdrenalineMaxEnergy
originalAlienGetAdrenalineMaxEnergy = Class_ReplaceMethod("Alien", "GetAdrenalineMaxEnergy",
	function(self)
		return 0
	end
)

local originalAlienGetRecuperationRate
originalAlienGetRecuperationRate = Class_ReplaceMethod("Alien", "GetRecuperationRate",
	function(self)
		return Alien.kEnergyRecuperationRate + (((self.hasAdrenalineUpgrade and self:GetAdrenalineRecuperationRate() or 0) * self:GetSpurLevel() / 2) * Alien.kEnergyRecuperationRate)
	end
)

function Alien:GetAdrenalineRecuperationRate()
	return 1
end