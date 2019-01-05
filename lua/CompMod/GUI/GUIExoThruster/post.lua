-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIExoThruster\post.lua
-- - Dragon

local kIconSize
local kIconOffset
local kTextOffset
local kIconTexture = "ui/buildmenu.dds"
local kNotReadyColor = Color(1, 0, 0, 1)
local kNotAvailableColor = Color(0.5, 0.5, 0.5, 1)
local kReadyColor = kIconColors[kMarineTeamType]
local kActiveColor = Color(0,1,0,1)

local kRepairTechId = kTechId.NanoArmor
local kShieldTechId = kTechId.NanoShield
local kThrustersTechId = kTechId.Jetpack

-- BAH
local kBackgroundOffset
local kPadding
local kPadWidth
local kPadHeight
local kBackgroundPadding
local kNumPads = 12

local function UpdateNewItemsGUIScale(self)
    kIconSize = GUIScale(Vector(80, 80, 0))
    kIconOffset = GUIScale(12)
    kTextOffset = GUIScale(-70)
    kBackgroundOffset = GUIScale(Vector(0, -100, 0))
    kPadding = math.max(1, math.round( GUIScale(3) ))
    kPadWidth = math.round( GUIScale(13) )
    kPadHeight = GUIScale(9)
    kBackgroundPadding = GUIScale(10)
end

local oldGUIExoThrusterOnResolutionChanged = GUIExoThruster.OnResolutionChanged
function GUIExoThruster:OnResolutionChanged(oldX, oldY, newX, newY)
    UpdateNewItemsGUIScale(self)
    oldGUIExoThrusterOnResolutionChanged(self, oldX, oldY, newX, newY)
end

local oldGUIExoThrusterInitialize = GUIExoThruster.Initialize
function GUIExoThruster:Initialize()
    oldGUIExoThrusterInitialize(self)
    UpdateNewItemsGUIScale(self)

    local backgroundSize = Vector(kNumPads * kPadWidth + (kNumPads - 1) * kPadding + 2 * kBackgroundPadding, 2 * kBackgroundPadding + kPadHeight, 0)
    self.background:SetPosition(-backgroundSize * 0.5 + kBackgroundOffset)

    self.shieldIcon = GetGUIManager():CreateGraphicItem()
    self.shieldIcon:SetTexture(kIconTexture)
    self.shieldIcon:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.shieldIcon:SetSize(kIconSize)
    self.shieldIcon:SetPosition(Vector(-kIconSize.x/2, -kIconOffset, 0))
    local textureCoords = GetTextureCoordinatesForIcon(kShieldTechId, true)
    self.shieldIcon:SetTexturePixelCoordinates(GUIUnpackCoords(textureCoords))
    self.background:AddChild(self.shieldIcon)

    self.shieldIconText = GetGUIManager():CreateTextItem()
    self.shieldIconText:SetFontName(Fonts.kAgencyFB_Small)
    self.shieldIconText:SetAnchor(GUIItem.Right, GUIItem.Bottom)
    self.shieldIconText:SetTextAlignmentX(GUIItem.Align_Center)
    self.shieldIconText:SetTextAlignmentY(GUIItem.Align_Center)
    self.shieldIconText:SetText(BindingsUI_GetInputValue("Use"))
    self.shieldIconText:SetPosition(Vector(0, -kTextOffset, 0))
    self.shieldIconText:SetColor( Color(0.8, 0.8, 1, 0.8) )
    self.background:AddChild(self.shieldIconText)

    self.thrustersIcon = GetGUIManager():CreateGraphicItem()
    self.thrustersIcon:SetTexture(kIconTexture)
    self.thrustersIcon:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.thrustersIcon:SetSize(kIconSize)
    self.thrustersIcon:SetPosition(Vector(-kIconSize.x/2, -kIconOffset, 0))
    textureCoords = GetTextureCoordinatesForIcon(kThrustersTechId, true)
    self.thrustersIcon:SetTexturePixelCoordinates(GUIUnpackCoords(textureCoords))
    self.background:AddChild(self.thrustersIcon)

    self.thrustersIconText = GetGUIManager():CreateTextItem()
    self.thrustersIconText:SetFontName(Fonts.kAgencyFB_Small)
    self.thrustersIconText:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    self.thrustersIconText:SetTextAlignmentX(GUIItem.Align_Center)
    self.thrustersIconText:SetTextAlignmentY(GUIItem.Align_Center)
    self.thrustersIconText:SetText(BindingsUI_GetInputValue("MovementModifier"))
    self.thrustersIconText:SetPosition(Vector(0, -kTextOffset, 0))
    self.thrustersIconText:SetColor( Color(0.8, 0.8, 1, 0.8) )
    self.background:AddChild(self.thrustersIconText)

    self.repairIcon = GetGUIManager():CreateGraphicItem()
    self.repairIcon:SetTexture(kIconTexture)
    self.repairIcon:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.repairIcon:SetSize(kIconSize)
    self.repairIcon:SetPosition(Vector(-kIconSize.x/2, -kIconOffset, 0))
    textureCoords = GetTextureCoordinatesForIcon(kRepairTechId, true)
    self.repairIcon:SetTexturePixelCoordinates(GUIUnpackCoords(textureCoords))
    self.background:AddChild(self.repairIcon)

    self.repairIconText = GetGUIManager():CreateTextItem()
    self.repairIconText:SetFontName(Fonts.kAgencyFB_Small)
    self.repairIconText:SetAnchor(GUIItem.Left, GUIItem.Bottom)
    self.repairIconText:SetTextAlignmentX(GUIItem.Align_Center)
    self.repairIconText:SetTextAlignmentY(GUIItem.Align_Center)
    self.repairIconText:SetText(BindingsUI_GetInputValue("Reload"))
    self.repairIconText:SetPosition(Vector(0, -kTextOffset, 0))
    self.repairIconText:SetColor( Color(0.8, 0.8, 1, 0.8) )
    self.background:AddChild(self.repairIconText)
    
