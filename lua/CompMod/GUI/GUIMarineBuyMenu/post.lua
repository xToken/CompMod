-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIMarineBuyMenu\post.lua
-- - Dragon

local originalGUIMarineBuyMenu_UpdateItemButtons
originalGUIMarineBuyMenu_UpdateItemButtons = Class_ReplaceMethod("GUIMarineBuyMenu", "_UpdateItemButtons",
	function(self, deltaTime)
		originalGUIMarineBuyMenu_UpdateItemButtons(self, deltaTime)
		
		if self.itemButtons then
			for i, item in ipairs(self.itemButtons) do
				item.Cost:SetText(ToString(MarineBuy_GetCosts(item.TechId)))
			end
		end
	end
)