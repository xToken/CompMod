// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Client\MarineCommanderAdjustments.lua
// - Dragon

local function SetupCommanderOverrides()
	local oldGUISelectionPanelUpdateSingleSelection = GUISelectionPanel.UpdateSingleSelection
	function GUISelectionPanel:UpdateSingleSelection(entity)
		oldGUISelectionPanelUpdateSingleSelection(self, entity)
		local showEnergy = entity and HasMixin(entity, "Energy")
		local energy = CommanderUI_GetSelectedEnergy(entity)
		
		self.energyText:SetIsVisible(showEnergy)
		self.energyText:SetText(energy)
		self.energyIcon:SetIsVisible(showEnergy)
	end
end

AddPostInitOverride("GUISelectionPanel", SetupCommanderOverrides)