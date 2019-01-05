-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Harvester\shared.lua
-- - Dragon

-- Harvester
local originalHarvesterOnInitialized
originalHarvesterOnInitialized = Class_ReplaceMethod("Harvester", "OnInitialized",
	function(self)
		InitMixin(self, InfestationMixin)
		originalHarvesterOnInitialized(self)
	end
)

function Harvester:GetInfestationRadius()
    return kStructureInfestationRadius
end

function Harvester:GetInfestationMaxRadius()
    return kStructureInfestationRadius
end

local networkVars = { }

AddMixinNetworkVars(InfestationMixin, networkVars)

Shared.LinkClassToMap("Harvester", Harvester.kMapName, networkVars)