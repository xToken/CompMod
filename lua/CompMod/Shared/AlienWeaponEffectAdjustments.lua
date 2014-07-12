//Dont want to always replace random files, so this.

local metabolize = 
    {
        metabolizeSounds = 
        {
            {player_sound = "", silenceupgrade = true, done = true},
            {player_sound = "sound/compmod.fev/compmod/alien/fade/metabolize"}
        }
    }

local spores_fire = 
    {
        spores_fire = 
        {
            {player_sound = "", silenceupgrade = true, done = true},
            {player_sound = "sound/compmod.fev/compmod/alien/lerk/spore_fire"}
        }
    }

table.insert(kAlienWeaponEffects, metabolize)
table.insert(kAlienWeaponEffects, spores_fire)

GetEffectManager():AddEffectData("kAlienWeaponEffects", kAlienWeaponEffects)
//This could cause havok :D:D
GetEffectManager():PrecacheEffects()