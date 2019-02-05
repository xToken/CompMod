-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIInsight_OtherHealthbars\post.lua
-- - Dragon

local kOtherTypes = GetUpValue(GUIInsight_OtherHealthbars.Update, "kOtherTypes")
local kOtherHealthBarTextureSize = GetUpValue(GUIInsight_OtherHealthbars.Update, "kOtherHealthBarTextureSize")

local originalGUIInsight_OtherHealthbarsUpdate = GUIInsight_OtherHealthbars.Update
function GUIInsight_OtherHealthbars:Update(deltaTime)
	originalGUIInsight_OtherHealthbarsUpdate(self, deltaTime)

    for i = 1, #kOtherTypes do

        local others = Shared.GetEntitiesWithClassname(kOtherTypes[i])
        -- Add new and Update all units
        
        for _, other in ientitylist(others) do
            local otherIndex = other:GetId()
            local otherGUI = self.otherList[otherIndex]
            local relevant = other:GetIsVisible() and self.isVisible and other:GetIsAlive() and other.GetMaturityFraction
            if relevant then
                local maxHealth = other:GetMaxHealth() + other:GetMaxArmor() * kHealthPointsPerArmor
                local barScale = maxHealth/2400
                local backgroundSize = math.max(self.kOtherHealthBarSize.x, barScale * self.kOtherHealthBarSize.x)
                local maturityBar = otherGUI.MaturityBar
                local maturityFraction = other:GetMaturityFraction()
                local maturitySize =  maturityFraction * backgroundSize - GUIScale(2)
                local maturityBarTextureSize = maturityFraction * kOtherHealthBarTextureSize.x
                maturityBar:SetTexturePixelCoordinates(0, 0, maturityBarTextureSize, kOtherHealthBarTextureSize.y)
                maturityBar:SetSize(Vector(maturitySize, self.kOtherHealthBarSize.y, 0))
                maturityBar:SetIsVisible(true)
                if maturityFraction > kMaturityFlourishingThreshold then
                    maturityBar:SetColor(Color(0,1,0,1))
                elseif maturityFraction > kMaturityStarvingThreshold then
                    maturityBar:SetColor(Color(1,1,0,1))
                else
                    maturityBar:SetColor(Color(1,0,0,1))
                end
                otherGUI.Background:SetSize(Vector(backgroundSize, self.kOtherHealthBarSize.y * 2 + 1, 0))
            elseif otherGUI and otherGUI.MaturityBar then
                otherGUI.MaturityBar:SetIsVisible(false)
            end
        end
    end

end

local oldGUIInsight_OtherHealthbarsCreateOtherGUIItem = GUIInsight_OtherHealthbars.CreateOtherGUIItem
function GUIInsight_OtherHealthbars:CreateOtherGUIItem()
    local items = oldGUIInsight_OtherHealthbarsCreateOtherGUIItem(self)

    if not items.MaturityBar then
        local neutralTexture = "ui/healthbarsmall.dds"      
        items.MaturityBar = GUIManager:CreateGraphicItem()
        items.MaturityBar:SetColor(Color(0,1,0,1))
        items.MaturityBar:SetPosition(Vector(GUIScale(1),kOtherHealthBarTextureSize.y,0))
        items.MaturityBar:SetTexture(neutralTexture)
        items.MaturityBar:SetTexturePixelCoordinates(GUIUnpackCoords(GUIUnitStatus.kUnitStatusBarTexCoords))
        items.MaturityBar:SetBlendTechnique(GUIItem.Add)
        items.Background:AddChild(items.MaturityBar)
        items.StoredValues.MaturityFraction = 0
    end

    return items
end