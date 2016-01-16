// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Post\Globals.lua
// - Dragon

Script.Load( "lua/CompMod/Elixer_Utility.lua" )
Elixer.UseVersion( 1.8 )

//Add HMG to DeathMessage Enum
AppendToEnum( kDeathMessageIcon, 'HeavyMachineGun' )
AppendToEnum( kPlayerStatus, 'HeavyMachineGun' )