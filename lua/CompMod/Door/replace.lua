-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Door\replace.lua
-- - Dragon

Script.Load("lua/ScriptActor.lua")
Script.Load("lua/Mixins/ClientModelMixin.lua")
Script.Load("lua/PathingMixin.lua")
Script.Load("lua/MapBlipMixin.lua")
if Predict then Script.Load("lua/CompMod/Utilities/PredictUpdater/predict.lua") end

class 'Door' (ScriptActor)

Door.kMapName = "door"

Door.kOpenSound = PrecacheAsset("sound/NS2.fev/common/door_open")
Door.kCloseSound = PrecacheAsset("sound/NS2.fev/common/door_close")

Door.kState = enum( {'Open', 'Close' } )
Door.kStateSound = { [Door.kState.Open] = Door.kOpenSound, 
                     [Door.kState.Close] = Door.kCloseSound  }

local kUpdateAutoOpenRate = 0.25
local kLocalUpdateAutoOpenRate = 0.025
local kClientStateGrace = 0.5

local kModelNameDefault = PrecacheAsset("models/misc/door/door.model")
local kModelNameClean = PrecacheAsset("models/misc/door/door_clean.model")
local kDoorAnimationGraph = PrecacheAsset("models/misc/door/door.animation_graph")

local networkVars =
{
    state = "enum Door.kState"
}

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ClientModelMixin, networkVars)

local function UpdateAutoOpen(self, timePassed)

    -- If any players are around, have door open if possible, otherwise close it
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
	
	if desiredOpenState and self:GetState() == Door.kState.Close then
		self:SetState(Door.kState.Open)
	elseif not desiredOpenState and self:GetState() == Door.kState.Open then
		self:SetState(Door.kState.Close)  
	end

	-- Force client model mixin updates
	if self:GetState() == Door.kState.Open then
		self:ForceUpdateUntil(Shared.GetTime() + kUpdateAutoOpenRate + 0.1)
	end
    
    return true

end

local function ClientUpdateAutoOpen(self, player)

    if player then

        local desiredOpenState = false
		local opensForEntity, openDistance = player:GetCanDoorInteract(self)

		if opensForEntity then
			local distSquared = self:GetDistanceSquared(player)
			if (not HasMixin(player, "Live") or player:GetIsAlive()) and distSquared < (openDistance * openDistance) then
				desiredOpenState = true			
			end
		end
        
        if desiredOpenState and self:GetClientState() == Door.kState.Close then
            self:SetClientState(Door.kState.Open)
        elseif not desiredOpenState and self:GetClientState() == Door.kState.Open then
            self:SetClientState(Door.kState.Close)
        end
        
    end
	
end

local function UpdateClientAutoOpen(self)
	ClientUpdateAutoOpen(self, Client.GetLocalPlayer())
	return true
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

    if Client then
		self:AddFieldWatcher("state", Door.OnStateChanged)
	end

    self.state = Door.kState.Open
    self.clientstate = Door.kState.Open
	self.clientstateoverride = 0

end

function Door:OnInitialized()

    ScriptActor.OnInitialized(self)
    
    if Server then
        
        InitModel(self)
        
        self:SetPhysicsType(PhysicsType.Kinematic)
        
        self:SetPhysicsGroup(PhysicsGroup.CommanderUnitGroup)
        
        -- This Mixin must be inited inside this OnInitialized() function.
        if not HasMixin(self, "MapBlip") then
            InitMixin(self, MapBlipMixin)
        end
		
		self:AddTimedCallback(UpdateAutoOpen, kUpdateAutoOpenRate)
		
	elseif Client then
	
		self:AddTimedCallback(UpdateClientAutoOpen, kLocalUpdateAutoOpenRate)
		
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
    return false
end

function Door:GetDescription()

    local doorName = GetDisplayNameForTechId(self:GetTechId())
    return doorName
    
end

function Door:OnStateChanged()
	self:TriggerSound(self.state)
	return true
end

function Door:TriggerSound(state)
	StartSoundEffectAtOrigin(Door.kStateSound[state], self:GetOrigin())
end

function Door:SetState(state)
    self.state = state
end

function Door:GetState()
    return self.state
end

function Door:GetClientState()
    return self.clientstate
end

function Door:SetClientState(state)
	if state ~= self.clientstate then
		self.clientstateoverride = Shared.GetTime() + kClientStateGrace
		self.clientstate = state
    	--self:TriggerSound(state)
	end
end

function Door:GetCanBeUsed(player, useSuccessTable)
    useSuccessTable.useSuccess = false
end

function Door:OnUpdateAnimationInput(modelMixin)

    PROFILE("Door:OnUpdateAnimationInput")
	
	local state = self:GetState()
	if Client or Predict then
		if state ~= Door.kState.Open and self.clientstateoverride > Shared.GetTime() then
			state = self:GetClientState()
		end
	end
	
    modelMixin:SetAnimationInput("open", state == Door.kState.Open)
    modelMixin:SetAnimationInput("lock", false)

end

if Predict then
	
	function Door:OnUpdate(deltaTime)
		ClientUpdateAutoOpen(self, Predict.GetLocalPlayer())
		ScriptActor.OnUpdate(self, deltaTime)	
	end
	
	AddClassToPredictionUpdate("Door", function(ent) return true end)
	
end

Shared.LinkClassToMap("Door", Door.kMapName, networkVars)