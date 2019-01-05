-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\CommAbilities\NutrientMist\shared.lua
-- - Dragon

NutrientMist.kSearchRange = kNutrientMistRange

function NutrientMist:GetUpdateTime()
    return 2
end

function NutrientMist:Perform()

    self.success = false

    self:TriggerEffects("comm_nutrient_mist")

    local entities = GetEntitiesWithMixinForTeamWithinRange("Catalyst", self:GetTeamNumber(), self:GetOrigin(), NutrientMist.kSearchRange)
    
    for _, entity in ipairs(entities) do

        if not entity:isa("Player") then
        	entity:TriggerCatalyst(2, self:GetId())
        end
        
    end

end