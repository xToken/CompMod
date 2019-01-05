-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\AlienSensorBlip\shared.lua
-- - Dragon


Script.Load("lua/MinimapMappableMixin.lua")

class 'AlienSensorBlip' (Entity)

AlienSensorBlip.kMapName = "aliensensorblip"

local networkVars =
{
    entId       = "entityid"
}

function AlienSensorBlip:OnCreate()

    Entity.OnCreate(self)
    
    self.entId    = Entity.invalidId
    
    self:UpdateRelevancy()
    
    if Client then
        InitMixin(self, MinimapMappableMixin)
    end
    
end

function AlienSensorBlip:UpdateRelevancy()

    self:SetRelevancyDistance(Math.infinity)
    self:SetExcludeRelevancyMask(kRelevantToTeam2)
    
end

function AlienSensorBlip:Update(entity)

    if entity.GetEngagementPoint then
        self:SetOrigin(entity:GetEngagementPoint())
    else
        self:SetOrigin(entity:GetModelOrigin())
    end
    
    self.entId = entity:GetId()
    
end


if Client then
  
    function AlienSensorBlip:GetMapBlipType()
        return kMinimapBlipType.SensorBlip
    end
    
    function AlienSensorBlip:GetMapBlipColor(minimap, item)
        return item.blipColor
    end
    
    function AlienSensorBlip:GetMapBlipTeam(minimap)
        return kMinimapBlipTeam.Enemy
    end
    
    function AlienSensorBlip:UpdateMinimapActivity(minimap, item)      
        local origin = self:GetOrigin()
        local isMoving = item.prevOrigin ~= origin
        item.prevOrigin = origin
        return (isMoving and kMinimapActivity.Medium) or kMinimapActivity.Static
    end

end -- Client


Shared.LinkClassToMap("AlienSensorBlip", AlienSensorBlip.kMapName, networkVars)