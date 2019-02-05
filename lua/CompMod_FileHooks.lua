-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua/CompMod_FileHooks.lua
-- - Dragon

-- Dont run from filehook calls on main menu.
if not string.find(Script.CallStack(), "Main.lua") then
	-- Setup file hooks here
	-- Replace
	ModLoader.SetupFileHook("lua/Door.lua", "lua/CompMod/Door/replace.lua", "replace")
	ModLoader.SetupFileHook("lua/InputHandler.lua", "lua/CompMod/InputHandler/replace.lua", "replace")
	ModLoader.SetupFileHook("lua/DetectableMixin.lua", "lua/CompMod/Mixins/DetectableMixin/replace.lua", "replace")
	ModLoader.SetupFileHook("lua/GUIBioMassDisplay.lua", "lua/CompMod/GUI/GUIBioMassDisplay/replace.lua", "replace")
	ModLoader.SetupFileHook("lua/AlienTechMap.lua", "lua/CompMod/TechMaps/AlienTechMap/replace.lua", "replace")
	ModLoader.SetupFileHook("lua/MarineTechMap.lua", "lua/CompMod/TechMaps/MarineTechMap/replace.lua", "replace")
	ModLoader.SetupFileHook("lua/PowerPoint.lua", "lua/CompMod/Structures/Marine/PowerPoint/replace.lua", "replace")
	-- Post
	ModLoader.SetupFileHook("lua/Balance.lua", "lua/CompMod/Balance/post.lua", "post")
	ModLoader.SetupFileHook("lua/GUIAlienBuyMenu.lua", "lua/CompMod/GUI/GUIAlienBuyMenu/post.lua", "post")
	ModLoader.SetupFileHook("lua/GUIAlienHUD.lua", "lua/CompMod/GUI/GUIAlienHUD/post.lua", "post")
	ModLoader.SetupFileHook("lua/GUIAuraDisplay.lua", "lua/CompMod/GUI/GUIAuraDisplay/post.lua", "post")
	ModLoader.SetupFileHook("lua/GUIExoThruster.lua", "lua/CompMod/GUI/GUIExoThruster/post.lua", "post")
	ModLoader.SetupFileHook("lua/GUIFeedback.lua", "lua/CompMod/GUI/GUIFeedback/post.lua", "post")
	ModLoader.SetupFileHook("lua/GUIInsight_PlayerFrames.lua", "lua/CompMod/GUI/GUIInsight_PlayerFrames/post.lua", "post")
	ModLoader.SetupFileHook("lua/GUIInsight_OtherHealthbars.lua", "lua/CompMod/GUI/GUIInsight_OtherHealthbars/post.lua", "post")
	ModLoader.SetupFileHook("lua/GUIMarineBuyMenu.lua", "lua/CompMod/GUI/GUIMarineBuyMenu/post.lua", "post")
	ModLoader.SetupFileHook("lua/GUISelectionPanel.lua", "lua/CompMod/GUI/GUISelectionPanel/post.lua", "post")
	ModLoader.SetupFileHook("lua/GUITechMap.lua", "lua/CompMod/GUI/GUITechMap/post.lua", "post")
	ModLoader.SetupFileHook("lua/GUIUnitStatus.lua", "lua/CompMod/GUI/GUIUnitStatus/post.lua", "post")
	ModLoader.SetupFileHook("lua/GUIUpgradeChamberDisplay.lua", "lua/CompMod/GUI/GUIUpgradeChamberDisplay/post.lua", "post")
	ModLoader.SetupFileHook("lua/Hud/GUIEvent.lua", "lua/CompMod/GUI/Hud/GUIEvent/post.lua", "post")
	ModLoader.SetupFileHook("lua/Hud/Marine/GUIMarineHud.lua", "lua/CompMod/GUI/Hud/Marine/GUIMarineHud/post.lua", "post")
	ModLoader.SetupFileHook("lua/InfestationMixin.lua", "lua/CompMod/Mixins/InfestationMixin/post.lua", "post")
	ModLoader.SetupFileHook("lua/MaturityMixin.lua", "lua/CompMod/Mixins/MaturityMixin/post.lua", "post")
	ModLoader.SetupFileHook("lua/CatalystMixin.lua", "lua/CompMod/Mixins/CatalystMixin/post.lua", "post")
	ModLoader.SetupFileHook("lua/FireMixin.lua", "lua/CompMod/Mixins/FireMixin/post.lua", "post")
	ModLoader.SetupFileHook("lua/TechData.lua", "lua/CompMod/TechData/post.lua", "post")
	ModLoader.SetupFileHook("lua/TechTreeConstants.lua", "lua/CompMod/TechTreeConstants/post.lua", "post")
end