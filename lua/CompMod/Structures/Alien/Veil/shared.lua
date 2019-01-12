-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Veil\shared.lua
-- - Dragon

-- VEIL
local originalVeilOnInitialized
originalVeilOnInitialized = Class_ReplaceMethod("Veil", "OnInitialized",
	function(self)
		InitMixin(self, InfestationMixin)
		originalVeilOnInitialized(self)
	end
)

function Veil:GetInfestationRadius()
    return kStructureInfestationRadius
end

function Veil:GetInfestationMaxRadius()
    return kStructureInfestationRadius
end

function Veil:GetSustenanceScalar()
    return 3
end

local networkVars = { }

AddMixinNetworkVars(InfestationMixin, networkVars)

Shared.LinkClassToMap("Veil", Veil.kMapName, networkVars)