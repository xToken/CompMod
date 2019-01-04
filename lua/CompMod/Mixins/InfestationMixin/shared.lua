-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\InfestationMixin\shared.lua
-- - Dragon

local gInfestationMultiplier = 1
local gInfestationRecedeMultiplier = 3.5

-- InfestationMixing enhancements
function InfestationMixin:CleanupInfestation()

    for i = 1, #self.infestationPatches do
    
        local infestation = self.infestationPatches[i]
        infestation:Uninitialize()
    
    end
	
    self.infestationPatches = {}
    self.infestationGenerated = false

end

-- Nice vanilla bug
function InfestationMixin:GetCurrentInfestationRadius()

    if self.infestationRadius == self.desiredInfestationRadius then
        return self.desiredInfestationRadius
    end

    local growthRateMultiplier = self.desiredInfestationRadius < self.infestationRadius and gInfestationRecedeMultiplier or 1
    if self.GetInfestationRateMultiplier then
        growthRateMultiplier = growthRateMultiplier * self:GetInfestationRateMultiplier()
    end

    local growth = (Shared.GetTime() - self.infestationChangeTime) * self.growthRate * growthRateMultiplier
    local radius = Slerp(self.infestationRadius, self.desiredInfestationRadius, growth)
    return radius

end