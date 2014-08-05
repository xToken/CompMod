//Dont want to always replace random files, so this.

local metabolize = 
    {
        metabolizeSounds = 
        {
            {player_sound = "", silenceupgrade = true, done = true},
            {player_sound = "sound/compmod.fev/compmod/alien/fade/metabolize"}
        }
    }

table.insert(kAlienWeaponEffects, metabolize)

GetEffectManager():AddEffectData("kAlienWeaponEffects", kAlienWeaponEffects)
//This could cause havok :D:D
GetEffectManager():PrecacheEffects()