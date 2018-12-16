-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Client\GUIMineDisplay.lua
-- - Dragon

Script.Load("lua/GUIScript.lua")

weaponClip = 0
weaponAuxClip = 0

class 'GUIMineDisplay' (GUIScript)

local kBackgroundColor = Color(0.302, 0.859, 1, 0.2)
local kLimitColor = Color(1, 0, 0, 1)
local kNormalColor = Color(0/255, 255/255, 33/255, 0.8)

function GUIMineDisplay:Initialize()

    self.weaponClip = 0
    self.deployedMines = 0
	
    self.background = GUIManager:CreateGraphicItem()
    self.background:SetSize( Vector(350, 512, 0) )
    self.background:SetPosition( Vector(0, 0, 0))    
    self.background:SetColor(kBackgroundColor)
    self.background:SetIsVisible(true)
    
    -- Slightly larger copy of the text for a glow effect
    self.ammoText = GUIManager:CreateTextItem()
    self.ammoText:SetFontName(Fonts.kMicrogrammaDMedExt_Large)
    self.ammoText:SetScale(Vector(1.5, 1.5, 1.5))
    self.ammoText:SetTextAlignmentX(GUIItem.Align_Center)
    self.ammoText:SetTextAlignmentY(GUIItem.Align_Center)
	self.ammoText:SetPosition(Vector(100, 0, 0))
    self.ammoText:SetAnchor(GUIItem.Left, GUIItem.Center)
    
    -- Text displaying the amount of ammo in the clip
    self.ammoText2 = GUIManager:CreateTextItem()
    self.ammoText2:SetFontName(Fonts.kMicrogrammaDMedExt_Large)
    self.ammoText2:SetScale(Vector(1.5, 1.5, 1.5))
    self.ammoText2:SetTextAlignmentX(GUIItem.Align_Center)
    self.ammoText2:SetTextAlignmentY(GUIItem.Align_Center)
	self.ammoText2:SetPosition(Vector(-100, 0, 0))
    self.ammoText2:SetAnchor(GUIItem.Right, GUIItem.Center)
	self.ammoText2:SetColor(kNormalColor)
    
    -- Force an update so our initial state is correct.
    self:Update(0)
    
end

function GUIMineDisplay:SetClip(clip)
    self.weaponClip = clip
end

function GUIMineDisplay:SetDeployedMines(count)
    self.deployedMines = count
end

function GUIMineDisplay:Update(deltaTime)

    PROFILE("GUIMineDisplay:Update")
    
    self.ammoText:SetText(string.format("%d", self.weaponClip))
    self.ammoText2:SetText(string.format("%d", self.deployedMines))
	
	if self.deployedMines ~= self.lastDeployedMines then
		if self.deployedMines >= 3 then
			self.ammoText2:SetColor(kLimitColor)
		else
			self.ammoText2:SetColor(kNormalColor)
		end
		self.lastDeployedMines = self.deployedMines
	end
    
end

mineDisplay = nil

--
-- Called by the player to update the components.
--
function Update(deltaTime)

    PROFILE("GUIMineDisplay Update")

    mineDisplay:SetClip(weaponClip)
	mineDisplay:SetDeployedMines(weaponAuxClip)
    mineDisplay:Update(deltaTime)
    
end

--
-- Initializes the player components.
--
function Initialize()

    GUI.SetSize(350, 417)
    
    mineDisplay = GUIMineDisplay()
    mineDisplay:Initialize()
    
end

Initialize()