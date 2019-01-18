-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Marine\PowerPoint\replace.lua
-- - Dragon

Script.Load("lua/Mixins/ClientModelMixin.lua")
Script.Load("lua/GameEffectsMixin.lua")
Script.Load("lua/UnitStatusMixin.lua")

Script.Load("lua/ScriptActor.lua")
Script.Load("lua/MapBlipMixin.lua")
Script.Load("lua/CommanderGlowMixin.lua")

local kDefaultUpdateRange = 100
local kPrimeSoundThresholds = { 0.85, 0.9, 0.94, 0.97, 0.99, 1 }

if Client then

    -- The default update range; if the local player is inside this range from the powerpoint, the
    -- lights will update. As the lights controlled by a powerpoint can be located quite far from the powerpoint,
    -- and the area lit by the light even further, this needs to be set quite high.
    -- The powerpoint cycling is also very efficient, so there is no need to keep it low from a performance POV.
    
    function UpdatePowerPointLights()
    
        PROFILE("PowerPoint:UpdatePowerPointLights")
        
        -- Now update the lights every frame
        local player = Client.GetLocalPlayer()
        if player then
        
            local playerPos = player:GetOrigin()
            local range = kDefaultUpdateRange

            if player:isa("Commander") then
                range = range * 10
            end

            local powerPoints = GetEntitiesWithinRange("PowerPoint", playerPos, range)
            
            for i = 1, #powerPoints do

                local powerPoint = powerPoints[i]
                powerPoint:UpdatePoweredLights()
                
            end
            
        end
        
    end
    
end

class 'PowerPoint' (ScriptActor)

if Client then
    Script.Load("lua/PowerPoint_Client.lua")
end

PowerPoint.kMapName = "power_point"

local kUnsocketedSocketModelName = PrecacheAsset("models/system/editor/power_node_socket.model")
local kUnsocketedAnimationGraph

local kSocketedModelName = PrecacheAsset("models/system/editor/power_node.model")
PrecacheAsset("models/marine/powerpoint_impulse/powerpoint_impulse.dds")
PrecacheAsset("models/marine/powerpoint_impulse/powerpoint_impulse.material")
PrecacheAsset("models/marine/powerpoint_impulse/powerpoint_impulse.model")

local kSocketedAnimationGraph = PrecacheAsset("models/system/editor/power_node.animation_graph")

local kDamagedEffect = PrecacheAsset("cinematics/common/powerpoint_damaged.cinematic")
local kOfflineEffect = PrecacheAsset("cinematics/common/powerpoint_offline.cinematic")

local kAlmostReady = PrecacheAsset("sound/NS2.fev/common/arrow")
local kAlmostReadyVolume = 0.5

local kTakeDamageSound = PrecacheAsset("sound/NS2.fev/marine/power_node/take_damage")
local kDamagedSound = PrecacheAsset("sound/NS2.fev/marine/power_node/damaged")
local kDestroyedSound = PrecacheAsset("sound/NS2.fev/marine/power_node/destroyed")
local kDestroyedPowerDownSound = PrecacheAsset("sound/NS2.fev/marine/power_node/destroyed_powerdown")
local kAuxPowerBackupSound = PrecacheAsset("sound/NS2.fev/marine/power_node/backup")

PrecacheAsset("shaders/PowerNode_emissive.surface_shader")

local kNoPowertoLowPower = 15
local kLowerPowertoFullPower = 60

PowerPoint.kPowerState = enum( { "unsocketed", "socketed", "destroyed", "infested" } )

local networkVars =
{
    lightMode = "enum kLightMode",
    powerState = "enum PowerPoint.kPowerState",
    timeOfLightModeChange = "time",
    occupiedTeam = string.format("integer (-1 to %d)", kSpectatorIndex),
    attachedId = "entityid"
}

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ClientModelMixin, networkVars)
AddMixinNetworkVars(GameEffectsMixin, networkVars)

function PowerPoint:OnCreate()

    ScriptActor.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ClientModelMixin)
    InitMixin(self, GameEffectsMixin)
    
    if Client then
        InitMixin(self, CommanderGlowMixin)
    end
    
    self:SetLagCompensated(false)
    self:SetPhysicsType(PhysicsType.Kinematic)
    self:SetPhysicsGroup(PhysicsGroup.BigStructuresGroup)

    if Client then 
        self:AddTimedCallback(PowerPoint.OnTimedUpdate, kUpdateIntervalLow)
    end
    
end

