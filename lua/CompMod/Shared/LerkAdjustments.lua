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
			self.flySoundId = self.flySound:GetId()
			self.flySound:Start()
		end
	end
)

if Client then

	local function UpdateFlySound(self, deltaTime)
		if self.flySoundId ~= Entity.invalidId then
			if self.lastflySoundUpdate == nil or self.lastflySoundUpdate > kLerkFlySoundUpdateRate then
				local currentSpeed = self:GetVelocityLength()
				local flySound = Shared.GetEntity(self.flySoundId)
				if flySound then
					if currentSpeed > kLerkFlySoundMinSpeed then
						local volume = Clamp(((currentSpeed / self:GetMaxSpeed()) * 1.3), 0, 1)
						if Client.GetLocalPlayer() == self then
							volume = volume * 0.75
						end
						flySound:SetParameter("speed", volume, 10)
					else
						flySound:SetParameter("speed", 0, 10)
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
	
end

local networkVars = { flySoundId = "entityid" }

Shared.LinkClassToMap("Lerk", Lerk.kMapName, networkVars, true)