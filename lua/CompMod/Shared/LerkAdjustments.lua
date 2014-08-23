//Dont want to always replace random files, so this.

local flying3DSound = PrecacheAsset("sound/NS2.fev/alien/lerk/flying_3D")

local originalLerkOnCreate
originalLerkOnCreate = Class_ReplaceMethod("Lerk", "OnCreate",
	function(self)
		originalLerkOnCreate(self)
		
		self.flySoundId = Entity.invalidId
		
		if Client then
			if self.flySound then
				Client.DestroySoundEffect(self.flySound)
				self.flySound = nil
			end
		end
		
		if Server then
			self.flySound = Server.CreateEntity(SoundEffect.kMapName)
			self.flySound:SetAsset(flying3DSound)
			self.flySound:SetParent(self)
			self.flySoundState = false
			self.flySoundId = self.flySound:GetId()
		end
	end
)

local function UpdateFlySound(self, deltaTime)
	if self.flySoundId ~= Entity.invalidId then
		if self.lastflySoundUpdate == nil or self.lastflySoundUpdate > kLerkFlySoundUpdateRate then
			local flySound = Shared.GetEntity(self.flySoundId)
			if flySound then
				if Server then
					if self.silenceLevel == 3 and self.flySoundState then
						self.flySound:Stop()
						self.flySoundState = false
					elseif self.silenceLevel < 3 and not self.flySoundState then
						self.flySound:Start()
						self.flySoundState = true
					end
				end
				if Client then
					local currentSpeed = self:GetVelocityLength()
					if currentSpeed > kLerkFlySoundMinSpeed then
						//This says volume, but thats really a lie... it just controls the speed parameter on the sound.. which sorta scales up the sound volume indirectly.
						local volume = Clamp(((currentSpeed / self:GetMaxSpeed()) * 1.3), 0, 1)
						if self.silenceLevel > 0 then
							volume = volume / self.silenceLevel
						end
						if Client.GetLocalPlayer() == self then
							volume = volume * 0.45
						end
						flySound:SetParameter("speed", volume, 10)
					else
						flySound:SetParameter("speed", 0, 10)
					end
				end
			end
			self.lastflySoundUpdate = (self.lastflySoundUpdate or kLerkFlySoundUpdateRate) - kLerkFlySoundUpdateRate
		else
			self.lastflySoundUpdate = (self.lastflySoundUpdate or 0) + deltaTime
		end
	end
end

local originalLerkOnUpdate
originalLerkOnUpdate = Class_ReplaceMethod("Lerk", "OnUpdate",
	function(self, deltaTime)
		originalLerkOnUpdate(self, deltaTime)
		UpdateFlySound(self, deltaTime)
	end
)

local originalLerkOnProcessMove
originalLerkOnProcessMove = Class_ReplaceMethod("Lerk", "OnProcessMove",
	function(self, input)
		originalLerkOnProcessMove(self, input)
		UpdateFlySound(self, input.time)
	end
)

local networkVars = { flySoundId = "entityid" }

Shared.LinkClassToMap("Lerk", Lerk.kMapName, networkVars, true)