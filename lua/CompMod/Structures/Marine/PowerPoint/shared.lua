-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Marine\PowerPoint\shared.lua
-- - Dragon

-- Prevent damaging the power nodes
function PowerPoint:GetCanTakeDamageOverride()
    return false
end

function PowerPoint:OnTakeDamage()
end

function PowerPoint:DoDamageLighting()
end

-- Things are always powered.
function PowerConsumerMixin:GetIsPowered() 
    return true
end

-- Prevent minimap blip?
local oldMapBlipMixinGetMapBlipInfo = MapBlipMixin.GetMapBlipInfo
function MapBlipMixin:GetMapBlipInfo()
	if self:isa("PowerPoint") then
		return false, kMinimapBlipType.Undefined, -1, false, false
	end
	return oldMapBlipMixinGetMapBlipInfo(self)
end

-- Prevent unit status?
function PowerPoint:GetShowUnitStatusForOverride()
    return false
end