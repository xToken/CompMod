-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\ConstructMixin\shared.lua
-- - Dragon

function ConstructMixin:OnUse(player, elapsedTime, useSuccessTable)

    local used = false

    if not GetIsAlienUnit(self) and self:GetCanConstruct(player) then        

        -- Always build by set amount of time, for AV reasons
        -- Calling code will put weapon away we return true
        local constructInterval = 0
        
        local activeWeapon = player:GetActiveWeapon()
        if activeWeapon and activeWeapon:GetMapName() == Builder.kMapName then
            constructInterval = elapsedTime
        end
        
        local success, playAV = self:Construct(constructInterval, player)
        
        if success then
            used = true
        end
                
    end
    
    useSuccessTable.useSuccess = useSuccessTable.useSuccess or used
    
end