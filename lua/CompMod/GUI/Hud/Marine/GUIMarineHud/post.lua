-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\Hud\Marine\GUIMarineHud\post.lua
-- - Dragon

-- Init calls reset... so call reset again....
local originalGUIMarineHUDInitialize
originalGUIMarineHUDInitialize = Class_ReplaceMethod("GUIMarineHUD", "Initialize",
	function(self)
		originalGUIMarineHUDInitialize(self)
		
		self.weaponTier1 = GetGUIManager():CreateGraphicItem()
		self.weaponTier1:SetTexture(GUIMarineHUD.kUpgradesTexture)
		self.weaponTier1:SetAnchor(GUIItem.Right, GUIItem.Center)
		self.weaponTier2 = GetGUIManager():CreateGraphicItem()
		self.weaponTier2:SetTexture(GUIMarineHUD.kUpgradesTexture)
		self.weaponTier2:SetAnchor(GUIItem.Right, GUIItem.Center)
		self.background:AddChild(self.weaponTier1)
		self.background:AddChild(self.weaponTier2)
		
		self.weaponTier1:SetPosition(Vector(GUIMarineHUD.kUpgradePos.x, GUIMarineHUD.kUpgradePos.y + ((GUIMarineHUD.kUpgradeSize.y + 8) * 2), 0) * self.scale)
		self.weaponTier1:SetSize(GUIMarineHUD.kUpgradeSize * self.scale)
		self.weaponTier1:SetIsVisible(false)
		
		self.weaponTier2:SetPosition(Vector(GUIMarineHUD.kUpgradePos.x + 20, GUIMarineHUD.kUpgradePos.y + ((GUIMarineHUD.kUpgradeSize.y + 8) * 2) + 10, 0) * self.scale)
		self.weaponTier2:SetSize(GUIMarineHUD.kUpgradeSize * self.scale)
		self.weaponTier2:SetIsVisible(false)
		
	end
)

local originalGUIMarineHUDReset
originalGUIMarineHUDReset = Class_ReplaceMethod("GUIMarineHUD", "Reset",
	function(self)
		originalGUIMarineHUDReset(self)
		
		if self.weaponTier1 then
			self.weaponTier1:SetPosition(Vector(GUIMarineHUD.kUpgradePos.x, GUIMarineHUD.kUpgradePos.y + ((GUIMarineHUD.kUpgradeSize.y + 8) * 2), 0) * self.scale)
			self.weaponTier1:SetSize(GUIMarineHUD.kUpgradeSize * self.scale)
			self.weaponTier1:SetIsVisible(false)
		end
		if self.weaponTier2 then
			self.weaponTier2:SetPosition(Vector(GUIMarineHUD.kUpgradePos.x + 10, GUIMarineHUD.kUpgradePos.y + ((GUIMarineHUD.kUpgradeSize.y + 8) * 2), 0) * self.scale)
			self.weaponTier2:SetSize(GUIMarineHUD.kUpgradeSize * self.scale)
			self.weaponTier2:SetIsVisible(false)
		end
	end
)

local originalGUIMarineHUDUpdate
originalGUIMarineHUDUpdate = Class_ReplaceMethod("GUIMarineHUD", "Update",
	function(self, deltaTime)
		originalGUIMarineHUDUpdate(self, deltaTime)
		
		if self.weaponTier1 then
		
			local weaponTier, tierLevel = PlayerUI_GetWeaponUpgradeTier()

			self.weaponTier1:SetIsVisible(tierLevel >= 1)
			self.weaponTier2:SetIsVisible(tierLevel >= 2)
			
			if tierLevel ~= self.tierLevel then
			
				self:ShowNewWeaponTier(weaponTier, tierLevel)
				self.tierLevel = tierLevel

			end
			
		end
	end
)

function GUIMarineHUD:ShowNewWeaponTier(weaponTier, tierLevel)

    if tierLevel >= 1 then
        local textureCoords = GetTextureCoordinatesForIcon(weaponTier, true)
        self.weaponTier1:SetIsVisible(true)
        self.weaponTier1:SetTexturePixelCoordinates(GUIUnpackCoords(textureCoords))
	end
	
	if tierLevel >= 2 then
		local textureCoords = GetTextureCoordinatesForIcon(weaponTier, true)
		self.weaponTier2:SetIsVisible(true)
		self.weaponTier2:SetTexturePixelCoordinates(GUIUnpackCoords(textureCoords))
	end

end