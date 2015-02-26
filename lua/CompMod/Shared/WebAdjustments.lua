
local function SetWebAsHardened(self)
	if self:GetIsAlive() then
		self.hardened = true
	end
	return false
end

local originalWebOnCreate
originalWebOnCreate = Class_ReplaceMethod("Web", "OnCreate",
	function(self)
		originalWebOnCreate(self)
		self.hardened = false
		if Server then
			self:AddTimedCallback(SetWebAsHardened, kWebHardenTime)
		end
	end
)

local originalWebUpdateWebOnProcessMove
originalWebUpdateWebOnProcessMove = Class_ReplaceMethod("Web", "UpdateWebOnProcessMove",
	function(self, fromPlayer)
		if self.hardened then
			originalWebUpdateWebOnProcessMove(self, fromPlayer)
		end
	end
)

if Server then

	local originalWebOnUpdate
	originalWebOnUpdate = Class_ReplaceMethod("Web", "OnUpdate",
		function(self, deltaTime)
			if self.enemiesInRange and not self.hardened then
				DestroyEntity(self)
			else
				originalWebOnUpdate(self, deltaTime)
			end
		end
	)

end

Shared.LinkClassToMap("Web", Web.kMapName, { hardened = "boolean" }, true)