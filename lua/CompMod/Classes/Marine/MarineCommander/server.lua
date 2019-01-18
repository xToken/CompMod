-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Marine\MarineCommander\server.lua
-- - Dragon

local originalMarineCommanderCopyPlayerDataFrom
originalMarineCommanderCopyPlayerDataFrom = Class_ReplaceMethod("MarineCommander", "CopyPlayerDataFrom",
    function(self, player)
        originalMarineCommanderCopyPlayerDataFrom(self, player)
        
        if GetGamerules():GetGameStarted() then
            self.utilitySlot3 = player.utilitySlot3 or kTechId.None
            self.utilitySlot5 = player.utilitySlot5 or kTechId.None
            self.grenadesLeft = nil
            self.grenadeType = nil
        end
        
    end
)

local GetIsEquipment = GetUpValue(MarineCommander.ProcessTechTreeActionForEntity, "GetIsEquipment")
local SelectNearest = GetUpValue(MarineCommander.ProcessTechTreeActionForEntity, "SelectNearest")
local GetIsDroppack = GetUpValue(MarineCommander.ProcessTechTreeActionForEntity, "GetIsDroppack")

-- check if a notification should be send for successful actions
function MarineCommander:ProcessTechTreeActionForEntity(techNode, position, normal, pickVec, orientation, entity, trace, targetId)

    local techId = techNode:GetTechId()
    local success = false
    local keepProcessing = false
    
    if techId == kTechId.Scan then
    
        success = self:TriggerScan(position, trace)
        keepProcessing = false
        
    elseif techId == kTechId.SelectObservatory then
        
        SelectNearest(self, "Observatory")
        
    elseif techId == kTechId.NanoShield then
    
        success = self:TriggerNanoShield(position)
        keepProcessing = false
        
    elseif techId == kTechId.PowerSurge then
    
        success = self:TriggerPowerSurge(position, entity, trace)   
        keepProcessing = false 
     
    elseif GetIsDroppack(techId) then
    
        -- use the client side trace.entity here
        local clientTargetEnt = Shared.GetEntity(targetId)
        if clientTargetEnt and ( clientTargetEnt:isa("Marine") or ( techId == kTechId.CatPack and clientTargetEnt:isa("Exo") ) ) then
            position = clientTargetEnt:GetOrigin() + Vector(0, 0.05, 0)
        end

        -- disallow dropping packs onto hives/techpoints.  You can still drop packs ON marines above a hive/techpoint however
        if clientTargetEnt and (clientTargetEnt:isa("Hive") or clientTargetEnt:isa("TechPoint") or clientTargetEnt:isa("Harvester") or clientTargetEnt:isa("ResourcePoint")) then
            return false, false
        end
    
        success = self:TriggerDropPack(position, techId)
        keepProcessing = false
        
    elseif GetIsEquipment(techId) then
    
        success = self:AttemptToBuild(techId, position, normal, orientation, pickVec, false, entity)
    
        if success then
            self:TriggerEffects("spawn_weapon", { effecthostcoords = Coords.GetTranslation(position) })
        end    
            
        keepProcessing = false
    else

        return Commander.ProcessTechTreeActionForEntity(self, techNode, position, normal, pickVec, orientation, entity, trace, targetId)

    end

    if success then

        self:ProcessSuccessAction(techId)

        local location = GetLocationForPoint(position)
        local locationName = location and location:GetName() or ""
        self:TriggerNotification(Shared.GetStringIndex(locationName), techId)

    end
    
    return success, keepProcessing

end