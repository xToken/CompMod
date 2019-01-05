-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIAlienSensorBlips\GUIAlienSensorBlips.lua
-- - Dragon

class 'GUIAlienSensorBlips' (GUIScript)

GUIAlienSensorBlips.kBlipImageName = "ui/aura.dds"

GUIAlienSensorBlips.kFontName = Fonts.kArial_15

GUIAlienSensorBlips.kAlphaPerSecond = 0.8
GUIAlienSensorBlips.kImpulseIntervall = 2.5

GUIAlienSensorBlips.kRotationDuration = 5

function GUIAlienSensorBlips:Initialize()

    GUIAlienSensorBlips.kDefaultBlipSize = GUIScale(20)
    GUIAlienSensorBlips.kMaxBlipSize = GUIScale(80)

    self.updateInterval = 0
    
    self.activeBlipList = { }
    
    self.visible = true
    
end

function GUIAlienSensorBlips:SetIsVisible(state)
    
    self.visible = state
    for i=1, #self.activeBlipList do
        self.activeBlipList[i].GraphicsItem:SetIsVisible(state)
        self.activeBlipList[i].TextItem:SetIsVisible(state)
    end
    
end

function GUIAlienSensorBlips:GetIsVisible()
    
    return self.visible
    
end

function GUIAlienSensorBlips:Uninitialize()
    
    for i, blip in ipairs(self.activeBlipList) do
        GUI.DestroyItem(blip.GraphicsItem)
        GUI.DestroyItem(blip.TextItem)
    end
    self.activeBlipList = { }
    
end

function GUIAlienSensorBlips:Update(deltaTime)

    PROFILE("GUIAlienSensorBlips:Update")

    self:UpdateBlipList(AlienUI_GetSensorBlipInfo())
    
    self:UpdateAnimations(deltaTime)
    
end

function GUIAlienSensorBlips:UpdateAnimations(deltaTime)

    PROFILE("GUIAlienSensorBlips:UpdateAnimations")
    
    local baseRotationPercentage = (Shared.GetTime() % GUIAlienSensorBlips.kRotationDuration) / GUIAlienSensorBlips.kRotationDuration
    
    if not self.timeLastImpulse then
        self.timeLastImpulse = Shared.GetTime()
    end
    
    if self.timeLastImpulse + GUIAlienSensorBlips.kImpulseIntervall < Shared.GetTime() then
        self.timeLastImpulse = Shared.GetTime()
    end  

    local destAlpha = math.max(0, 1 - (Shared.GetTime() - self.timeLastImpulse) * GUIAlienSensorBlips.kAlphaPerSecond)  
    
    for i, blip in ipairs(self.activeBlipList) do
        local size = math.min(blip.Radius * GUIAlienSensorBlips.kDefaultBlipSize, GUIAlienSensorBlips.kMaxBlipSize)
        blip.GraphicsItem:SetSize(Vector(size, size, 0))
        
        -- Offset by size / 2 so the blip is centered.
        local newPosition = Vector(blip.ScreenX - size / 2, blip.ScreenY - size / 2, 0)
        blip.GraphicsItem:SetPosition(newPosition)
        
        -- rotate the blip
        blip.GraphicsItem:SetRotation(Vector(0, 0, 2 * math.pi * (baseRotationPercentage + (i / #self.activeBlipList))))

        -- Draw blips as barely visible when in view, to communicate their purpose. Animate color towards final value.
        local currentColor = blip.GraphicsItem:GetColor()
        destAlpha = ConditionalValue(blip.Obstructed, destAlpha * blip.Radius, currentColor.a - GUIAlienSensorBlips.kAlphaPerSecond * deltaTime)

        currentColor.a = destAlpha
        blip.GraphicsItem:SetColor(currentColor)
        blip.TextItem:SetColor(currentColor)
        
    end
    
end

function GUIAlienSensorBlips:UpdateBlipList(activeBlips)

    PROFILE("GUIAlienSensorBlips:UpdateBlipList")
    
    local numElementsPerBlip = 5
    local numBlips = table.icount(activeBlips) / numElementsPerBlip
    
    while numBlips > table.icount(self.activeBlipList) do
        local newBlipItem = self:CreateBlipItem()
        table.insert(self.activeBlipList, newBlipItem)
    end
    
    while numBlips < table.icount(self.activeBlipList) do
        GUI.DestroyItem(self.activeBlipList[#self.activeBlipList].GraphicsItem)
        table.remove(self.activeBlipList, #self.activeBlipList)
    end
    
    -- Update current blip state.
    local currentIndex = 1
    while numBlips > 0 do
        local updateBlip = self.activeBlipList[numBlips]
        updateBlip.ScreenX = activeBlips[currentIndex]
        updateBlip.ScreenY = activeBlips[currentIndex + 1]
        updateBlip.Radius = activeBlips[currentIndex + 2]
        updateBlip.Obstructed = activeBlips[currentIndex + 3]
        updateBlip.name = activeBlips[currentIndex + 4]
        
        --updateBlip.TextItem:SetText( activeBlips[currentIndex + 4] )
        
        numBlips = numBlips - 1
        currentIndex = currentIndex + numElementsPerBlip
    end

end

function GUIAlienSensorBlips:OnResolutionChanged(oldX, oldY, newX, newY)
    self:Uninitialize()
    self:Initialize()
end

function GUIAlienSensorBlips:CreateBlipItem()

    local newBlip = { ScreenX = 0, ScreenY = 0, Radius = 0, Type = 0 }
    newBlip.GraphicsItem = GUIManager:CreateGraphicItem()
    newBlip.GraphicsItem:SetAnchor(GUIItem.Left, GUIItem.Top)
    newBlip.GraphicsItem:SetTexture(GUIAlienSensorBlips.kBlipImageName)
    newBlip.GraphicsItem:SetBlendTechnique(GUIItem.Add)
    newBlip.GraphicsItem:SetIsVisible(self.visible)
    newBlip.GraphicsItem:SetColor(Color(1, 0.9, 0.4, 1))

    newBlip.TextItem = GUIManager:CreateTextItem()
    newBlip.TextItem:SetAnchor(GUIItem.Middle, GUIItem.Top)
    newBlip.TextItem:SetFontName(GUIAlienSensorBlips.kFontName)
    newBlip.TextItem:SetScale(GetScaledVector())
    newBlip.TextItem:SetTextAlignmentX(GUIItem.Align_Center)
    newBlip.TextItem:SetTextAlignmentY(GUIItem.Align_Min)
    newBlip.TextItem:SetColor(Color(1, 0.9, 0.4, 1))
    newBlip.TextItem:SetIsVisible(self.visible)
    GUIMakeFontScale(newBlip.TextItem)
    
    newBlip.GraphicsItem:AddChild(newBlip.TextItem)

    return newBlip
    
end
