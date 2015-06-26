// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\AlienUpgradeAdjustments.lua
// - Dragon

local HasUpgrade = GetUpValue( GetHasCelerityUpgrade,  "HasUpgrade")

function GetHasCamouflageUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.Camouflage)
end

function GetHasSilenceUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.Silence)
end