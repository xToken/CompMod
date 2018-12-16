-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\EnzymeCloud.lua
-- - Dragon

EnzymeCloud.kRadius = kEnzymeCloudRadius

function EnzymeCloud:OnInitialized()
    
    if Server then
        -- sound feedback
        self:TriggerEffects("enzyme_cloud")
        DestroyEntitiesWithinRange("EnzymeCloud", self:GetOrigin(), 5, EntityFilterOne(self)) 
    end
    
    CommanderAbility.OnInitialized(self)

end