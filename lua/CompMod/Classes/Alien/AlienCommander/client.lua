-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Alien\AlienCommander\client.lua
-- - Dragon

local originalAlienCommanderSendTargetedAction
originalAlienCommanderSendTargetedAction = Class_ReplaceMethod("AlienCommander", "SendTargetedAction",
    function(self, techId, normalizedPickRay, orientation, entity)
        local requiresSecondPlacementAction = LookupTechData(techId, kTechDataRequiresSecondPlacement, false)
        if requiresSecondPlacementAction then
            if self.cachedEntityId then
                self:SendTargetedQueueAction(techId, normalizedPickRay, orientation, self.cachedEntityId)
                self.cachedEntityId = nil
            elseif entity and GetEchoTeleportTechIdForClassname(entity:GetClassName()) then
                self.cachedEntityId = entity:GetId()
                self.lastTeleportTechId = GetEchoTeleportTechIdForClassname(entity:GetClassName())
                self.lastTeleportTechIdStore = 2
            end
        else
            originalAlienCommanderSendTargetedAction(self, techId, normalizedPickRay, orientation, entity)
        end
    end
)

function AlienCommander:SendTargetedQueueAction(techId, normalizedPickRay, orientation, entityId)

    --Print("AlienCommander:SendTargetedQueueAction(%s)", EnumToString(kTechId, techId))

    local orientation = ConditionalValue(orientation, orientation, math.random() * 2 * math.pi)
    local message = BuildCommTargetedActionMessage(techId, normalizedPickRay.x, normalizedPickRay.y, normalizedPickRay.z, orientation, entityId, self.shiftDown)
    Client.SendNetworkMessage("CommTargetedAction", message, true)
    self.timeLastTargetedAction = Shared.GetTime()
    self:SetCurrentTech(kTechId.None)
    self.lastUsedTech = techId

end

local originalAlienCommanderSetCurrentTech
originalAlienCommanderSetCurrentTech = Class_ReplaceMethod("AlienCommander", "SetCurrentTech",
    function(self, techId)
        -- This is kinda hacky, but in the callbacks for commander mouse clicks, a click on the world space with a tech
        -- selected causes it to clear the stored tech.  We want to store a tech ID so that we can directly place the tech ID stored
        -- without having to click on the UI again :<
        -- Replacing the entire file would be easier, but more cumbersome as well.
        self.lastTeleportTechIdStore = math.max(self.lastTeleportTechIdStore and self.lastTeleportTechIdStore - 1 or 0, 0)
        if self.lastTeleportTechIdStore == 0 then
            self.lastTeleportTechId = kTechId.None
        end
        -- Also, if we cancel and then select echo again, clear and caching!
        if techId == kTechId.TeleportStructure then
            self.cachedEntityId = nil
            self.lastTeleportTechId = kTechId.None
            self.lastTeleportTechIdStore = 0
        end
        originalAlienCommanderSetCurrentTech(self, techId)
    end
)