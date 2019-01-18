-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Marine\ExoWeaponHolder\shared.lua
-- - Dragon

--[[
function ExoWeaponHolder:OnPrimaryAttack(player)

    Weapon.OnPrimaryAttack(self, player)
    
    Shared.GetEntity(self.leftWeaponId):OnPrimaryAttack(player)
    Shared.GetEntity(self.rightWeaponId):OnPrimaryAttack(player)
end

function ExoWeaponHolder:OnPrimaryAttackEnd(player)

    Weapon.OnPrimaryAttackEnd(self, player)
    
    Shared.GetEntity(self.leftWeaponId):OnPrimaryAttackEnd(player)
    Shared.GetEntity(self.rightWeaponId):OnPrimaryAttackEnd(player)
end

function ExoWeaponHolder:OnSecondaryAttack(player)

    Weapon.OnSecondaryAttack(self, player)
    
    --Calling OnPrimaryAttack here is intentional.
    --Shared.GetEntity(self.rightWeaponId):OnPrimaryAttack(player)
end

function ExoWeaponHolder:OnSecondaryAttackEnd(player)

    Weapon.OnSecondaryAttackEnd(self, player)
    
    -- Calling OnPrimaryAttackEnd here is intentional.
    --Shared.GetEntity(self.rightWeaponId):OnPrimaryAttackEnd(player)
    
end
]]--