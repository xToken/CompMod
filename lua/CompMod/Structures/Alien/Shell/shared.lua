-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Shell\shared.lua
-- - Dragon

-- SHELL
local originalShellOnInitialized
originalShellOnInitialized = Class_ReplaceMethod("Shell", "OnInitialized",
	function(self)
		InitMixin(self, InfestationMixin)
		originalShellOnInitialized(self)
		if Server then
			InitMixin(self, SupplyUserMixin)
		end
	end
)

function Shell:GetInfestationRadius()
    return kStructureInfestationRadius
end

function Shell:GetInfestationMaxRadius()
    return kStructureInfestationRadius
end

function Shell:GetSustenanceScalar()
    return 3
end

local networkVars = { }

AddMixinNetworkVars(InfestationMixin, networkVars)

Shared.LinkClassToMap("Shell", Shell.kMapName, networkVars)