-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Server\MarineCommander.lua
-- - Dragon

function MarineCommander:TrackedEntityUpdate(techId, newCount)
	if techId == kTechId.WeaponsArmsLab then
		self.warmslab = Clamp(newCount, 0 ,3)
	elseif techId == kTechId.ArmorArmsLab then
		self.aarmslab = Clamp(newCount, 0 ,3)
	end
end

local originalMarineCommanderCopyPlayerDataFrom
originalMarineCommanderCopyPlayerDataFrom = Class_ReplaceMethod("MarineCommander", "CopyPlayerDataFrom",
	function(self, player)
		originalMarineCommanderCopyPlayerDataFrom(self, player)
		
		if GetGamerules():GetGameStarted() then
			self.utilitySlot4 = player.utilitySlot4 or kTechId.None
			self.utilitySlot5 = player.utilitySlot5 or kTechId.None
			self.grenadesLeft = nil
			self.grenadeType = nil
		end
		
	end
)