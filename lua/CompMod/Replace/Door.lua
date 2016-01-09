// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Replace\Door.lua
// - Dragon

Script.Load("lua/ScriptActor.lua")
Script.Load("lua/Mixins/ClientModelMixin.lua")
Script.Load("lua/PathingMixin.lua")
Script.Load("lua/MapBlipMixin.lua")
Script.Load("lua/CompMod/Predict/PredictAdjustments.lua")

class 'Door' (ScriptActor)

Door.kMapName = "door"

Door.kInoperableSound = PrecacheAsset("sound/NS2.fev/common/door_inoperable")
Door.kOpenSound = PrecacheAsset("sound/NS2.fev/common/door_open")
Door.kCloseSound = PrecacheAsset("sound/NS2.fev/common/door_close")
Door.kLockSound = PrecacheAsset("sound/NS2.fev/common/door_lock")
Door.kUnlockSound = PrecacheAsset("sound/NS2.fev/common/door_unlock")

Door.kState = enum( {'Open', 'Close' } )
Door.kStateSound = { [Door.kState.Open] = Door.kOpenSound, 
                     [Door.kState.Close] = Door.kCloseSound  }

local kUpdateAutoUnlockRate = 1
local kUpdateAutoOpenRate = 0.3
local kWeldPercentagePerSecond = 1 / kDoorWeldTime
local kHealthPercentagePerSecond = 0.9 / kDoorWeldTime

local kModelNameDefault = PrecacheAsset("models/misc/door/door.model")
local kModelNameClean = PrecacheAsset("models/misc/door/door_clean.model")
local kModelNameDestroyed = PrecacheAsset("models/misc/door/door_destroyed.model")
local kDoorAnimationGraph = PrecacheAsset("models/misc/door/door.animation_graph")

local networkVars =
{
    state = "enum Door.kState"
}

AddMixinNetworkVars(BaseModelMixin, networkVars)

local function UpdateAutoOpen(self, timePassed)

    // If any players are around, have door open if possible, otherwise close it
    local state = self:GetState()
    
    if state == Door.kState.Open or state == Door.kState.Close then
    
        local desiredOpenState = false

        local entities = Shared.GetEntitiesWithTagInRange("Door", self:GetOrigin(), DoorMixin.kMaxOpenDistance)
        for index = 1, #entities do
            
            local entity = entities[index]
            local opensForEntity, openDistance = entity:GetCanDoorInteract(self)
			
            if opensForEntity then
            
                local distSquared = self:GetDistanceSquared(entity)
                if (not HasMixin(entity, "Live") or entity:GetIsAlive()) and entity:GetIsVisible() and distSquared < (openDistance * openDistance) then
                
                    desiredOpenState = true
                    break
                
                end
            
            end
            
        end
		
		if self:GetState() == Door.kState.Open then
			self:ForceUpdateUntil(Shared.GetTime() + kUpdateAutoOpenRate + 0.1)
		end
        
        if desiredOpenState and self:GetState() == Door.kState.Close then
            self:SetState(Door.kState.Open)
        elseif not desiredOpenState and self:GetState() == Door.kState.Open then
            self:SetState(Door.kState.Close)  
        end
        
    end
    
    return true

end

local function ClientUpdateAutoOpen(self)

    local state = self:GetClientState()
    
    if state == Door.kState.Open or state == Door.kState.Close then
    
        local desiredOpenState = false

        local entities = GetEntitiesWithMixinWithinRange("Door", self:GetOrigin(), DoorMixin.kMaxOpenDistance)
        for index = 1, #entities do
            
            local entity = entities[index]
            local opensForEntity, openDistance = entity:GetCanDoorInteract(self)

            if opensForEntity then
            
                local distSquared = self:GetDistanceSquared(entity)
                if (not HasMixin(entity, "Live") or entity:GetIsAlive()) and distSquared < (openDistance * openDistance) then
                    desiredOpenState = true
                    break
                
                end
            
            end
            
        end
        
        if desiredOpenState and state == Door.kState.Close then
            self.clientstate = Door.kState.Open
        elseif not desiredOpenState and state == Door.kState.Open then
            self.clientstate = Door.kState.Close
        end
        
    end

end

local function InitModel(self)

    local modelName = kModelNameDefault
    if self.clean then
        modelName = kModelNameClean
    end
    
    self:SetModel(modelName, kDoorAnimationGraph)
    
end

function Door:OnCreate()

    ScriptActor.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ClientModelMixin)
    InitMixin(self, PathingMixin)
    
	if Server then
	
		self:AddTimedCallback(UpdateAutoOpen, kUpdateAutoOpenRate)
		self.state = Door.kState.Open
		
	else
		self.clientstate = Door.kState.Open
	end
	
end

function Door:OnInitialized()

    ScriptActor.OnInitialized(self)
    
    if Server then
        
        InitModel(self)
        
        self:SetPhysicsType(PhysicsType.Kinematic)
        
        self:SetPhysicsGroup(PhysicsGroup.CommanderUnitGroup)
        
        // This Mixin must be inited inside this OnInitialized() function.
        if not HasMixin(self, "MapBlip") then
            InitMixin(self, MapBlipMixin)
        end
        
    end

    
end

function Door:Reset()
    
    self:SetPhysicsType(PhysicsType.Kinematic)
    self:SetPhysicsGroup(0)
    
    self:SetState(Door.kState.Close)
    
    InitModel(self)
    
end

function Door:GetShowHealthFor(player)
    return false
end

function Door:GetReceivesStructuralDamage()
    return false
end

function Door:GetIsWeldedShut()
    return self:GetState() == Door.kState.Welded
end

function Door:GetDescription()

    local doorName = GetDisplayNameForTechId(self:GetTechId())
    local doorDescription = doorName
    return doorDescription
    
end

function Door:SetState(state, commander)

    if self.state ~= state then
    
        self.state = state
        
        if Server then
        
            local sound = Door.kStateSound[self.state]
            if sound ~= "" then
            
                self:PlaySound(sound)
                
                if commander ~= nil then
                    Server.PlayPrivateSound(commander, sound, nil, 1.0, commander:GetOrigin())
                end
                
            end
            
        end
        
    end
    
end

function Door:GetState()
    return self.state
end

function Door:GetClientState()
    return self.clientstate
end

function Door:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = false
end

function Door:OnUpdateAnimationInput(modelMixin)

    PROFILE("Door:OnUpdateAnimationInput")
    
    local open = self.state == Door.kState.Open or self.clientstate == Door.kState.Open
    local lock = false
    
    modelMixin:SetAnimationInput("open", open)
    modelMixin:SetAnimationInput("lock", lock)
    
end

if not Server then
	
	function Door:OnUpdate(deltaTime)
	
		ScriptActor.OnUpdate(self, deltaTime)
		if not self.lastUpdated or self.lastUpdated + kUpdateAutoOpenRate < Shared.GetTime() then
			ClientUpdateAutoOpen(self)
			self.lastUpdated = Shared.GetTime()
		end
		
	end
	
end

if Predict then
	AddClassToPredictionUpdate("Door", function(ent) return true end, kUpdateAutoOpenRate)
end

Shared.LinkClassToMap("Door", Door.kMapName, networkVars)