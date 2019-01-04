-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Marine\Exo\server.lua
-- - Dragon

local originalExoCopyPlayerDataFrom
originalExoCopyPlayerDataFrom = Class_ReplaceMethod("Exo", "CopyPlayerDataFrom",
	function(self, player)
		originalExoCopyPlayerDataFrom(self, player)
		
		if GetGamerules():GetGameStarted() then
			self.utilitySlot3 = player.utilitySlot3 or kTechId.None
			self.utilitySlot5 = player.utilitySlot5 or kTechId.None
			self.grenadesLeft = nil
			self.grenadeType = nil
		end
		
	end
)