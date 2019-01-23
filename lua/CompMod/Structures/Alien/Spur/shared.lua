-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Spur\shared.lua
-- - Dragon

-- SPUR
local originalSpurOnInitialized
originalSpurOnInitialized = Class_ReplaceMethod("Spur", "OnInitialized",
	function(self)
		InitMixin(self, InfestationMixin)
		originalSpurOnInitialized(self)
		if Server then
			InitMixin(self, SupplyUserMixin)
		end
	end
)

function Spur:GetInfestationRadius()
    return kStructureInfestationRadius
end

function Spur:GetInfestationMaxRadius()
    return kStructureInfestationRadius
end

function Spur:GetSustenanceScalar()
    return 3
end

local networkVars = { }

AddMixinNetworkVars(InfestationMixin, networkVars)

Shared.LinkClassToMap("Spur", Spur.kMapName, networkVars)