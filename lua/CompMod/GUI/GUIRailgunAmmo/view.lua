-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIRailgunAmmo\view.lua
-- - Dragon

Script.Load("lua/GUIDial.lua")

local kRailgunMaxAmmo = 6

local kTexture = "models/marine/exosuit/exosuit_view_panel_rail2.dds"

local shootSquares = { }
local cooldownSquares = { }
local kGoodColor = Color(0.8, 0.96, 1, 1)
local kEmptyColor = Color(1, 0, 0, 1)

function UpdateAmmoDisplay(dt, ammoAmount, ammoTime)

    PROFILE("GUIRailgunAmmo:UpdateAmmoDisplay")
        
    for s = 1, #cooldownSquares do
        cooldownSquares[s]:SetColor(ammoAmount >= s and kGoodColor or kEmptyColor)
    end

    if ammoAmount == kRailgunMaxAmmo then ammoTime = 0 end

    chargeCircle:SetPercentage(ammoTime)
    chargeCircle:Update(dt)
    
end

local kWidth = 246
local kHeight = 256
local kTexWidth = 450
local kTexHeight = 452
function Initialize()

    GUI.SetSize(kWidth, kHeight)

    local chargeCircleSettings = { }
    chargeCircleSettings.BackgroundWidth = kWidth
    chargeCircleSettings.BackgroundHeight = kHeight
    chargeCircleSettings.BackgroundAnchorX = GUIItem.Left
    chargeCircleSettings.BackgroundAnchorY = GUIItem.Bottom
    chargeCircleSettings.BackgroundOffset = Vector(0, 0, 0)
    chargeCircleSettings.BackgroundTextureName = kTexture
    chargeCircleSettings.BackgroundTextureX1 = 0
    chargeCircleSettings.BackgroundTextureY1 = 0
    chargeCircleSettings.BackgroundTextureX2 = kTexWidth
    chargeCircleSettings.BackgroundTextureY2 = kTexHeight
    chargeCircleSettings.ForegroundTextureName = kTexture
    chargeCircleSettings.ForegroundTextureWidth = kTexWidth
    chargeCircleSettings.ForegroundTextureHeight = kTexHeight
    chargeCircleSettings.ForegroundTextureX1 = kTexWidth
    chargeCircleSettings.ForegroundTextureY1 = 0
    chargeCircleSettings.ForegroundTextureX2 = kTexWidth * 2
    chargeCircleSettings.ForegroundTextureY2 = kTexHeight
    chargeCircleSettings.InheritParentAlpha = true

    chargeCircle = GUIDial()
    chargeCircle:Initialize(chargeCircleSettings)
    chargeCircle:GetBackground():SetIsVisible(true)

    local x = 80
    for s = 1, kRailgunMaxAmmo do
    
        table.insert(shootSquares, GUIManager:CreateGraphicItem())
        table.insert(cooldownSquares, GUIManager:CreateGraphicItem())
        
        shootSquares[s]:SetSize(Vector(15, 48, 0))
        cooldownSquares[s]:SetSize(Vector(15, 48, 0))
        shootSquares[s]:SetTexturePixelCoordinates(900, 0, 936, 87)
        cooldownSquares[s]:SetTexturePixelCoordinates(900, 89, 936, 176)
        shootSquares[s]:SetPosition(Vector(x, 100, 0))
        cooldownSquares[s]:SetPosition(Vector(x, 100, 0))
        x = x + 17
        shootSquares[s]:SetTexture(kTexture)
        cooldownSquares[s]:SetTexture(kTexture)
        
        cooldownSquares[s]:SetIsVisible(true)
        
    end
    
end

Initialize()