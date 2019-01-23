-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\MaturityMixin\shared.lua
-- - Dragon

kMaturityLevel = enum({ 'Starving', 'Grown', 'Mature', 'Producing', 'Flourishing' })

function MaturityMixin:GetStarvationRate()
    return kMaturityBaseStarvationRate
end

function MaturityMixin:GetMaturationRate()
    return kMaturityBaseGainRate
end

function MaturityMixin:GetMaturityLevel()
    local matureFraction = self:GetMaturityFraction()
    if matureFraction < kMaturityStarvingThreshold then
        return kMaturityLevel.Starving
    elseif matureFraction < kMaturityFlourishingThreshold then
        return kMaturityLevel.Producing
    else
        return kMaturityLevel.Flourishing
    end
end

function MaturityMixin:GetMaturityScaling()
	local matureFraction = self:GetMaturityFraction()
	if matureFraction <= kMaturityMinEffectivenessThreshold then
		return kMaturityMinEffectivenessThreshold
	elseif matureFraction > kMaturityMaxEffectivenessThreshold then
		return kMaturityFlourishingEffectiveness
	else
		return (matureFraction)/(kMaturityMaxEffectivenessThreshold)
	end
end