end

function GUIExoThruster:UpdateExoThrusters(thrustersAvailable, thrustersReady, thrustersActive)
    if thrustersActive then
        self.thrustersIcon:SetColor(kActiveColor)
    elseif thrustersReady then
        self.thrustersIcon:SetColor(kReadyColor)
    elseif thrustersAvailable then
        self.thrustersIcon:SetColor(kNotReadyColor)
    else
        self.thrustersIcon:SetColor(kNotAvailableColor)
    end
end

function GUIExoThruster:UpdateExoRepair(repairAvailable, repairReady, repairActive)
    if repairActive then
        self.repairIcon:SetColor(kActiveColor)
    elseif repairReady then
        self.repairIcon:SetColor(kReadyColor)
    elseif repairAvailable then
        self.repairIcon:SetColor(kNotReadyColor)
    else
        self.repairIcon:SetColor(kNotAvailableColor)
    end
end

function GUIExoThruster:UpdateExoShield(shieldAvailable, shieldReady, shieldActive)
    if shieldActive then
        self.shieldIcon:SetColor(kActiveColor)
    elseif shieldReady then
        self.shieldIcon:SetColor(kReadyColor)
    elseif shieldAvailable then
        self.shieldIcon:SetColor(kNotReadyColor)
    else
        self.shieldIcon:SetColor(kNotAvailableColor)
    end
end


local oldGUIExoThrusterUpdate = GUIExoThruster.Update
function GUIExoThruster:Update(deltaTime)
    oldGUIExoThrusterUpdate(self, deltaTime)

    local thrustersAvailable, thrustersReady, thrustersActive = PlayerUI_GetExoThrustersAvailable()
    local repairAvailable, repairReady, repairActive = PlayerUI_GetExoRepairAvailable()
    local shieldAvailable, shieldReady, shieldActive = PlayerUI_GetExoShieldAvailable()

    if thrustersAvailable ~= self.lastThrustersAvailable or thrustersReady ~= self.lastThrustersReady or self.lastThrustersActive ~= thrustersActive then
    
        self:UpdateExoThrusters(thrustersAvailable, thrustersReady, thrustersActive)
        self.lastThrustersAvailable = thrustersAvailable
        self.lastThrustersReady = thrustersReady
        self.lastThrustersActive = thrustersActive
    end

    if repairAvailable ~= self.lastRepairAvailable or repairReady ~= self.lastRepairReady or self.lastRepairActive ~= repairActive then
    
        self:UpdateExoRepair(repairAvailable, repairReady, repairActive)
        self.lastRepairAvailable = repairAvailable
        self.lastRepairReady = repairReady
        self.lastRepairActive = repairActive
    end

    if shieldAvailable ~= self.lastShieldAvailable or shieldReady ~= self.lastShieldReady or self.lastShieldActive ~= shieldActive then
    
        self:UpdateExoShield(shieldAvailable, shieldReady, shieldActive)
        self.lastShieldAvailable = shieldAvailable
        self.lastShieldReady = shieldReady
        self.lastShieldActive = shieldActive
    end

end