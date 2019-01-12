-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\CatalystMixin\server.lua
-- - Dragon

function CatalystMixin:TriggerCatalyst(duration)

    if Server and self:GetCanCatalyst() then
    	if self.GetSustenanceScalar then
    		duration = duration * self:GetSustenanceScalar()
    	end
        self.timeUntilCatalystEnd = math.min(self.timeUntilCatalystEnd + ConditionalValue(duration ~= nil, duration, CatalystMixin.kDefaultDuration), kNutrientMistMaxStackTime)
        self.isCatalysted = true
        if self.OnCatalyzed then
        	self:OnCatalyzed()
        end
    end

end