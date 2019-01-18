-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Marine\FlameCloud\shared.lua
-- - Dragon

Script.Load("lua/TeamMixin.lua")
Script.Load("lua/OwnerMixin.lua")
Script.Load("lua/DamageMixin.lua")
Script.Load("lua/EffectsMixin.lua")
Script.Load("lua/EntityChangeMixin.lua")

class 'FlameCloud' (Entity)

FlameCloud.kMapName = "flamecloud"

FlameCloud.kFireEffect = PrecacheAsset("cinematics/marine/flamethrower/burning_surface.cinematic")

local kDamageInterval = 0.25

local gHurtByFlames = { }

FlameCloud.kMaxRange = 12
FlameCloud.kTravelSpeed = 8 --m/s
FlameCloud.kConeWidth = 0.25
FlameCloud.kGravity = -1
FlameCloud.kMaxTrackedVectors = 100
FlameCloud.kMaxLifetime = 20

local networkVars = { destination1 = "vector" }

for i = 1, FlameCloud.kMaxTrackedVectors do
    --networkVars[destination..ToString(i)] = "vector"
end

AddMixinNetworkVars(TeamMixin, networkVars)

function FlameCloud:OnCreate()

    Entity.OnCreate(self)
    
    InitMixin(self, TeamMixin)
    InitMixin(self, DamageMixin)
    InitMixin(self, EffectsMixin)
    InitMixin(self, EntityChangeMixin)
    InitMixin(self, LOSMixin)
    
    if Server then
    
        InitMixin(self, OwnerMixin)
        
        self.nextDamageTime = 0
        
    end
    
    self:SetUpdates(true)
    
    self.createTime = Shared.GetTime()

    self.endOfDamageTime = self.createTime + FlameCloud.kMaxLifetime  
    self.destroyTime = self.endOfDamageTime + 2

end

function FlameCloud:SetInitialDestination(dest)
    self.destination1 = dest
    self.source1 = self:GetOrigin()
end

function FlameCloud:AddIntermediateDestination(origin, dest)
    for i = 1, FlameCloud.kMaxTrackedVectors do
        if not self["destination"..ToString(i)] then
            self["destination"..ToString(i)] = dest
            self["source"..ToString(i)] = origin
            break
        end
    end
end

function FlameCloud:FinishedFiring()
    self.finishedFiring = true
end

function FlameCloud:OnDestroy()
    Entity.OnDestroy(self)
    
    if Client then
        if self.flameEffect then
            Client.DestroyCinematic(self.flameEffect)
            self.flameEffect = nil        
        end
    end
    
end


local function GetEntityRecentlyHurt(entityId, time)

    for index, pair in ipairs(gHurtByFlames) do
        if pair[1] == entityId and pair[2] > time then
            return true
        end
    end
    
    return false
    
end

local function SetEntityRecentlyHurt(entityId)

    for index, pair in ipairs(gHurtByFlames) do
        if pair[1] == entityId then
            table.remove(gHurtByFlames, index)
        end
    end
    
    table.insert(gHurtByFlames, {entityId, Shared.GetTime()})
    
end

function FlameCloud:GetDamageType()
    return kDamageType.Normal
end

function FlameCloud:GetDeathIconIndex()
    return kDeathMessageIcon.Flamethrower
end

function FlameCloud:GetDamageRadius()
    return FlameCloud.kFlameRadius
end

function FlameCloud:GetShowHitIndicator()
    return true
end

function FlameCloud:GetMeleeOffset()
    return 0.0
end

function FlameCloud:FlameDamage(locations, time, enemies)

    local damageRadius = self:GetDamageRadius()
    
    for i =1, #enemies do

        if not enemies[i]:isa("Commander") and not GetEntityRecentlyHurt(enemies[i]:GetId(), (time - kDamageInterval)) then
            
            self:DoDamage(kFlamethrowerDamagePerSecond * kDamageInterval, enemies[i], locations[i], nil, "flame" )
            
            SetEntityRecentlyHurt(enemies[i]:GetId())
        end
        
    end
end

