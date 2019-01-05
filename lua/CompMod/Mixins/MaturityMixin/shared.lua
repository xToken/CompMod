-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\MaturityMixin\shared.lua
-- - Dragon

kMaturityLevel = enum({ 'Starving', 'Grown', 'Mature' })

function MaturityMixin:GetStarvationRate()
    local matureFraction = self:GetMaturityFraction()
	if matureFraction < kMaturityBaseBreakpoint then
		return kMaturityBaseStarvationRate
	else
		return kMaturityAcceleratedStarvationRate
	end
end

function MaturityMixin:GetMaturationRate()
    local matureFraction = self:GetMaturityFraction()
	if matureFraction < kMaturityBaseBreakpoint then
		return kMaturityBaseGainRate
	else
		return kMaturityAcceleratedGainRate
	end
end

function MaturityMixin:GetMaturityLevel()
    local matureFraction = self:GetMaturityFraction()
    if matureFraction < kMaturityStarvingThreshold then
        return kMaturityLevel.Starving
    elseif matureFraction < kMaturityGrownThreshold then
        return kMaturityLevel.Grown
    else
        return kMaturityLevel.Mature
    end
end

function MaturityMixin:GetMaturityScaling()
	local matureFraction = self:GetMaturityFraction()
	if matureFraction <= kMaturityMinEffectivenessThreshold then
		return kMaturityMinEffectivenessThreshold
	elseif matureFraction > kMaturityMaxEffectivenessThreshold then
		return 1
	else
		return (matureFraction)/(kMaturityMaxEffectivenessThreshold)
	end
end