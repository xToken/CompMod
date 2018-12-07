-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod_FileHooks.lua
-- - Dragon

-- Dont run from filehook calls on main menu.
if not string.find(Script.CallStack(), "Main.lua") then
	-- Setup file hooks here
	ModLoader.SetupFileHook( "lua/GUIFeedback.lua", "lua/CompMod/Post/GUIBuildVersion.lua", "post" )
end