// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Client\TechButtonAdjustments.lua
// - Dragon

//TechID to icon Mappings
local kTechIdToMaterialOffset = GetUpValue( GetMaterialXYOffset,   "kTechIdToMaterialOffset" )
kTechIdToMaterialOffset[kTechId.GorgeTunnelEntrance] = 103
kTechIdToMaterialOffset[kTechId.GorgeTunnelExit] = 103
kTechIdToMaterialOffset[kTechId.HeavyMachineGunTech] = 171
kTechIdToMaterialOffset[kTechId.HeavyMachineGun] = 171
kTechIdToMaterialOffset[kTechId.DropHeavyMachineGun] = 171
kTechIdToMaterialOffset[kTechId.ARCSpeedBoost] = 111