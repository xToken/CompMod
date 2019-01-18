-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\MaturityMixin\client.lua
-- - Dragon
  
function MaturityMixin:OnMaturityUpdate(deltaTime)
  
    PROFILE("MaturityMixin:OnMaturityUpdate")
    
    local fraction = 1.0
    -- TODO: maturity effects, shaders
    if HasMixin(self, "Model") then
    
        local model = self:GetRenderModel()
        if model then
            fraction = self:GetMaturityFraction()
            model:SetMaterialParameter("maturity", fraction)
        end
    
     end
     
     return kUpdateIntervalLow
    
end

function MaturityMixin:GetMaturityFraction()
    return self.finalMatureFraction
end

function MaturityMixin:SetUnitState(forEntity, state)
    local areEnemies = GetAreEnemies(player, unit)
    if not areEnemies then
        state.MaturityFraction = self:GetMaturityFraction()
    end
end