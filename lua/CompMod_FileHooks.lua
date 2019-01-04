-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod_FileHooks.lua
-- - Dragon

local kDirectoryReplace = { }
kDirectoryReplace['/CompMod/'] = "/"
kDirectoryReplace['/GUI/'] = "/"
kDirectoryReplace['/Mixins/'] = "/"

-- Dont run from filehook calls on main menu.
if not string.find(Script.CallStack(), "Main.lua") then
	-- Setup file hooks here
	local ReplaceFiles = { }
	Shared.GetMatchingFileNames("lua/CompMod/*replace.lua", true, ReplaceFiles)
	for i = 1, #ReplaceFiles do
		-- GSUB out compmod parent folder, and final /replace.
		local hookFileName = ReplaceFiles[i]
		for k, v in pairs(kDirectoryReplace) do
			hookFileName = string.gsub(hookFileName, k, v)
		end
		ModLoader.SetupFileHook(string.gsub(hookFileName, "/replace", ""), ReplaceFiles[i], "replace")
	end
	
	local PostHookFiles = { }
	Shared.GetMatchingFileNames("lua/CompMod/*post.lua", true, PostHookFiles)
	for i = 1, #PostHookFiles do
		-- GSUB out compmod parent folder, and final /post.
		local hookFileName = PostHookFiles[i]
		for k, v in pairs(kDirectoryReplace) do
			hookFileName = string.gsub(hookFileName, k, v)
		end
		ModLoader.SetupFileHook(string.gsub(hookFileName, "/post", ""), PostHookFiles[i], "post")
	end
end