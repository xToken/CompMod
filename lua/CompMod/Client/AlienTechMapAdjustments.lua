// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Client\AlienTechMapAdjustments.lua
// - Dragon

Script.Load("lua/AlienTechMap.lua")

kAlienTechMap =
{
                    { kTechId.Whip, 5.5, 0.5 },          { kTechId.Shift, 6.5, 0.5 },          { kTechId.Shade, 7.5, 0.5 }, { kTechId.Crag, 8.5, 0.5 }, 


                    { kTechId.Harvester, 4, 1.5 },                           { kTechId.Hive, 7, 1.5 }, 
  
                   { kTechId.CragHive, 4, 3 },                               { kTechId.ShadeHive, 7, 3 },                            { kTechId.ShiftHive, 10, 3 },
              { kTechId.Shell, 4, 4, SetShellIcon },                     { kTechId.Veil, 7, 4, SetVeilIcon },                    { kTechId.Spur, 10, 4, SetSpurIcon },
  { kTechId.Carapace, 3.5, 5 },{ kTechId.Regeneration, 4.5, 5 }, { kTechId.Silence, 6, 5 },{ kTechId.Camouflage, 7, 5 },{ kTechId.Aura, 8, 5 },{ kTechId.Celerity, 9.5, 5 },{ kTechId.Adrenaline, 10.5, 5 },
  
  { kTechId.BioMassOne, 3, 7, nil, "1" }, { kTechId.BabblerEgg, 3, 8 },
  
  { kTechId.BioMassTwo, 4, 7, nil, "2" }, {kTechId.Rupture, 4, 8}, { kTechId.Charge, 4, 9 },
  
  { kTechId.BioMassThree, 5, 7, nil, "3" }, {kTechId.BoneWall, 5, 8}, {kTechId.BileBomb, 5, 9}, { kTechId.MetabolizeEnergy, 5, 10 },

  { kTechId.BioMassFour, 6, 7, nil, "4" }, {kTechId.Leap, 6, 8}, {kTechId.BoneShield, 6, 9},
  
  { kTechId.BioMassFive, 7, 7, nil, "5" },  {kTechId.MetabolizeHealth, 7, 8}, {kTechId.Umbra, 7, 9}, {kTechId.Web, 7, 10},
  
  { kTechId.BioMassSix, 8, 7, nil, "6" }, 
  
  { kTechId.BioMassSeven, 9, 7, nil, "7" }, {kTechId.Stab, 9, 8}, {kTechId.Spores, 9, 9},
  
  { kTechId.BioMassEight, 10, 7, nil, "8" },  {kTechId.Stomp, 10, 8}, 
  
  { kTechId.BioMassNine, 11, 7, nil, "9" }, {kTechId.Contamination, 11, 8}, {kTechId.Xenocide, 11, 9}, 

}

kAlienLines = 
{
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.Crag),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.Shift),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.Shade),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.Whip),

    GetLinePositionForTechMap(kAlienTechMap, kTechId.Harvester, kTechId.Hive),
    { 7, 1.5, 7, 2.5 },
    { 4, 2.5, 10, 2.5},
    { 4, 2.5, 4, 3},{ 7, 2.5, 7, 3},{ 10, 2.5, 10, 3},
    GetLinePositionForTechMap(kAlienTechMap, kTechId.CragHive, kTechId.Shell),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.ShadeHive, kTechId.Veil),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.ShiftHive, kTechId.Spur),
    
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Shell, kTechId.Carapace),GetLinePositionForTechMap(kAlienTechMap, kTechId.Shell, kTechId.Regeneration),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Veil, kTechId.Silence), GetLinePositionForTechMap(kAlienTechMap, kTechId.Veil, kTechId.Camouflage), GetLinePositionForTechMap(kAlienTechMap, kTechId.Veil, kTechId.Aura),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Spur, kTechId.Celerity),GetLinePositionForTechMap(kAlienTechMap, kTechId.Spur, kTechId.Adrenaline),

}