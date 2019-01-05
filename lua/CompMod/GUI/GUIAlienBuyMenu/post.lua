-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIAlienBuyMenu\post.lua
-- - Dragon

local function CreateSlot(self, category)

    local graphic = GUIManager:CreateGraphicItem()
    graphic:SetSize(Vector(GUIAlienBuyMenu.kSlotSize, GUIAlienBuyMenu.kSlotSize, 0))
    graphic:SetTexture(GUIAlienBuyMenu.kSlotTexture)
    graphic:SetLayer(kGUILayerPlayerHUDForeground3)
    graphic:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.background:AddChild(graphic)

    table.insert(self.slots, { Graphic = graphic, Category = category } )


end

function GUIAlienBuyMenu:_InitializeSlots()

    self.slots = {}

    CreateSlot(self, kTechId.DefensiveTraits)
    CreateSlot(self, kTechId.OffensiveTraits)
    CreateSlot(self, kTechId.MovementTraits)

    local anglePerSlot = (math.pi * 0.6) / (#self.slots-1)

    for i = 1, #self.slots do

        local angle = (i-1) * anglePerSlot + math.pi * 0.2
        local distance = GUIAlienBuyMenu.kSlotDistance

        self.slots[i].Graphic:SetPosition( Vector( math.cos(angle) * distance - GUIAlienBuyMenu.kSlotSize * .5, math.sin(angle) * distance - GUIAlienBuyMenu.kSlotSize * .5, 0) )
        self.slots[i].Angle = angle

    end


end

local GetHasAnyCathegoryUpgrade = GetUpValue( GUIAlienBuyMenu._UpdateUpgrades, "GetHasAnyCathegoryUpgrade")
local GetUpgradeCostForLifeForm = GetUpValue( GUIAlienBuyMenu._UpdateUpgrades, "GetUpgradeCostForLifeForm")

local kDefaultColor = GetUpValue( GUIAlienBuyMenu._UpdateUpgrades, "kDefaultColor")
local kNotAvailableColor = GetUpValue( GUIAlienBuyMenu._UpdateUpgrades, "kNotAvailableColor")
local kPurchasedColor = GetUpValue( GUIAlienBuyMenu._UpdateUpgrades, "kPurchasedColor")
local kNotAllowedColor = Color(1, 0, 0, 1)

function GUIAlienBuyMenu:_UpdateUpgrades(deltaTime)

    local categoryHasSelected = {}

    for i, currentButton in ipairs(self.upgradeButtons) do

        local useColor = kDefaultColor

        if currentButton.Purchased then
            useColor = kPurchasedColor

        elseif not AlienBuy_GetTechAvailable(currentButton.TechId) then
            useColor = kNotAvailableColor

            -- unselect button if tech becomes unavailable
            if currentButton.Selected then
                currentButton.Selected = false
            end

        elseif not currentButton.Selected and not AlienBuy_GetIsUpgradeAllowed(currentButton.TechId, self.upgradeList) then
            useColor = kNotAllowedColor
        end

        currentButton.Icon:SetColor(useColor)

        if currentButton.Selected then
            categoryHasSelected[ currentButton.Category ] = true
            currentButton.Icon:SetPosition(currentButton.SelectedPosition)
        else
            currentButton.Icon:SetPosition(currentButton.UnselectedPosition)
        end

        if self:_GetIsMouseOver(currentButton.Icon) then

            local currentUpgradeInfoText = GetDisplayNameForTechId(currentButton.TechId)
            local tooltipText = GetTooltipInfoText(currentButton.TechId)

            --local health = LookupTechData(currentButton.TechId, kTechDataMaxHealth)
            --local armor = LookupTechData(currentButton.TechId, kTechDataMaxArmor)

            self:_ShowMouseOverInfo(currentUpgradeInfoText, tooltipText, GetUpgradeCostForLifeForm(Client.GetLocalPlayer(), self.selectedAlienType, currentButton.TechId))

        end

    end


    for i, slot in ipairs(self.slots) do

        if categoryHasSelected[ slot.Category ] or (GetHasAnyCathegoryUpgrade(slot.Category) and AlienBuy_GetIsUpgradeAllowed(slot.Category, self.upgradeList)) then
            slot.Graphic:SetTexture(GUIAlienBuyMenu.kSlotTexture)
        else
            slot.Graphic:SetTexture(GUIAlienBuyMenu.kSlotLockedTexture)
        end

    end

end

function GUIAlienBuyMenu:GetCanSelect(upgradeButton)
    return upgradeButton.Purchased or (AlienBuy_GetTechAvailable(upgradeButton.TechId) and AlienBuy_GetIsUpgradeAllowed(upgradeButton.TechId, self.upgradeList))
end

function GetIsUpgradeAllowed(callingEntity, techId, upgradeList)

    if callingEntity then
        local upgradesAllowed = GetNumberOfAllowedUpgrades(callingEntity)
	    return #upgradeList < upgradesAllowed
    end
    
    return false

end