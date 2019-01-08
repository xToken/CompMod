-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIChangelog\GUIChangelog.lua
-- - Dragon

class 'GUIChangelog' (Window)

local kTextureName = "*credits_webpage_render"
local kURL = "https://xtoken.github.io/CompMod/"
local kBorderScalar = 0.8

function GUIChangelog:Initialize()

    Window.Initialize(self)
    
    self.updateInterval = kUpdateIntervalAnimation
    
    local height = kBorderScalar * Client.GetScreenHeight()
    local width = kBorderScalar * Client.GetScreenWidth()
    self.webView = Client.CreateWebView(width, height)
    self.webView:SetTargetTexture(kTextureName)
    self.webView:LoadUrl(kURL)
    
    self.webContainer = GUIManager:CreateGraphicItem()
    self.webContainer:SetSize(Vector(width, height, 0))
    self.webContainer:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.webContainer:SetPosition(Vector(-width/2, -height/2, 0))
    self.webContainer:SetTexture(kTextureName)
    self.webContainer:SetIsVisible(true)

    self.buttonDown = { [InputKey.MouseButton0] = false, [InputKey.MouseButton1] = false, [InputKey.MouseButton2] = false }

    MouseTracker_SetIsVisible(true, "ui/Cursor_MenuDefault.dds", true)

end

function GUIChangelog:SendKeyEvent(key, down, amount)

    if not self.isVisible or not MainMenu_GetIsOpened() then
        return
    end
    
    local isScrollingKey = false
    
    if type(self.buttonDown[key]) == "boolean" then
        isScrollingKey = true
    end

    local mouseX, mouseY = Client.GetCursorPosScreen()
    if isScrollingKey then
    
        local containsPoint, withinX, withinY = GUIItemContainsPoint(self.webContainer, mouseX, mouseY)
        
        -- If we pressed the button inside the window, always send it the button up
        -- even if the cursor was outside the window.
        if containsPoint or (not down and self.buttonDown[key]) then
        
            local buttonCode = key - InputKey.MouseButton0
            if down then
                self.webView:OnMouseDown(buttonCode)
            else
                self.webView:OnMouseUp(buttonCode)
            end
            
            self.buttonDown[key] = down
            
            return true
            
        end

    elseif key == InputKey.Escape then

        playAnimation = ""
        fadeColor = Color(1,1,1,0)
        lastUpdatedtime = 0

        SetKeyEventBlocker(nil)

        local mainMenu = GetGUIMainMenu()
        if mainMenu then
            mainMenu:ShowMenu()
        end

        GetGUIManager():DestroyGUIScript(self)
        return true
            
    elseif key == InputKey.MouseWheelUp then
        self.webView:OnMouseWheel(30, 0)
        MainMenu_OnSlide()
    elseif key == InputKey.MouseWheelDown then
        self.webView:OnMouseWheel(-30, 0)
        MainMenu_OnSlide()
    end
    
    return false
end

function GUIChangelog:Uninitialize()

    GUI.DestroyItem(self.webContainer)
    self.webContainer = nil
    
    Client.DestroyWebView(self.webView)
    self.webView = nil
    GetGUIManager():DestroyGUIScript(self)

    MouseTracker_SetIsVisible(false)

end

function GUIChangelog:Update()

    if fadeColor.a < 1 then
        self:SetIsVisible(false)
    elseif fadeColor.a > 0 then
        self:SetIsVisible(true)
    end
    
    self:PlayFadeAnimation()
    
    if not self.isVisible or not MainMenu_GetIsOpened() then
        return
    end
    
    -- don't show until the URL is loaded
    if not self.webContainer:GetIsVisible() then
            self.webView:OnMouseWheel(5000, 0)
        if self.webView:GetUrlLoaded() then
            self.webContainer:SetIsVisible(true)
        end
    end

    local mouseX, mouseY = Client.GetCursorPosScreen()
    local containsPoint, withinX, withinY = GUIItemContainsPoint(self.webContainer, mouseX, mouseY)
    if containsPoint or self.buttonDown[InputKey.MouseButton0] or self.buttonDown[InputKey.MouseButton1] or self.buttonDown[InputKey.MouseButton2] then
        self.webView:OnMouseMove(withinX, withinY)
    end
    
    if GUIItemContainsPoint( self.webContainer, mouseX, mouseY ) then
        SetKeyEventBlocker(self)
    else
        SetKeyEventBlocker(nil)
    end
    
end

function GUIChangelog:ShowAnimation()

    if fadeColor.a <= 1 and Shared.GetTime() - lastUpdatedtime > 0.005 then
        fadeColor.a = fadeColor.a + 0.075
        self.webContainer:SetColor(fadeColor)
        lastUpdatedtime = Shared.GetTime()
    end

end

function GUIChangelog:HideAnimation()

    if fadeColor.a >= 0 and Shared.GetTime() - lastUpdatedtime > 0.005 then
        fadeColor.a = fadeColor.a - 0.075
        self.webContainer:SetColor(fadeColor)
        lastUpdatedtime = Shared.GetTime()
    end
   
end
function GUIChangelog:PlayFadeAnimation()

    if playAnimation == "show" then
        self:ShowAnimation()
    elseif playAnimation == "hide" then
        self:HideAnimation()
    end
   
end

function GUIChangelog:SetPlayAnimation(animType)
    playAnimation = animType
end

function GUIChangelog:SetIsVisible(visible)
    self.isVisible = visible
end