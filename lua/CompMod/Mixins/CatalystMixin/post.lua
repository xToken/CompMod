-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\CatalystMixin\post.lua
-- - Dragon

CatalystMixin.networkVars = {
    isCatalysted = "boolean",
    timeCatalystEnds = "time"
}

local oldCatalystMixin__initmixin = CatalystMixin.__initmixin
function CatalystMixin:__initmixin()
    oldCatalystMixin__initmixin(self)
    self.timeCatalystEnds = 0
end

function CatalystMixin:GetCanCatalyst(duration)
    local canBeMatured = HasMixin(self, "Maturity")
    local maxDuration = self.timeCatalystEnds + duration > Shared.GetTime() + kNutrientMistMaxStackTime 
    local isBuilt = true --not HasMixin(self, "Construct") or self:GetIsBuilt()

    return canBeMatured and not maxDuration and not self:isa("Player") and isBuilt
end

function CatalystMixin:TriggerCatalyst(duration)

    if Server then
        local wasCatalyzed = self.isCatalysted
        duration = math.min(math.max(self.timeCatalystEnds - Shared.GetTime(), 0) + ConditionalValue(duration ~= nil, duration, CatalystMixin.kDefaultDuration), kNutrientMistMaxStackTime)
        self.timeCatalystEnds = Shared.GetTime() + duration
        self.timeUntilCatalystEnd = duration
        self.isCatalysted = true
        self.shouldHeal = shouldHeal or false
        if not wasCatalyzed and CatalystMixin.UpdateCatalystEffects then
            self:AddTimedCallback(CatalystMixin.UpdateCatalystEffects, duration)
        end
        if self.OnCatalyst then
            self:OnCatalyst()
        end
    end

end