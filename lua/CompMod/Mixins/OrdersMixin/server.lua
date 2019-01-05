-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\OrdersMixin\server.lua
-- - Dragon

local oldOrdersMixinOnUpdate = OrdersMixin.OnUpdate
function OrdersMixin:OnUpdate(deltaTime)

    oldOrdersMixinOnUpdate(self, deltaTime)
    local currentOrder = self:GetCurrentOrder()
    if currentOrder and (self.lastInvalidOrderCheck or 0) + 1 < Shared.GetTime() then

        local orderType = currentOrder:GetType()
        if orderType == kTechId.Attack then
            
            local orderTarget = Shared.GetEntity(currentOrder:GetParam())
            if orderTarget and (orderTarget:isa("Player") and not orderTarget:GetIsSighted()) then
                -- Targeted player that is no longer visible, clear
                self:ClearOrders()
            end
            
        elseif orderType == kTechId.Defend then
        
            local orderTarget = Shared.GetEntity(currentOrder:GetParam())
            if orderTarget and GetAreEnemies(self, orderTarget) then
                -- We cant defend enemies...
                self:ClearOrders()
            end
            
        end
        self.lastInvalidOrderCheck = Shared.GetTime()

    end

end