//Dont want to always replace random files, so this.

local exowelder_start =
    {
        welderStartEffects =
        {
            {cinematic = "cinematics/marine/welder/welder_start.cinematic"}
        }
    }
	
local exowelder_muzzle =
    {
        welderMuzzleEffects =
        {
            {cinematic = "cinematics/marine/welder/welder_muzzle.cinematic"}
        }
    }

table.insert(kMarineWeaponEffects["draw"]["marineWeaponDrawSounds"], {player_sound = "sound/compmod.fev/compmod/marine/hmg/hmg_draw", classname = "HeavyMachineGun", done = true})
table.insert(kMarineWeaponEffects["reload"]["gunReloadEffects"], {player_sound = "sound/compmod.fev/compmod/marine/hmg/hmg_reload", classname = "HeavyMachineGun"})
table.insert(kMarineWeaponEffects["reload_cancel"]["gunReloadCancelEffects"], {stop_sound = "sound/compmod.fev/compmod/marine/hmg/hmg_reload", classname = "HeavyMachineGun"})
table.insert(kMarineWeaponEffects["clipweapon_empty"]["emptySounds"], {player_sound = "sound/NS2.fev/marine/common/empty", classname = "HeavyMachineGun", done = true})
table.insert(kMarineWeaponEffects, exowelder_start)
table.insert(kMarineWeaponEffects, exowelder_muzzle)

GetEffectManager():AddEffectData("kMarineWeaponEffects", kMarineWeaponEffects)
//This could cause havok :D:D
GetEffectManager():PrecacheEffects()