//Dont want to always replace random files, so this.
//FJKLDHJFKLSJFKLSDJFLK: this is retarded, but I think it was broken because it was a local and the first one of these to be executed......

kNewWeaponEffects = 
{

	metabolize = 
	{
		metabolize_sounds = 
		{
			{player_sound = "", silenceupgrade = true, done = true},
			{player_sound = "sound/compmod.fev/compmod/alien/fade/metabolize"}
		}
	},

	spores_fire = 
	{
		spores_fire = 
		{
			{player_sound = "", silenceupgrade = true, done = true},
			{player_sound = "sound/compmod.fev/compmod/alien/lerk/spore_fire"}
		}
	}
	
}

GetEffectManager():AddEffectData("NewWeaponEffects", kNewWeaponEffects)
//This could cause havok :D:D
GetEffectManager():PrecacheEffects()