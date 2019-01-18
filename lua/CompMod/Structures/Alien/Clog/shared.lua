-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Clog\shared.lua
-- - Dragon

function Clog:ModifyDamageTaken(damageTable, attacker, doer, damageType, hitPoint)
    if doer and doer:isa("Flamethrower") then
        damageTable.damage = damageTable.damage * 2
    end
end