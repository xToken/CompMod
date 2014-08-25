//Dont want to always replace random files, so this.

table.insert(kMarineWeaponEffects["draw"]["marineWeaponDrawSounds"], {player_sound = "sound/compmod.fev/compmod/marine/hmg/hmg_draw", classname = "HeavyMachineGun", done = true})
table.insert(kMarineWeaponEffects["reload"]["gunReloadEffects"], {player_sound = "sound/compmod.fev/compmod/marine/hmg/hmg_reload", classname = "HeavyMachineGun"})
table.insert(kMarineWeaponEffects["reload_cancel"]["gunReloadCancelEffects"], {stop_sound = "sound/compmod.fev/compmod/marine/hmg/hmg_reload", classname = "HeavyMachineGun"})
table.insert(kMarineWeaponEffects["clipweapon_empty"]["emptySounds"], {player_sound = "sound/NS2.fev/marine/common/empty", classname = "HeavyMachineGun", done = true})

GetEffectManager():AddEffectData("kMarineWeaponEffects", kMarineWeaponEffects)
//This could cause havok :D:D
GetEffectManager():PrecacheEffects()