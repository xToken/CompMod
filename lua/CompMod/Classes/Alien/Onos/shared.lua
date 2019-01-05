-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Alien\Onos\shared.lua
-- - Dragon

-- Disable all of this nonsense...
function Onos:Stampede()
end

-- Required by ControllerMixin.
function Onos:GetMovePhysicsMask()
    return PhysicsMask.OnosMovement
end

function Onos:GetAdrenalineRecuperationRate()
	return kOnosAdrenalineRecuperationScalar
end

Onos.kMaxSpeed = kOnosMaxGroundSpeed
Onos.kChargeSpeed = kOnosMaxChargeSpeed