function PowerPoint:OnInitialized()

    ScriptActor.OnInitialized(self)
    
    if Server then

        self:SetModel(kUnsocketedSocketModelName, kUnsocketedAnimationGraph)
    
        self.lightMode = kLightMode.Normal
        self.powerState = PowerPoint.kPowerState.unsocketed
        self.timeOfLightModeChange = 0
        self.occupiedTeam = 0
        
        self:SetRelevancyDistance(Math.infinity)
        self:SetExcludeRelevancyMask(bit.bor(kRelevantToTeam1, kRelevantToTeam2))

    elseif Client then
    
        InitMixin(self, UnitStatusMixin)
        
    end
    
end

function PowerPoint:RequirePrimedNodes()
    return false
end

function PowerPoint:GetDamagedAlertId()
    return kTechId.MarineAlertStructureUnderAttack
end

function PowerPoint:Reset()
    
    self:OnInitialized()
    
    self:ClearAttached()
    
end

function PowerPoint:OnAttached(entity)
    self.occupiedTeam = entity:GetTeamNumber()
    --entity:SetCoords(self:GetCoords())
    if entity.CustomAttach then
        entity:CustomAttach(self)
    end
end

function PowerPoint:OnDetached()
    self.occupiedTeam = 0
end

function PowerPoint:SocketPowerNode()
    
    self:StopSound(kDestroyedPowerDownSound)
    self:StopDamagedSound()
    self:PlaySound(kAuxPowerBackupSound)
    
    self:SetInternalPowerState(PowerPoint.kPowerState.socketed)
    self:SetLightMode(kLightMode.Normal)

end

function PowerPoint:InfestPowerNode()
    
    self:StopSound(kAuxPowerBackupSound)
    self:StopDamagedSound()
    self:PlaySound(kDestroyedPowerDownSound)

    self:SetInternalPowerState(PowerPoint.kPowerState.infested)
    self:SetLightMode(kLightMode.NoPower)

end

function PowerPoint:ClearAttachedNode()

    self:StopDamagedSound()
    
    self:SetInternalPowerState(PowerPoint.kPowerState.unsocketed)
    self:SetLightMode(kLightMode.LowPower)

end

function PowerPoint:GetPowerState()
    return self.powerState
end

function PowerPoint:GetIsSocketed()
    return self:GetPowerState() == PowerPoint.kPowerState.socketed
end

function PowerPoint:GetIsInfested()
    return self:GetPowerState() == PowerPoint.kPowerState.infested
end

function PowerPoint:SetLightMode(lightMode)

    if self.lightMode ~= lightMode then
        self.lastLightMode, self.lightMode = self.lightMode, lightMode        
        self.timeOfLightModeChange = time
    end
    
end

function PowerPoint:GetIsMapEntity()
    return true
end

function PowerPoint:GetLightMode()
    return self.lightMode
end

function PowerPoint:GetTimeOfLightModeChange()
    return self.timeOfLightModeChange
end

function PowerPoint:OverrideVisionRadius()
    return 2
end

-- Nice hardcoded refs...
function PowerPoint:GetIsPowering()
    return true
end

function PowerPoint:GetIsBuilt()
    return false
end

function PowerPoint:GetIsDisabled()
    return false
end

function PowerPoint:OnGetMapBlipInfo()
    return true, kMinimapBlipType.PowerPoint
end

function PowerPoint:SetConstructionComplete()
end

function PowerPoint:GetHealthScalar()
    return 1
end

function PowerPoint:GetBuiltFraction()
    return 1
end

if Server then
    
    function PowerPoint:SetInternalPowerState(powerState)
        
        self.powerState = powerState
        
    end
    
    function PowerPoint:StopDamagedSound()
    
        if self.playingLoopedDamaged then
        
            self:StopSound(kDamagedSound)
            self.playingLoopedDamaged = false
            
        end
        
    end

    function PowerPoint:OnUpdate(deltaTime)
        
        if self:GetLightMode() == kLightMode.NoPower and self.timeOfLightModeChange + kNoPowertoLowPower < Shared.GetTime() then
            self:SetLightMode(kLightMode.LowPower)
        end

        if self:GetLightMode() == kLightMode.LowPower and self.timeOfLightModeChange + kLowerPowertoFullPower < Shared.GetTime() then
            self:SetLightMode(kLightMode.Normal)
        end
                
    end
    
end

