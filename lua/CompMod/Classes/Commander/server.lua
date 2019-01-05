-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Commander\server.lua
-- - Dragon

function Commander:TrackedEntityUpdate(techId, newCount)
    -- Do nothing here
end

local function OrderIdRequiresVisibility(orderTechId)
    return orderTechId == kTechId.Attack
end

local Commander_PrePlaceBuildings = GetUpValue(Commander.OrderEntities, "Commander_PrePlaceBuildings")

local originalCommanderOrderEntities
originalCommanderOrderEntities = Class_ReplaceMethod("Commander", "OrderEntities",
    function(self, orderTechId, trace, orientation, targetId, shiftDown)
        local invalid = false
        
        if not targetId then
            targetId = Entity.invalidId
        end
        
        if targetId == Entity.invalidId and trace.entity then
            targetId = trace.entity:GetId()
        end        
        
        if trace.fraction < 1 then

            -- Give order to selection
            local orderEntities = self:GetSelection()        
            local orderTechIdGiven = orderTechId
            local origPlaces = #orderEntities > 1 and Commander_PrePlaceBuildings(trace.endPoint, math.min(15, #orderEntities)) or {trace.endPoint}
            local target = Shared.GetEntity(targetId)

            for tableIndex, entity in ipairs(orderEntities) do

                if HasMixin(entity, "Orders") and (not target or not OrderIdRequiresVisibility(orderTechId) or GetCanSeeEntity(entity, target, true)) then

                    local orig = (origPlaces and #origPlaces > 0) and origPlaces[(tableIndex % #origPlaces) + 1] or trace.endPoint
                    local type = entity:GiveOrder(orderTechId, targetId, orig, orientation, not shiftDown, false)

                    if type == kTechId.None then
                        invalid = true
                    end
                    
                 else
                    invalid = true
                 end
                
            end
            
            self:OnOrderEntities(orderTechIdGiven, orderEntities)
            
        end
        
        if invalid then
            self:TriggerInvalidSound()   
        end
    end
)