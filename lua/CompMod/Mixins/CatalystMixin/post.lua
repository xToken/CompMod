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
    local maxDuration = self.timeUntilCatalystEnd + duration >= kNutrientMistMaxStackTime 
    local isBuilt = not HasMixin(self, "Construct") or self:GetIsBuilt()

    return canBeMatured and not maxDuration and not self:isa("Player") and isBuilt
end

function CatalystMixin:TriggerCatalyst(duration)

    if Server then
        self.timeUntilCatalystEnd = math.min(self.timeUntilCatalystEnd + ConditionalValue(duration ~= nil, duration, CatalystMixin.kDefaultDuration), kNutrientMistMaxStackTime)
        self.timeCatalystEnds = Shared.GetTime() + self.timeUntilCatalystEnd
        self.isCatalysted = true
        if not wasCatalyzed and CatalystMixin.UpdateCatalystEffects then
            self:AddTimedCallback(CatalystMixin.UpdateCatalystEffects, self.timeUntilCatalystEnd)
        end
        if self.OnCatalyst then
            self:OnCatalyst()
        end
    end

end