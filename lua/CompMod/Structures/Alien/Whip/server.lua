-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\Whip.lua
-- - Dragon

local originalWhipOnDestroy
originalWhipOnDestroy = Class_ReplaceMethod("Whip", "OnDestroy",
	function(self)
		local team = self:GetTeam()
		if team then
			team:OnTeamEntityDestroyed(self)
		end
		originalWhipOnDestroy(self)
	end
)


function Whip:OnMaturityLevelUpdated(oldLevel, newLevel)
	if newLevel == kMaturityLevel.Flourishing then
    	self:GiveUpgrade(kTechId.WhipBombard)
    end
    if oldLevel == kMaturityLevel.Flourishing and newLevel ~= kMaturityLevel.Flourishing then
    	self:RemoveUpgrade(kTechId.WhipBombard)
    end
end