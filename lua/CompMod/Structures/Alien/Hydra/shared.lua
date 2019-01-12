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

function Hydra:DisableSustenance()
	return true
end