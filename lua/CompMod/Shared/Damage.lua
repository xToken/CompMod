-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\Damage.lua
-- - Dragon

-- Update MG Damage Type
local function MultiplyForMachineGun(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
	local s = doer.mg_upg2 and kHeavyMachineGunStructureUpgradedDamageScalar or kHeavyMachineGunStructureDamageScalar
    return ConditionalValue(target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage(damageType), damage * s, damage), armorFractionUsed, healthPerArmor
end

-- Grenades explode with FIRE
local function MultipleGLforFlameAble(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    if target.GetIsFlameAble and target:GetIsFlameAble(damageType) then
        damage = damage * kGrenadeLauncherFlameableMultiplier
    end
    
    return damage, armorFractionUsed, healthPerArmor
end

local oldGetDamageByType = GetDamageByType
function GetDamageByType(...)
	local damage, armorUsed, healthUsed = oldGetDamageByType(...)
	-- Blank the table
	kDamageTypeRules[kDamageType.MachineGun] = {}
	-- Insert our new func for MG
	table.insert(kDamageTypeRules[kDamageType.MachineGun], MultiplyForMachineGun)
	-- Insert our new func for GL
	table.insert(kDamageTypeRules[kDamageType.GrenadeLauncher], MultipleGLforFlameAble)
	-- Point back function
	GetDamageByType = oldGetDamageByType
	-- Return original values
	return damage, armorUsed, healthUsed
end