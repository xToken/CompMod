-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod_FileHooks.lua
-- - Dragon

-- Dont run from filehook calls on main menu.
if not string.find(Script.CallStack(), "Main.lua") then
	-- Setup file hooks here
	ModLoader.SetupFileHook( "lua/TechTreeConstants.lua", "lua/CompMod/FileHooks/Post/TechTreeConstants.lua", "post" )
	ModLoader.SetupFileHook( "lua/TechData.lua", "lua/CompMod/FileHooks/Post/TechData.lua", "post" )
	ModLoader.SetupFileHook( "lua/Balance.lua", "lua/CompMod/FileHooks/Post/Balance.lua", "post" )
	
	ModLoader.SetupFileHook( "lua/GUIFeedback.lua", "lua/CompMod/FileHooks/Post/GUIFeedback.lua", "post" )
	ModLoader.SetupFileHook( "lua/Hud/Marine/GUIMarineHUD.lua", "lua/CompMod/FileHooks/Post/GUIMarineHud.lua", "post" )
	
end