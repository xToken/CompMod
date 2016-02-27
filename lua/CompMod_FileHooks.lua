// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod_FileHooks.lua
// - Dragon

if not string.find(Script.CallStack(), "Main.lua") then
	ModLoader.SetupFileHook( "lua/Globals.lua", "lua/CompMod/Post/Globals.lua", "post" )
	ModLoader.SetupFileHook( "lua/ConstructMixin.lua", "lua/CompMod/Post/ConstructMixin.lua", "post" )
	//BetterDoors
	ModLoader.SetupFileHook( "lua/Door.lua", "lua/CompMod/Replace/Door.lua", "replace" )
	//Predict Collision fixes 'lib' needs to know when Predict VM is fully loaded.  No such callback exists afaik.
	if Predict then
		ModLoader.SetupFileHook( "lua/PostLoadMod.lua", "lua/CompMod/Predict/predict_loaded.lua", "post" )
	end
end
