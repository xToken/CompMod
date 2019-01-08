-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Damage\shared.lua
-- - Dragon

-- DAMAGE TYPE NOTES
-- Only these are in play anymore
-- Normal (Normal? :D)
-- HalfStructural (Half to Structures)
-- Structural (Double to Structures)
-- QuadStructural (Quad to Structures)
-- StructuresOnly (ARCs, structures ONLY)
-- Remaing custom types below ----
-- NerveGas (Armor only, GAS Nades)
-- Corrode (Armor only damage to players, else normal, Bilebomb/Bombard)
-- Biological (Healspray, doesnt hurt Exos)

-- Update Puncture Damage Type
local kPunctureStructureDamageScalar = 0.5
local kQuadStructuralDamageScalar = 4
local function HalftoStructures(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    return ConditionalValue(target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage(damageType), damage * kPunctureStructureDamageScalar, damage), armorFractionUsed, healthPerArmor
end

local function QuadrupleStructures(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    if target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage(damageType) then
        damage = damage * kQuadStructuralDamageScalar
    end
    
    return damage, armorFractionUsed, healthPerArmor
end

local BuildDamageTypeRules = GetUpValue( GetDamageByType, "BuildDamageTypeRules" )
local function UpdatedBuildDamageTypeRules()
    BuildDamageTypeRules()
    kDamageTypeRules[kDamageType.HalfStructural] = { }
    kDamageTypeRules[kDamageType.QuadStructural] = { }
    -- Insert our new func for MG
    table.insert(kDamageTypeRules[kDamageType.HalfStructural], HalftoStructures)
    -- Insert our new func for stuff
    table.insert(kDamageTypeRules[kDamageType.QuadStructural], QuadrupleStructures)
end

ReplaceUpValue(GetDamageByType, "BuildDamageTypeRules", UpdatedBuildDamageTypeRules)

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