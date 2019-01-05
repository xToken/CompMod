-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUISelectionPanel\post.lua
-- - Dragon

local originalGUISelectionPanelInit
originalGUISelectionPanelInit = Class_ReplaceMethod("GUISelectionPanel", "Initialize",
function(self)
	originalGUISelectionPanelInit(self)
	GUISelectionPanel.kMaturityTextPos = Vector(6, 40, 0) * GUIScale(kCommanderGUIsGlobalScale) + GUISelectionPanel.kArmorIconPos
	self.maturity:SetPosition(GUISelectionPanel.kMaturityTextPos)
end)