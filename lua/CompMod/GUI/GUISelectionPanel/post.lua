-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUISelectionPanel\post.lua
-- - Dragon

local kSustenanceHelperTexture = PrecacheAsset("ui/alien_selection_sustenance.dds")
local kSustenanceHelperTextureSize = Vector(128, 128, 0)
local redColor = Color(1, 0, 0, 1)
local mediumColor = kAlienFontColor
local highColor = Color(237/255, 206/255, 142/255, 1)

local originalGUISelectionPanelInit
originalGUISelectionPanelInit = Class_ReplaceMethod("GUISelectionPanel", "Initialize",
	function(self)
		originalGUISelectionPanelInit(self)

		if self.teamType == kAlienTeamType then
			GUISelectionPanel.kMaturityTextPos = Vector(6, 40, 0) * GUIScale(kCommanderGUIsGlobalScale) + GUISelectionPanel.kArmorIconPos
			--GUISelectionPanel.kSustenanceIconXOffset = 0 * GUIScale(kCommanderGUIsGlobalScale)
		    GUISelectionPanel.kSustenanceIconYOffset = -50 * GUIScale(kCommanderGUIsGlobalScale)
		    GUISelectionPanel.kSustenanceIconSize = 128 * GUIScale(kCommanderGUIsGlobalScale)
		    --GUISelectionPanel.kSelectedIconYOffset = 70 * GUIScale(kCommanderGUIsGlobalScale)
		    GUISelectionPanel.kSustenanceLowFontScale = Vector(1, 1, 0) * GUIScale(kCommanderGUIsGlobalScale)
		    GUISelectionPanel.kSustenanceMediumFontScale = Vector(1, 1, 0) * GUIScale(kCommanderGUIsGlobalScale) * 1.05
		    GUISelectionPanel.kSustenanceHighFontScale = Vector(1, 1, 0) * GUIScale(kCommanderGUIsGlobalScale) * 1.1
		    GUISelectionPanel.kSelectedNameYOffset = GUIScale(50)
		    GUISelectionPanel.kSustenanceNameYOffset = GUIScale(10)
		    GUISelectionPanel.kSustenanceNameXOffset = GUIScale(10)

			self.maturity:SetPosition(GUISelectionPanel.kMaturityTextPos)
			self.selectedName:SetPosition(Vector(0, GUISelectionPanel.kSelectedNameYOffset, 0))
			--self.selectedIcon:SetPosition(Vector(GUISelectionPanel.kSelectedIconXOffset, GUISelectionPanel.kSelectedIconYOffset, 0))
			-- Sustenance helper icon
			self.sustenanceIcon = GUIManager:CreateGraphicItem()
		    self.sustenanceIcon:SetAnchor(GUIItem.Left, GUIItem.Top)
		    self.sustenanceIcon:SetSize(Vector(GUISelectionPanel.kSustenanceIconSize, GUISelectionPanel.kSustenanceIconSize, 0))
		    self.sustenanceIcon:SetPosition(Vector(0, GUISelectionPanel.kSustenanceIconYOffset, 0))
		    self.sustenanceIcon:SetTexture(kSustenanceHelperTexture)
		    table.insert(self.singleSelectionItems, self.sustenanceIcon)
		    self.sustenanceIcon:SetIsVisible(false)
		    self.background:AddChild(self.sustenanceIcon)

		    self.sustenanceName = GUIManager:CreateTextItem()
		    self.sustenanceName:SetFontName(GUISelectionPanel.kFontName)
		    self.sustenanceName:SetScale(GUISelectionPanel.kSustenanceLowFontScale)
		    GUIMakeFontScale(self.sustenanceName)
		    self.sustenanceName:SetAnchor(GUIItem.Middle, GUIItem.Top)
		    self.sustenanceName:SetPosition(Vector(GUISelectionPanel.kSustenanceNameXOffset, GUISelectionPanel.kSustenanceNameYOffset, 0))
		    self.sustenanceName:SetTextAlignmentX(GUIItem.Align_Center)
		    self.sustenanceName:SetTextAlignmentY(GUIItem.Align_Center)
		    self.sustenanceName:SetColor(redColor)
		    table.insert(self.singleSelectionItems, self.sustenanceName)
		    self.background:AddChild(self.sustenanceName)
		end

	end
)

local originalGUISelectionUpdateSingleSelection
originalGUISelectionUpdateSingleSelection = Class_ReplaceMethod("GUISelectionPanel", "UpdateSingleSelection",
	function(self, entity)
		originalGUISelectionUpdateSingleSelection(self, entity)

		if self.teamType == kAlienTeamType then
			local selectedBargraphs = CommanderUI_GetSelectedBargraphs(entity)
		    local statusPercentage = selectedBargraphs[2]
		    
		    if table.icount(selectedBargraphs) <= 2 and not statusPercentage and entity.GetMaturityLevel then
		    	local sustenanceLevel = 0
		    	local sustenance = entity:GetMaturityLevel()
		    	if sustenance == kMaturityLevel.Producing then sustenanceLevel = 1 end
		    	if sustenance == kMaturityLevel.Flourishing then sustenanceLevel = 2 end
		    	self.sustenanceIcon:SetIsVisible(true)
		    	self.sustenanceName:SetIsVisible(true)
		    	self.sustenanceIcon:SetTexturePixelCoordinates(0, 
		    			sustenanceLevel * kSustenanceHelperTextureSize.y, 
		    			kSustenanceHelperTextureSize.x, 
		    			kSustenanceHelperTextureSize.y + sustenanceLevel * kSustenanceHelperTextureSize.y)
		    	if sustenanceLevel == 0 then
		    		self.sustenanceName:SetColor(redColor)
		    		self.sustenanceName:SetText(Locale.ResolveString("STARVING"))
		    		self.sustenanceName:SetScale(GUISelectionPanel.kSustenanceLowFontScale)
		    	elseif sustenanceLevel == 1 then
		    		self.sustenanceName:SetColor(mediumColor)
		    		self.sustenanceName:SetText(Locale.ResolveString("PRODUCING"))
		    		self.sustenanceName:SetScale(GUISelectionPanel.kSustenanceMediumFontScale)
		    	elseif sustenanceLevel == 2 then
		    		self.sustenanceName:SetColor(highColor)
		    		self.sustenanceName:SetText(Locale.ResolveString("MATURED"))
		    		self.sustenanceName:SetScale(GUISelectionPanel.kSustenanceHighFontScale)
		    	end
			else
				self.sustenanceIcon:SetIsVisible(false)
				self.sustenanceName:SetIsVisible(false)
		    end
		end

	end
)