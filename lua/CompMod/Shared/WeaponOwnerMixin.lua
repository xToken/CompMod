-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\WeaponOwnerMixin.lua
-- - Dragon

-- Actually set these values since locals
local UpdateWeaponsWeight = GetUpValue(WeaponOwnerMixin.SetActiveWeapon, "UpdateWeaponsWeight")

-- Add this callback to trigger a weight update without having to switch weapons
function WeaponOwnerMixin:TriggerWeaponWeightUpdate()
	UpdateWeaponsWeight(self)
end

local origWeaponOwnerMixinAddWeapon = WeaponOwnerMixin.AddWeapon
function WeaponOwnerMixin:AddWeapon(weapon, setActive)
	local hasWeapon = self:GetWeaponInHUDSlot(weapon:GetHUDSlot())
    if hasWeapon and hasWeapon:isa("GrenadeThrower") then
        -- override this weapon
		DestroyEntity(hasWeapon)
    end
	origWeaponOwnerMixinAddWeapon(self, weapon, setActive)
end