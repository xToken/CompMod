-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\NS2Gamerules\server.lua
-- - Dragon

local originalNS2GamerulesOnTournamentModeEnabled
originalNS2GamerulesOnTournamentModeEnabled = Class_ReplaceMethod("NS2Gamerules", "OnTournamentModeEnabled",
	function(self)
		originalNS2GamerulesOnTournamentModeEnabled(self)
		local gameInfo = GetGameInfoEntity()
        if gameInfo then
			gameInfo:SetTournamentMode(self.tournamentMode)
		end
	end
)

local originalNS2GamerulesOnTournamentModeDisabled
originalNS2GamerulesOnTournamentModeDisabled = Class_ReplaceMethod("NS2Gamerules", "OnTournamentModeDisabled",
	function(self)
		originalNS2GamerulesOnTournamentModeDisabled(self)
		local gameInfo = GetGameInfoEntity()
        if gameInfo then
			gameInfo:SetTournamentMode(self.tournamentMode)
		end
	end
)