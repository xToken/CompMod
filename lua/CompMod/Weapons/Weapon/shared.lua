-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Weapon\shared.lua
-- - Dragon

-- Just Override these, we change too much here anyways

function Weapon:GetUpgradeTier()
    return kTechId.None, 0
end