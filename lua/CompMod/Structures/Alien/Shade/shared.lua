-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Shade\shared.lua
-- - Dragon

Shade.kCloakRadius = kShadeRange

-- SHADE
local originalShadeOnCreate
originalShadeOnCreate = Class_ReplaceMethod("Shade", "OnCreate",
	function(self)
		originalShadeOnCreate(self)
		InitMixin(self, DetectorMixin)
	end
)

local originalShadeOnInitialized
originalShadeOnInitialized = Class_ReplaceMethod("Shade", "OnInitialized",
	function(self)
		InitMixin(self, InfestationMixin)
		originalShadeOnInitialized(self)
	end
)

function Shade:GetInfestationRadius()
    return kStructureInfestationRadius
end

function Shade:GetInfestationMaxRadius()
    return kStructureInfestationRadius
end

function Shade:GetTechAllowed(techId, techNode, player)
    return ScriptActor.GetTechAllowed(self, techId, techNode, player)
end

function Shade:ShouldGenerateInfestation()
    return not self.moving
end

function Shade:GetDetectionRange()

    if self:GetMaturityLevel() == kMaturityLevel.Flourishing then
        return Shade.kCloakRadius
    end
    
    return 0
    
end

local networkVars = { }

AddMixinNetworkVars(InfestationMixin, networkVars)

Shared.LinkClassToMap("Shade", Shade.kMapName, networkVars)