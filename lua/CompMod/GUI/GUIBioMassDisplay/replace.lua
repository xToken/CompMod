-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIBioMassDisplay\replace.lua
-- - Dragon

class 'GUIBioMassDisplay' (GUIScript)

function GUIBioMassDisplay:Initialize()

    GUIScript.Initialize(self)
    
    self.smokeyBackground = GUIManager:CreateGraphicItem()
    self.smokeyBackground:SetIsVisible(false) -- prevent 1-frame pop-in
    
    self.background = GetGUIManager():CreateGraphicItem()
    self.background:SetIsVisible(false)

    self.smokeyBackground:SetSize(Vector(0, 0, 0))
    self.background:SetSize(Vector(0, 0, 0))

end

function GUIBioMassDisplay:Uninitialize()

    if self.background then
        GUI.DestroyItem(self.background)
        self.background = nil
    end
    
    if self.smokeyBackground then
        GUI.DestroyItem(self.smokeyBackground)
        self.smokeyBackground = nil    
    end

end

function GUIBioMassDisplay:Update(deltaTime)
        
    self.background:SetIsVisible(false)
    self.smokeyBackground:SetIsVisible(false)

end