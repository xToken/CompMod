-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Web\shared.lua
-- - Dragon

function Web:ModifyDamageTaken(damageTable, attacker, doer, damageType, hitPoint)

    -- webs can't be destroyed with bullet weapons
    if doer and not (doer:isa("Axe") or doer:isa("Grenade") or doer:isa("ClusterGrenade") or doer:isa("Flamethrower") or doer:isa("Welder")) then
        damageTable.damage = 0
    end

end