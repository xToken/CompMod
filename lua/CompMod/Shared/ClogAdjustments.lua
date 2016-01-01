// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\ClogAdjustments.lua
// - Dragon

local kFallenTimeWindow = 1

function Clog:OnClogFallDone(isAttached, normal)
	//Epic Hack time.  Seems the predict VM collision object doesnt get updated after the clog falls.  Forcing the clients to update improves it, but will not fully resolve the problem.
	//Clogs dont seem to have a way to interact with the predict VM.  Using Player OnUpdatePlayer in Predict VM to update all relevant clogs.  Caching and stepping to avoid
	//Updating every clog every tick, and doing an ent lookup every tick.
	self.hasFallen = true
	self.fallenWindow = kFallenTimeWindow
end

local function UpdateClogAfterFalling(self, deltaTime)
	if self.hasFallen then
		if Client and not self.updatedClient then
			self.updatedClient = true
			if self.simplePhysicsBody then
				self.simplePhysicsBody:SetCoords(self:GetCoords())
			end
			//Shared.Message(string.format("Physics Updated on %s.", Client and "Client" or Server and "Server" or Predict and "Predict"))
		end
		if Predict and not self.updatedPredict then
			self.updatedPredict = true
			if self.simplePhysicsBody then
				self.simplePhysicsBody:SetCoords(self:GetCoords())
			end
			//Shared.Message(string.format("Physics Updated on %s.", Client and "Client" or Server and "Server" or Predict and "Predict"))
		end
		if Server then
			self.fallenWindow = math.max(self.fallenWindow - deltaTime, 0)
			if self.fallenWindow == 0 then
				self.hasFallen = false
				//Shared.Message(string.format("Physics Updated on %s.", Client and "Client" or Server and "Server" or Predict and "Predict"))
			end
		end
	else
		if Client and self.updatedClient then
			self.updatedClient = false
		end
		if Predict and self.updatedPredict then
			self.updatedPredict = false
		end
	end
end

function Clog:OnUpdate(deltaTime)

    PROFILE("Clog:OnUpdate")
	UpdateClogAfterFalling(self, deltaTime)
	Entity.OnUpdate(self, deltaTime)
	
end

function Clog:OnKill()

    //Insure that an OnUpdate called after destroy doesnt re-create the physics.
	self:SetSimplePhysicsEnabled(false)
	self:TriggerEffects("death")
	DestroyEntity(self)
	
end

if Predict then

	local kPredictClogTable = { }
	local kPredictClogUpdateRate = 0.5
	
	local function RemoveOldClogId(entId)
		for i = #kPredictClogTable, 1, -1 do
			if kPredictClogTable[i] then
				if kPredictClogTable[i].i == entId then
					kPredictClogTable[i] = nil
				end
			end		
		end
	end
	
	local oldClogOnCreate
	oldClogOnCreate = Class_ReplaceMethod("Clog", "OnCreate",
		function(self)
			oldClogOnCreate(self)
			table.insert(kPredictClogTable, {i = self:GetId(), t = kPredictClogUpdateRate})
		end
	)

	local oldClogOnDestroy
	oldClogOnDestroy = Class_ReplaceMethod("Clog", "OnDestroy",
		function(self)
			RemoveOldClogId(self:GetId())
			oldClogOnDestroy(self)
		end
	)
	
	local oldPlayerOnUpdatePlayer
	oldPlayerOnUpdatePlayer = Class_ReplaceMethod("Player", "OnUpdatePlayer",
		function(self, deltaTime)
			for i = #kPredictClogTable, 1, -1 do
				if kPredictClogTable[i] then
					kPredictClogTable[i].t = math.max(kPredictClogTable[i].t - deltaTime, 0)
					if kPredictClogTable[i].t == 0 then
						local clog = Shared.GetEntity(kPredictClogTable[i].i)
						if clog and clog:isa("Clog") then
							clog:OnUpdate(deltaTime)
							kPredictClogTable[i].t = kPredictClogUpdateRate
						else
							kPredictClogTable[i] = nil
						end
					end
				end
			end
		end
	)
	
end

local networkVars = { hasFallen = "boolean" }

Shared.LinkClassToMap("Clog", Clog.kMapName, networkVars)