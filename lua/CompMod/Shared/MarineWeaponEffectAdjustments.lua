// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\MarineWeaponEffectAdjustments.lua
// - Dragon

table.insert(kMarineWeaponEffects["draw"]["marineWeaponDrawSounds"], {player_sound = "sound/compmod.fev/compmod/marine/hmg/hmg_draw", classname = "HeavyMachineGun", done = true})
table.insert(kMarineWeaponEffects["reload"]["gunReloadEffects"], {player_sound = "sound/compmod.fev/compmod/marine/hmg/hmg_reload", classname = "HeavyMachineGun"})
table.insert(kMarineWeaponEffects["reload_cancel"]["gunReloadCancelEffects"], {stop_sound = "sound/compmod.fev/compmod/marine/hmg/hmg_reload", classname = "HeavyMachineGun"})
table.insert(kMarineWeaponEffects["clipweapon_empty"]["emptySounds"], {player_sound = "sound/NS2.fev/marine/common/empty", classname = "HeavyMachineGun", done = true})
table.insert(kDamageEffects["damage_decal"]["damageDecals"], {decal = "cinematics/vfx_materials/decals/bullet_hole_01.material", scale = 0.15, doer = "HeavyMachineGun", done = true})

GetEffectManager():AddEffectData("kMarineWeaponEffects", kMarineWeaponEffects)
GetEffectManager():AddEffectData("DamageEffects", kDamageEffects)
//This could cause havok :D:D
GetEffectManager():PrecacheEffects()

//Female sounds are backwards in vanilla
local oldMarinekSprintStartFemale = Marine.kSprintStartFemale
Marine.kSprintStartFemale = Marine.kSprintTiredEndFemale
Marine.kSprintTiredEndFemale = oldMarinekSprintStartFemale