function FlameCloud:OnUpdate(deltaTime)

    local time = Shared.GetTime()

    if Client then
        if self.destination and not self.flameSpawnEffect then
            self.flameSpawnEffect = Client.CreateCinematic(RenderScene.Zone_Default)
            self.flameSpawnEffect:SetCinematic(FlameCloud.kFireEffect)
            self.flameSpawnEffect:SetRepeatStyle(Cinematic.Repeat_Endless)
            
            local coords = Coords.GetIdentity()
            coords.origin = self:GetOrigin()
            coords.zAxis = GetNormalizedVector(self:GetOrigin()-self.destination)
            coords.xAxis = GetNormalizedVector(coords.yAxis:CrossProduct(coords.zAxis))
            coords.yAxis = coords.zAxis:CrossProduct(coords.xAxis)
            
            self.flameSpawnEffect:SetCoords(coords)
        end
    
    end
    
    if Server then

        local damageTime = false
        local extents = Vector(self.kConeWidth, self.kConeWidth, self.kConeWidth)
        local filterEnts = {self, self:GetOwner()}
        local ents = { }
        local damageLocations = { }
        local originSet = false
        if time > self.nextDamageTime and time < self.endOfDamageTime then
            damageTime = true
            self.nextDamageTime = time + kDamageInterval
        end
        
        if not self.doneTraveling then
            local allFinished = true
            for i = 1, FlameCloud.kMaxTrackedVectors do
                if not self["doneTraveling"..ToString(i)] then
                    if self["destination"..ToString(i)] then
                        local dest = self["destination"..ToString(i)]
                        local origin = self["source"..ToString(i)]
                        local travelDistance = dest - origin
                        local travelVector = GetNormalizedVector(travelDistance)
                        local remainingRange = deltaTime * FlameCloud.kTravelSpeed
                        local startPoint = origin
                        if travelDistance:GetLengthSquared() > 0.1 then
                            local trace = TraceMeleeBox(self, startPoint, travelVector, extents, remainingRange, PhysicsMask.Flame, EntityFilterList(filterEnts))
                            local endPoint = trace.endPoint
                            if trace.fraction ~= 1 then
                                local traceEnt = trace.entity
                                if traceEnt and HasMixin(traceEnt, "Live") and traceEnt:GetCanTakeDamage() then
                                    table.insert(ents, traceEnt)
                                    table.insert(damageLocations, endPoint)
                                end
                            end
                            origin = endPoint + Vector(0, FlameCloud.kGravity, 0) * deltaTime
                            self["destination"..ToString(i)] = self["destination"..ToString(i)] + Vector(0, FlameCloud.kGravity, 0) * deltaTime
                            self["source"..ToString(i)] = origin
                            if not originSet then
                                self:SetOrigin(self["source"..ToString(i)])
                                originSet = true
                            end
                            allFinished = false
                        else
                            self["doneTraveling"..ToString(i)] = true
                        end
                    else
                        break
                    end
                else
                    allFinished = allFinished and true
                end
            end
            if allFinished and self.finishedFiring then
                self.doneTraveling = true
            end            
        end

        if damageTime then
            self:FlameDamage(damageLocations, time, ents)
        end

        if  time > self.destroyTime then
            DestroyEntity(self)
        end
        
    elseif Client then
        
        local coords = Coords.GetIdentity()
        coords.origin = self:GetOrigin()
        
        if self.flameEffect then
            self.flameEffect:SetCoords( coords )            
        else
        
            self.flameEffect = Client.CreateCinematic(RenderScene.Zone_Default)
            
            self.flameEffect:SetCinematic( FlameCloud.kFireEffect )
            self.flameEffect:SetRepeatStyle(Cinematic.Repeat_Endless)
            self.flameEffect:SetCoords( coords )
        
        end
    
    end
    
end

if Client then
    
    function FlameCloud:OnUpdateRender()
        
        if self.flameSpawnEffect and self.destination then
            local coords = Coords.GetIdentity()
            coords.origin = self:GetOrigin()
            coords.zAxis = GetNormalizedVector(self:GetOrigin()-self.destination)
            coords.xAxis = GetNormalizedVector(coords.yAxis:CrossProduct(coords.zAxis))
            coords.yAxis = coords.zAxis:CrossProduct(coords.xAxis)
            
            self.flameSpawnEffect:SetCoords(coords)
        end
        
    end
    
end

function FlameCloud:GetRemainingLifeTime()
    return math.min(0, self.endOfDamageTime - Shared.GetTime())
end

Shared.LinkClassToMap("FlameCloud", FlameCloud.kMapName, networkVars)