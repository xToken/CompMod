// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\PlayerEffectAdjustments.lua
// - Dragon

//The enemy footsteps are REALLLY loud.
for i = 1, #kPlayerEffectData["footstep"]["footstepSoundEffects"] do
	if kPlayerEffectData["footstep"]["footstepSoundEffects"][i] then
		if kPlayerEffectData["footstep"]["footstepSoundEffects"][i].classname == "Exo" then
			//We found it guise
			//table.insert(kPlayerEffectData["footstep"]["footstepSoundEffects"], i, {sound = "sound/NS2.fev/marine/heavy/step_for_enemy", classname = "Exo", enemy = true, done = true})
			table.insert(kPlayerEffectData["footstep"]["footstepSoundEffects"], i + 1,{sound = "sound/NS2.fev/marine/heavy/step", classname = "Exo", done = true})
			break
		end
	end
end

GetEffectManager():AddEffectData("PlayerEffectData", kPlayerEffectData)
GetEffectManager():PrecacheEffects()

//Female sounds are backwards in vanilla
local oldMarinekSprintStartFemale = Marine.kSprintStartFemale
Marine.kSprintStartFemale = Marine.kSprintTiredEndFemale
Marine.kSprintTiredEndFemale = oldMarinekSprintStartFemale