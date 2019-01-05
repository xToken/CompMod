-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Shell\client.lua
-- - Dragon

-- SHELL
local originalShellOnUpdate
originalShellOnUpdate = Class_ReplaceMethod("Shell", "OnUpdate",
	function(self, deltaTime)
		originalShellOnUpdate(self, deltaTime)
		if self.isTeleporting ~= self.lastisTeleporting then
			-- This isnt good coding, but these are all over the place in vanilla
			if not self.isTeleporting and self.lastisTeleporting then
				-- We are not teleporting, trigger clear, then infest start.
				self:CleanupInfestation()
			end
			self.lastisTeleporting = self.isTeleporting
		end
	end
)