-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Marine\MarineSpectator\server.lua
-- - Dragon

function MarineSpectator:CopyPlayerDataFrom( player )
	TeamSpectator.CopyPlayerDataFrom(self, player)
	
	if GetGamerules():GetGameStarted() then
		self.utilitySlot3 = player.utilitySlot3 or kTechId.None
		self.utilitySlot5 = player.utilitySlot5 or kTechId.None
		self.grenadesLeft = nil
		self.grenadeType = nil
	end
	
end

-- Bit weird, but this ensures we only get tech on RESPAWN (transition from spectator to marine)
local originalMarineSpectatorReplace
originalMarineSpectatorReplace = Class_ReplaceMethod("MarineSpectator", "Replace",
	function(self, mapName, newTeamNumber, preserveWeapons, atOrigin, extraValues)

		local newPlayer = TeamSpectator.Replace(self, mapName, newTeamNumber, preserveWeapons, atOrigin, extraValues)
		
		if newPlayer:isa("Marine") and newPlayer.utilitySlot3 ~= kTechId.None then
			newPlayer:GiveItem(LookupTechData(newPlayer.utilitySlot3, kTechDataMapName), false)
		end
		if newPlayer:isa("Marine") and newPlayer.utilitySlot5 ~= kTechId.None then
			newPlayer:GiveItem(LookupTechData(newPlayer.utilitySlot5, kTechDataMapName), false)
		end
		
		return newPlayer
	end
)