local function CreateEffects(self)

    -- Create looping cinematics if we're low power or no power
    local lightMode = self:GetLightMode() 
    
    if lightMode == kLightMode.LowPower and not self.lowPowerEffect then
    
        self.lowPowerEffect = Client.CreateCinematic(RenderScene.Zone_Default)
        self.lowPowerEffect:SetCinematic(kDamagedEffect)        
        self.lowPowerEffect:SetRepeatStyle(Cinematic.Repeat_Endless)
        self.lowPowerEffect:SetCoords(self:GetCoords())
        self.timeCreatedLowPower = Shared.GetTime()
        
    elseif lightMode == kLightMode.NoPower and not self.noPowerEffect then
    
        self.noPowerEffect = Client.CreateCinematic(RenderScene.Zone_Default)
        self.noPowerEffect:SetCinematic(kOfflineEffect)
        self.noPowerEffect:SetRepeatStyle(Cinematic.Repeat_Endless)
        self.noPowerEffect:SetCoords(self:GetCoords())
        self.timeCreatedNoPower = Shared.GetTime()
        
    end
    
    if self:GetPowerState() == PowerPoint.kPowerState.socketed and self:GetIsVisible() then

        if self.lastImpulseEffect == nil then
            self.lastImpulseEffect = Shared.GetTime() - PowerPoint.kImpulseEffectFrequency
        end
        
        if self.lastImpulseEffect + PowerPoint.kImpulseEffectFrequency < Shared.GetTime() then
        
            self:CreateImpulseEffect()
            self.createStructureImpulse = true
            
        end
        
        if self.lastImpulseEffect + 1 < Shared.GetTime() and self.createStructureImpulse == true then
        
            self:CreateImpulseStructureEffect()
            self.createStructureImpulse = false
            
        end
        
    end
    
end

local function DeleteEffects(self)

    local lightMode = self:GetLightMode() 
    
    -- Delete old effects when they shouldn't be played any more, and also every three seconds
    local kReplayInterval = 3
    
    if (lightMode ~= kLightMode.LowPower and self.lowPowerEffect) or (self.timeCreatedLowPower and (Shared.GetTime() > self.timeCreatedLowPower + kReplayInterval)) then
    
        Client.DestroyCinematic(self.lowPowerEffect)
        self.lowPowerEffect = nil
        self.timeCreatedLowPower = nil
        
    end
    
    if (lightMode ~= kLightMode.NoPower and self.noPowerEffect) or (self.timeCreatedNoPower and (Shared.GetTime() > self.timeCreatedNoPower + kReplayInterval)) then
    
        Client.DestroyCinematic(self.noPowerEffect)
        self.noPowerEffect = nil
        self.timeCreatedNoPower = nil
        
    end
    
end

if Client then

    function PowerPoint:OnTimedUpdate(deltaTime)
        CreateEffects(self)
        DeleteEffects(self)
        return true
    end

    function PowerPoint:CreateImpulseStructureEffect()

	    if self.structuresAtLocation then
	    
	        for index, structureId in ipairs(self.structuresAtLocation) do
	        
	            local structure = Shared.GetEntity(structureId)
	        
	            if structure ~= nil and structure.GetIsBuilt and structure:GetIsBuilt() then
	            
	                local structureImpulseEffect = Client.CreateCinematic(RenderScene.Zone_Default)
	                local vec = self:GetOrigin() - structure:GetOrigin()   
	                vec:Normalize()             
	                local angles = Angles(self:GetAngles())
	                
	                angles.yaw = GetYawFromVector(vec)
	                angles.pitch = GetPitchFromVector(vec)
	                
	                
	                local effectCoords = angles:GetCoords()  
	                effectCoords.origin = structure:GetOrigin()
	                
	                structureImpulseEffect:SetCoords(effectCoords)
	                structureImpulseEffect:SetRepeatStyle(Cinematic.Repeat_None)
	                structureImpulseEffect:SetCinematic(PowerPoint.kImpulseAtStructureEffect)
	        
	            end
	        
	        end
	    
	    end

	end

	function PowerPoint:GetShowCrossHairText()
	    return false
	end

	function PowerPoint:GetUnitNameOverride(viewer)
	    return
	end

	function PowerPoint:OnUpdateRender()

	    PROFILE("PowerPoint:OnUpdateRender")

	    if self:GetIsSocketed() then

	        local model = self:GetRenderModel()
	        self:InstanceMaterials()
	        
	        if model then

	            local amount = 0
	            
                local animVal = (math.cos(Shared.GetTime()) + 1) / 2
                amount = 1 + (animVal * 5)
	            model:SetMaterialParameter("emissiveAmount", amount)
	            
	        end
	        
	    end
	    
	end

    PowerPoint.OnUpdatePoseParameters = nil
	
end

function PowerPoint:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = false
    return
end

function PowerPoint:GetShowUnitStatusForOverride()
    return false
end

function PowerPoint:GetHealth()
    return 1
end

function PowerPoint:GetMaxHealth()
    return 1
end

local kPowerPointTargetOffset = Vector(0, 0.3, 0)
function PowerPoint:GetEngagementPointOverride()
    return self:GetCoords():TransformPoint(kPowerPointTargetOffset)
end

Shared.LinkClassToMap("PowerPoint", PowerPoint.kMapName, networkVars)
