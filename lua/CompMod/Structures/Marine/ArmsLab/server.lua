-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Marine\ArmsLab\server.lua
-- - Dragon

local originalArmsLabOnInitialized
originalArmsLabOnInitialized = Class_ReplaceMethod("ArmsLab", "OnInitialized",
    function(self)        
        originalArmsLabOnInitialized(self)
        InitMixin(self, SupplyUserMixin)
    end
)

function ArmsLab:OnResearchComplete(researchId)

end

function ArmsLab:OnDestroy()

	local team = self:GetTeam()

	if team then
		team:OnTeamEntityDestroyed(self)
	end

	ScriptActor.OnDestroy(self)

end