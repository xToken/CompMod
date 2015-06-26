// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\AlienWeaponEffectAdjustments.lua
// - Dragon

//FJKLDHJFKLSJFKLSDJFLK: this is retarded, but I think it was broken because it was a local and the first one of these to be executed......
kNewWeaponEffects = 
{

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