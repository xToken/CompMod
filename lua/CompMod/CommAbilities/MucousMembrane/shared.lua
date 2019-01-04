-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\CommAbilities\MucousMembrane\shared.lua
-- - Dragon

MucousMembrane.kRadius = kMucousMembraneRadius

function MucousMembrane:OnInitialized()
    
    if Server then
        -- sound feedback
        self:TriggerEffects("enzyme_cloud")
        DestroyEntitiesWithinRange("MucousMembrane", self:GetOrigin(), 5, EntityFilterOne(self)) 
    end
    
    CommanderAbility.OnInitialized(self)

end
