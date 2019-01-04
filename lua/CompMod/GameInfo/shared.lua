-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GameInfo\shared.lua
-- - Dragon

local originalGameInfoOnCreate
originalGameInfoOnCreate = Class_ReplaceMethod("GameInfo", "OnCreate",
	function(self)
		originalGameInfoOnCreate(self)
		self.tournamentMode = false
	end
)

function GameInfo:GetTournamentMode()
    return self.tournamentMode
end

if Server then

    function GameInfo:SetTournamentMode(tM)
        self.tournamentMode = tM
    end
	
end

Shared.LinkClassToMap("GameInfo", GameInfo.kMapName, { tournamentMode = "boolean" })