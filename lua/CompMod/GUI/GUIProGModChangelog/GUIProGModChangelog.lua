-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIProGModChangelog\GUIProGModChangelog.lua
-- - Dragon

class 'GUIProGModChangelog' (GUIWebView)

local kURL = "https://xtoken.github.io/CompMod/"
local kBackTexture = "ui/menu/arrow_horiz.dds"
local kBackButtonSize = Vector(16, 16, 0)
local kBackButtonColors = { [true] = Color(1, 1, 1, 1), [false] = Color(0.7, 0.7, 0.7, 1) }
local kBorderScalar = 0.8

function GUIProGModChangelog:Initialize()

    GUIWebView.Initialize(self)
    
    self.updateInterval = kUpdateIntervalAnimation

    local height = kBorderScalar * Client.GetScreenHeight()
    local width = kBorderScalar * Client.GetScreenWidth()

    self:LoadUrl(kURL, width, height)
    self:DisableMusic()
    
    self:GetBackground():SetAnchor(GUIItem.Middle, GUIItem.Center)
    self:GetBackground():SetPosition(-self:GetBackground():GetSize() / 2)
    self:GetBackground():SetLayer(kGUILayerMainMenuWeb)
    self:GetBackground():SetIsVisible(true)

    self.backBackground = GUIManager:CreateGraphicItem()
    self.backBackground:SetSize(kBackButtonSize)
    self.backBackground:SetAnchor(GUIItem.Left, GUIItem.Top)
    self.backBackground:SetPosition(Vector(2, 2, 0))
    self.backBackground:SetColor(Color(0.2, 0.2, 0.2, 1))
    self.background:AddChild(self.backBackground)

    self.back = GUIManager:CreateGraphicItem()
    self.back:SetSize(kBackButtonSize)
    self.back:SetTexture(kBackTexture)
    self.backBackground:AddChild(self.back)
    
    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)

end

-- Hook the destroy func
local Destroy = GetUpValue( GUIWebView.Uninitialize, "Destroy")
local function UpdatedDestroy(self)
    MouseTracker_SetIsVisible(false)
    Destroy(self)
    DestroyProGModChangelogGUI()
end

ReplaceUpValue(GUIWebView.Uninitialize, "Destroy", UpdatedDestroy )

function GUIProGModChangelog:Update(deltaTime)

    if self.background then
        local mouseX, mouseY = Client.GetCursorPosScreen()

        local highlight = GUIItemContainsPoint(self.back, mouseX, mouseY)
        self.back:SetColor(kBackButtonColors[highlight])
        
    end

    GUIWebView.Update(self, deltaTime)

end

function GUIProGModChangelog:SendKeyEvent(key, down, amount)

    if not self.background then
        return false
    end
    
    local isReleventKey = false
    
    if type(self.buttonDown[key]) == "boolean" then
        isReleventKey = true
    end

    local mouseX, mouseY = Client.GetCursorPosScreen()
    if isReleventKey and self.webView then
        if (key == InputKey.MouseButton0 and down and GUIItemContainsPoint(self.back, mouseX, mouseY)) then
            -- More a home then back button.. seems theres no way to get current pages to build a history :<
            self.webView:LoadUrl(kURL)
            return true
        end
    end

    return GUIWebView.SendKeyEvent(self, key, down, amount)
    
end