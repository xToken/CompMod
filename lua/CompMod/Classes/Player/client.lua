-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Player\client.lua
-- - Dragon

local originalPlayerGetAuxWeaponClip
originalPlayerGetAuxWeaponClip = Class_ReplaceMethod("Player", "GetAuxWeaponClip",
	function(self)
		local weapon = self:GetActiveWeapon()
		if weapon then
			if weapon:isa("ClipWeapon") then
				return weapon:GetAuxClip()
			elseif weapon:isa("LayMines") then
				return weapon:GetDeployedMines()
			end
		end
		return 0
	end
)

local originalPlayerGetShowHealthFor
originalPlayerGetShowHealthFor = Class_ReplaceMethod("Player", "GetShowHealthFor",
	function(self, player)
		local gameInfo = GetGameInfoEntity()
        if gameInfo and not gameInfo:GetTournamentMode() then
			return originalPlayerGetShowHealthFor(self, player)
		end
		return ( player:isa("Spectator") or player:isa("Commander") or ( not GetAreEnemies(self, player) and self:GetIsAlive() ) ) and self:GetTeamType() ~= kNeutralTeamType
	end
)