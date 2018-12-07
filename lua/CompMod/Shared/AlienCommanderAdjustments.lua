-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\AlienCommanderAdjustments.lua
-- - Dragon

-- Remove the cyst build button
local gAlienMenuButtons =
{
    [kTechId.BuildMenu] = { kTechId.None, kTechId.Harvester, kTechId.DrifterEgg, kTechId.Hive,
                            kTechId.ThreatMarker, kTechId.NeedHealingMarker, kTechId.ExpandingMarker, kTechId.None },
                            
    [kTechId.AdvancedMenu] = { kTechId.Crag, kTechId.Shade, kTechId.Shift, kTechId.Whip,
                               kTechId.Shell, kTechId.Veil, kTechId.Spur, kTechId.None },

    [kTechId.AssistMenu] = { kTechId.HealWave, kTechId.ShadeInk, kTechId.SelectShift, kTechId.SelectDrifter,
                             kTechId.NutrientMist, kTechId.Rupture, kTechId.BoneWall, kTechId.Contamination }
}

local gAlienMenuIds = {}
do
    for menuId, _ in pairs(gAlienMenuButtons) do
        gAlienMenuIds[#gAlienMenuIds+1] = menuId
    end
end

function AlienCommander:GetButtonTable()
    return gAlienMenuButtons
end

function AlienCommander:GetMenuIds()
    return gAlienMenuIds
end

ReplaceLocals(AlienCommander.GetQuickMenuTechButtons, { gAlienMenuButtons = gAlienMenuButtons })