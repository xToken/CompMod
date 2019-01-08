-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\MaturityMixin\server.lua
-- - Dragon

function MaturityMixin:OnMaturityUpdate(deltaTime)
        
    PROFILE("MaturityMixin:OnMaturityUpdate")

    -- Check for first init
    if not self.lastCatalystedTime then
        self.finalMatureFraction = kMaturityStartingLevel
        self.lastCatalystedTime = Shared.GetTime()
        self:UpdateMaturity()
    end
    
    -- Catalyst is required for maturity to do anything now
    if not self.GetIsCatalysted then return false end

    -- calculate starvation
    local updated = self.maturitygain
    local level = self:GetMaturityLevel()
    local rate = 0
    if self:GetIsCatalysted() then
    	-- Gain maturity
    	self.maturitygain = true
    	rate = self:GetMaturationRate()
        self.lastCatalystedTime = Shared.GetTime()
    else
    	if self.lastCatalystedTime + kMaturityGracePeriod < Shared.GetTime() then
    		-- Start losing maturity
    		rate = self:GetStarvationRate()
    		self.maturitygain = false
    	else
    		-- Not gaining, but not losing yet
    		self.maturitygain = true
    		rate = 0
    	end
    end
    
    rate = (not HasMixin(self, "Construct") or self:GetIsBuilt()) and rate or 0

    self.finalMatureFraction = Clamp(self.finalMatureFraction + deltaTime * rate, 0, 1)

    if level ~= self:GetMaturityLevel() then
        if self.OnMaturityLevelUpdated then
            self:OnMaturityLevelUpdated(level, self:GetMaturityLevel())
        end
    end

    local isMature = self.matureFraction == 1.0
    
    -- to prevent too much network spam from happening we update only every second the max health
    if isMature or updated ~= self.maturitygain or (self.timeMaturityLastUpdate + 1 < Shared.GetTime()) then
    
        self:UpdateMaturity()
        self.timeMaturityLastUpdate = Shared.GetTime()
        
    end
    
    return true
    
end