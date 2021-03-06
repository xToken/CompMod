-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Crag\client.lua
-- - Dragon

local originalCragOnUpdate
originalCragOnUpdate = Class_ReplaceMethod("Crag", "OnUpdate",
	function(self, deltaTime)
		originalCragOnUpdate(self, deltaTime)
		if self.isTeleporting ~= self.lastisTeleporting then
			-- This isnt good coding, but these are all over the place in vanilla
			if not self.isTeleporting and self.lastisTeleporting then
				-- We are not teleporting, trigger clear, then infest start.
				self:CleanupInfestation()
			end
			self.lastisTeleporting = self.isTeleporting
		end
		if self.moving ~= self.lastmoving then
			-- This isnt good coding, but these are all over the place in vanilla
			if not self.moving and self.lastmoving then
				-- We are not moving, trigger clear, then infest start.
				self:CleanupInfestation()
			end
			self.lastmoving = self.moving
		end
	end
)