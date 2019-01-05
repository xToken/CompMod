-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Damage\shared.lua
-- - Dragon

-- DAMAGE TYPE NOTES
-- Only these are in play anymore
-- Normal (Normal? :D)
-- Puncture (Half to Structures)
-- Structural (Double to Structures)
-- GrenadeLauncher (Quad to Structures)
-- StructuresOnly (ARCs, structures ONLY)

-- Corrode (Armor only damage to players, else normal, bilebomb/bombard)
-- Biological (Healspray, doesnt hurt Exos)

-- Update Puncture Damage Type
local kPunctureStructureDamageScalar = 0.5
local function HalftoStructures(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    return ConditionalValue(target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage(damageType), damage * kPunctureStructureDamageScalar, damage), armorFractionUsed, healthPerArmor
end

-- Grenades explode with powa
local function MultipleGLforStructures(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    if target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage(damageType) then
        damage = damage * kGrenadeLauncherSecondaryStructureMultiplier
    end
    
    return damage, armorFractionUsed, healthPerArmor
end

local oldGetDamageByType = GetDamageByType
function GetDamageByType(...)
	local damage, armorUsed, healthUsed = oldGetDamageByType(...)
	-- Blank the table
	kDamageTypeRules[kDamageType.Puncture] = { }
	-- Insert our new func for MG
	table.insert(kDamageTypeRules[kDamageType.Puncture], HalftoStructures)
	-- Insert our new func for GL
	table.insert(kDamageTypeRules[kDamageType.GrenadeLauncher], MultipleGLforStructures)
	-- Point back function
	GetDamageByType = oldGetDamageByType
	-- Return original values
	return damage, armorUsed, healthUsed
end

-- Fix crush to now use veils
function NS2Gamerules_GetUpgradedAlienDamage( target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint, weapon )

    if not doer then return damage, armorFractionUsed end

    local teamNumber = attacker:GetTeamNumber()

    local isAffectedByCrush = doer.GetIsAffectedByCrush and attacker:GetHasUpgrade( kTechId.Crush ) and doer:GetIsAffectedByCrush()

    if isAffectedByCrush then --Crush
        local crushLevel = attacker:GetVeilLevel()
        if crushLevel > 0 then
            if target:isa("Exo") or target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage(damageType) then
                damage = damage + ( damage * ( crushLevel * kAlienCrushDamagePercentByLevel ) )
            end
        end
        
    end
    
    --!!!Note: if more than damage and armor fraction modified, be certain the calling-point of this function is updated
    return damage, armorFractionUsed
    
end