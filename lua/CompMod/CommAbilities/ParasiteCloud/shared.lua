-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\CommAbilities\ParasiteCloud\shared.lua
-- - Dragon

Script.Load("lua/CommAbilities/CommanderAbility.lua")

class 'ParasiteCloud' (CommanderAbility)

ParasiteCloud.kMapName = "parasitecloud"

ParasiteCloud.kEffect = PrecacheAsset("cinematics/alien/drifter/stormcloud.cinematic")

ParasiteCloud.kLifetime = kParasiteCloudLifetime
ParasiteCloud.kRadius = kParasiteCloudDetectRadius
ParasiteCloud.kMaxRange = kParasiteCloudRange
ParasiteCloud.kTravelSpeed = 6

local kUpdateTime = 0.25

local networkVars =
{
    destination = "vector"
}

function ParasiteCloud:GetRepeatCinematic()
    return ParasiteCloud.kEffect
end

function ParasiteCloud:GetType()
    return CommanderAbility.kType.Repeat
end
    
function ParasiteCloud:GetLifeSpan()
    return ParasiteCloud.kLifetime
end

function ParasiteCloud:SetTravelDestination(position)
    self.destination = position
end

-- called client side
function ParasiteCloud:GetRepeatingEffectCoords()

    if not self.travelCoords then
    
        local travelDirection = self.destination - self:GetOrigin()
        if travelDirection:GetLength() > 0 then
            
            self.travelCoords = Coords.GetIdentity()
            self.travelCoords.origin = self:GetOrigin()
            
            self.travelCoords.zAxis = GetNormalizedVector(travelDirection)
            self.travelCoords.xAxis = self.travelCoords.yAxis:CrossProduct(self.travelCoords.zAxis)
            self.travelCoords.yAxis = self.travelCoords.zAxis:CrossProduct(self.travelCoords.xAxis)
            
            return self.travelCoords
            
        end
    
    else
    
        self.travelCoords.origin = self:GetOrigin()
        return self.travelCoords
    
    end

end

function ParasiteCloud:GetUpdateTime()
    return kUpdateTime
end

if Server then

    function ParasiteCloud:Perform()
    
        for _, target in ipairs(GetEntitiesWithMixinForTeamWithinRange("ParasiteAble", GetEnemyTeamNumber(self:GetTeamNumber()), self:GetOrigin(), ParasiteCloud.kRadius)) do
            if not target:GetIsParasited() then
                target:SetParasited( self:GetOwner(), kParasiteCloudMarkDuration )
            end
        end
        
    end
    
    function ParasiteCloud:OnUpdate(deltaTime)
    
        CommanderAbility.OnUpdate(self, deltaTime)
        
        if self.destination and not self.doneTraveling then
        
            local travelVector = self.destination - self:GetOrigin()

            if travelVector:GetLength() > 0.3 then
                self:SetOrigin( self:GetOrigin() + GetNormalizedVector(travelVector) * deltaTime * ParasiteCloud.kTravelSpeed )
            else
            
                self.doneTraveling = true
                for _, pCloud in ipairs(GetEntitiesForTeamWithinRange("ParasiteCloud", self:GetTeamNumber(), self:GetOrigin(), ParasiteCloud.kRadius)) do
                    
                    if pCloud ~= self then
                        DestroyEntity(pCloud)
                    end
                    
                end
            
            end
        
        end
    
    end

end

Shared.LinkClassToMap("ParasiteCloud", ParasiteCloud.kMapName, networkVars)