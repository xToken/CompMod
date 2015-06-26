// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\WebAdjustments.lua
// - Dragon

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