-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\CatalystMixin\server.lua
-- - Dragon

function CatalystMixin:TriggerCatalyst(duration)

    if Server and self:GetCanCatalyst() then
        self.timeUntilCatalystEnd = math.min(self.timeUntilCatalystEnd + ConditionalValue(duration ~= nil, duration, CatalystMixin.kDefaultDuration), kNutrientMistMaxStackTime)
        self.isCatalysted = true
    end

end