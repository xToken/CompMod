-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\InfestationMixin\shared.lua
-- - Dragon

local gInfestationMultiplier = 1
local gInfestationRecedeMultiplier = 3

function InfestationMixin:__initmixin()
    
    PROFILE("InfestationMixin:__initmixin")
    
    self.growthRate = self:GetInfestationGrowthRate() * gInfestationMultiplier
    self.desiredInfestationRadius = 0
    self.infestationPatches = { }
    self.infestationRadius = 0
    self.infestationChangeTime = Shared.GetTime()
    
    self:AddTimedCallback(InfestationMixin.UpdateInfestation, 0)
    if Client then
        self:AddFieldWatcher("infestationReset", InfestationMixin.CleanupInfestation)
    end
end

-- InfestationMixing enhancements
function InfestationMixin:CleanupInfestation()

    for i = 1, #self.infestationPatches do
    
        local infestation = self.infestationPatches[i]
        infestation:Uninitialize()
    
    end

    self.infestationPatches = { }
    self.infestationGenerated = false

end

function InfestationMixin:OnKill(attacker, doer, point, direction)
    
    -- trigger receed
    self:SetDesiredInfestationRadius(0)

end

-- Nice vanilla bug
function InfestationMixin:GetCurrentInfestationRadius()

    if self.infestationRadius == self.desiredInfestationRadius then
        return self.desiredInfestationRadius
    end

    local growthRateMultiplier = self.desiredInfestationRadius < self.infestationRadius and gInfestationRecedeMultiplier or 1
    if self.GetInfestationRateMultiplier then
        growthRateMultiplier = growthRateMultiplier * self:GetInfestationRateMultiplier()
    end

    local growth = (Shared.GetTime() - self.infestationChangeTime) * self.growthRate * growthRateMultiplier
    local radius = Slerp(self.infestationRadius, self.desiredInfestationRadius, growth)
    return radius

end

local kUpdateInterval = 0.5
local kGrowingUpdateInterval = 0.025 -- 40 Hz should be smooth enough

function InfestationMixin:UpdateInfestation(deltaTime)
    
    PROFILE("InfestationMixin:UpdateInfestation")

    if self.allowDestruction then return false end

    local needsInfestation = (not HasMixin(self, "Construct") or self:GetIsBuilt()) and (not self.ShouldGenerateInfestation or self:ShouldGenerateInfestation())
    
    if needsInfestation and not self.infestationGenerated then
        local r = self:GetCurrentInfestationRadius()
        local t = self.infestationChangeTime
        self:CreateInfestation()
        -- CreateInfestation resets the radius/time, but it might be fully grown.  The server would be networking us the correct value, we just ignore it on the first update
        -- because of this.  So cache the values and restore after
        if Client then
            --self.infestationRadius = r
            --self.infestationChangeTime = t -- Disable this unless we start using the placeholder ent for these
        end
        self.desiredInfestationRadius = self:GetInfestationMaxRadius()
    end
    
    local playerIsEnemy = Client and GetAreEnemies(self, Client.GetLocalPlayer()) or false
    local cloakFraction = (playerIsEnemy and HasMixin(self, "Cloakable")) and self:GetCloakFraction() or 0
    local radius = self:GetCurrentInfestationRadius()
    local isOverHead = Client and PlayerUI_IsOverhead()
    local visible = self:GetIsVisible()
    
    -- update infestation patches
    for i = 1, #self.infestationPatches do
    
        local infestation = self.infestationPatches[i]

        infestation:SetRadius(radius)
        
        if Client then
            infestation:SetCloakFraction(cloakFraction)
            infestation:SetIsVisible(visible and (not isOverHead or infestation.coords.yAxis.y > 0.55))
        end
    
    end

    if (not HasMixin(self, "Live") or not self:GetIsAlive()) and radius == 0 then        
        self.allowDestruction = true
    end
    
    self.currentInfestationRadius = radius
    -- if we have reached our full radius, we can update less often
    return radius == self.desiredInfestationRadius and kUpdateInterval or kGrowingUpdateInterval
end

function CreateDestroyedInfestationEntityForEntity(sourceEnt)
    local de = CreateEntity(DestroyedInfestation.kMapName, sourceEnt:GetOrigin(), sourceEnt:GetTeamNumber(), {cachedInfestationMaxRadius = sourceEnt:GetInfestationRadius()})
    de:CopyInfestationParms(sourceEnt)
    sourceEnt.infestationReset = (sourceEnt.infestationReset + 1) % 5
end

local kInfestationCleanupTime = 15

class 'DestroyedInfestation' (Entity)

DestroyedInfestation.kMapName = "destroyedinfestation"

local networkVars = 
{
    cachedInfestationMaxRadius = "integer (0 to 100)"
}

AddMixinNetworkVars(InfestationMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)

function DestroyedInfestation:OnCreate()

    Entity.OnCreate(self)

    InitMixin(self, TeamMixin)

    self:SetRelevancyDistance(kMaxRelevancyDistance)
    --self.cachedInfestationMaxRadius = 25

end

function DestroyedInfestation:OnInitialized()

    InitMixin(self, InfestationMixin)

    Entity.OnInitialized(self)
    
end

function DestroyedInfestation:GetAttached()
    return false
end

function DestroyedInfestation:GetInfestationRadius()
    return self.cachedInfestationMaxRadius
end

function DestroyedInfestation:GetInfestationMaxRadius()
    return self.cachedInfestationMaxRadius
end

function DestroyedInfestation:CopyInfestationParms(sourceEnt)
    local lifeTime = kInfestationCleanupTime
    if sourceEnt:isa("Hive") then
        lifeTime = 35
    end

    self.infestationRadius = sourceEnt:GetCurrentInfestationRadius()
    self.growthRate = sourceEnt.growthRate

    self.infestationPatches = sourceEnt.infestationPatches
    self.infestationGenerated = sourceEnt.infestationGenerated
    self:SetDesiredInfestationRadius(0)

    sourceEnt.infestationPatches = { }
    sourceEnt.infestationGenerated = false

    self:AddTimedCallback(DestroyedInfestation.EndOfLife, lifeTime)
end

function DestroyedInfestation:EndOfLife()
    DestroyEntity(self)
    return false
end

Shared.LinkClassToMap("DestroyedInfestation", DestroyedInfestation.kMapName, networkVars)