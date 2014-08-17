//Dont want to always replace random files, so this.

local flying2DSound	= GetUpValue(Lerk.OnCreate, "flying2DSound")

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
			self.flySound:SetAsset(flying2DSound)
			self.flySound:SetParent(self)
			self.flySoundId = self.flySound:GetId()
			self.flySound:Start()
		end
	end
)

if Client then

	local originalLerkModifyVelocity
	originalLerkModifyVelocity = Class_ReplaceMethod("Lerk", "ModifyVelocity",
		function(self, input, velocity, deltaTime)
			originalLerkModifyVelocity(self, input, velocity, deltaTime)
			if self.flySoundId ~= Entity.invalidId then
				if self.lastflySoundUpdate == nil or self.lastflySoundUpdate > kLerkFlySoundUpdateRate then
					local currentSpeed = velocity:GetLengthXZ()
					local flySound = Shared.GetEntity(self.flySoundId)
					if flySound then
						if currentSpeed > kLerkFlySoundMinSpeed then
							flySound:SetParameter("speed", Clamp(((currentSpeed / self:GetMaxSpeed()) * 1.3), 0, 1), 10)
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
	)
	
end

local networkVars = { flySoundId = "entityid" }

Shared.LinkClassToMap("Lerk", Lerk.kMapName, networkVars, true)