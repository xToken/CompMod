//Dont want to always replace random files, so this.
Script.Load("lua/Hud/GUIEvent.lua")

//This isnt actually loaded as a GUIScript, more as a resource.
local GetUnlockIconParams = GetUpValue( GUIEvent.UpdateUnlockDisplay,   "GetUnlockIconParams" )
//Build table
GetUnlockIconParams(kTechId.Armor1)
//Get the table
local kUnlockIconParams = GetUpValue( GetUnlockIconParams,   "kUnlockIconParams" )
//Make adjustments
kUnlockIconParams[kTechId.HeavyMachineGunTech] = { description = "Heavy Machine Gun Researched" }

/*
kUnlockIconParams[kTechId.BabblerTech] = { description = "Babblers Researched" }
kUnlockIconParams[kTechId.WebTech] = { description = "Webs Researched" }

kUnlockIconParams[kTechId.MetabolizeEnergy] = { description = "Metabolize Researched" }
kUnlockIconParams[kTechId.MetabolizeHealth] = { description = "Advanced Metabolize Researched" }
kUnlockIconParams[kTechId.Stab] = { description = "Stab Researched" }

kUnlockIconParams[kTechId.Charge] = { description = "Charge Researched" }
kUnlockIconParams[kTechId.BoneShield] = { description = "Boneshield Researched" }
*/