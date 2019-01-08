-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIUpgradeChamberDisplay\post.lua
-- - Dragon

local kIndexToUpgrades =
{
    { kTechId.Shell, kTechId.Carapace, kTechId.Regeneration },
    { kTechId.Spur, kTechId.Celerity, kTechId.Adrenaline },
    { kTechId.Veil, kTechId.Crush, kTechId.Aura },
}

ReplaceUpValue(GUIUpgradeChamberDisplay.Update, "kIndexToUpgrades", kIndexToUpgrades, { LocateRecurse = true } )