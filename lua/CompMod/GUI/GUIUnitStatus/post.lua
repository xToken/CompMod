-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIUnitStatus\post.lua
-- - Dragon

Script.Load("lua/GUIDial.lua")

-- fhjkdshfkaljs
function GUIDial:Update(deltaTime)

    PROFILE("GUIDial:Update")

    local upperHalfPercentage = math.max(0, (self.percentage - 0.5) / 0.5)
    local lowerHalfPercentage = math.max(0, math.min(0.5, self.percentage) / 0.5)
    
    self.leftSideMask:SetRotation(self.globalRotation + Vector(0, 0, math.pi * (1 - (self.reverse and -lowerHalfPercentage or upperHalfPercentage))))
    self.rightSideMask:SetRotation(self.globalRotation + Vector(0, 0, math.pi * (1 - (self.reverse and -upperHalfPercentage or lowerHalfPercentage))))
    
    self.dialBackground:SetRotation(self.globalRotation)
    self.leftSide:SetRotation(self.globalRotation)
    self.rightSide:SetRotation(self.globalRotation)
    

end

local kCatalystIndicatorSize
local kMaturityCircleOffset
local kMaturityCircleNoNameOffset
local kMaturityCircleWidth
local kMaturityCircleHeight
local kMaturityCircleSplitForeground = PrecacheAsset("ui/circle_split3_base.dds")
local kMaturityCircleSplitBackground = PrecacheAsset("ui/circle_split3_bar.dds")
local kMaturityCircleSolidForeground = PrecacheAsset("ui/solid_circle_base.dds")
local kMaturityCircleSolidBackground = PrecacheAsset("ui/solid_circle_bar.dds")
local kCatalystIndicatorTexture = PrecacheAsset("ui/catalyst_dot.dds")

local kHealthBarWidth
local kHealthBarHeight
local kArmorBarWidth
local kArmorBarHeight
local kStatusBgSizeUnscaled = GetUpValue(GUIUnitStatus.UpdateUnitStatusBlip, "kStatusBgSizeUnscaled", { LocateRecurse = true })
local kAmmoBarColors = GetUpValue(GUIUnitStatus.UpdateUnitStatusBlip, "kAmmoBarColors", { LocateRecurse = true })
local kAbilityBarColor = GetUpValue(GUIUnitStatus.UpdateUnitStatusBlip, "kAbilityBarColor", { LocateRecurse = true })
local GetUnitStatusTextureCoordinates = GetUpValue(GUIUnitStatus.UpdateUnitStatusBlip, "GetUnitStatusTextureCoordinates", { LocateRecurse = true })
local GetPixelCoordsForFraction = GetUpValue(GUIUnitStatus.UpdateUnitStatusBlip, "GetPixelCoordsForFraction", { LocateRecurse = true })
local GetPixelCoordsForFractionPiece = GetUpValue(GUIUnitStatus.UpdateUnitStatusBlip, "GetPixelCoordsForFractionPiece", { LocateRecurse = true })
local AddAbilityBar = GetUpValue(GUIUnitStatus.UpdateUnitStatusBlip, "AddAbilityBar", { LocateRecurse = true })

function GUIUnitStatus:UpdateUnitStatusBlip( blipIndex, localPlayerIsCommander, baseResearchRot, showHints, playerTeamType )

    PROFILE("GUIUnitStatus:UpdateUnitStatusBlip")

    local blipData = self.activeStatusInfo[blipIndex]
    
    local teamType = blipData.TeamType
    local isEnemy = false
    local isCrosshairTarget = blipData.IsCrossHairTarget
    local commHealthBarsToggle = blipData.CommHealthBarsToggle
    local maturityFraction
    local scalar = 1
    local catalystTime = 0

    if playerTeamType ~= kNeutralTeamType then
        isEnemy = (playerTeamType ~= teamType) and (teamType ~= kNeutralTeamType)
        teamType = playerTeamType
    end

    local blipNameText = blipData.Name
    local blipHintText = blipData.Hint
    local healthFraction = 0
    local regenFraction = 0
    local armorFraction = 0
    local abilityFraction = 0
    local statusFraction = 0

    local alpha = 0

    if isCrosshairTarget or commHealthBarsToggle then
        healthFraction = blipData.HealthFraction
        regenFraction = blipData.RegenFraction
        armorFraction = blipData.ArmorFraction
        abilityFraction = blipData.AbilityFraction
        statusFraction = blipData.StatusFraction
        maturityFraction = blipData.MaturityFraction
        scalar = blipData.CatalystScalar or 1
        catalystTime = blipData.CatalystRemaining or 0
        alpha = 1
    end

    if blipData.SpawnFraction ~= nil and not isEnemy then
        -- Show spawn progress
        if isCrosshairTarget then
            if showHints then
                blipHintText = string.format(Locale.ResolveString( "INFANTRY_PORTAL_SPAWNING_HINT" ), blipData.SpawnerName )
            else
                blipHintText = blipData.SpawnerName
            end
            showHints = true
        else
            blipNameText = blipData.SpawnerName
            showHints = false
        end
        abilityFraction = math.max(0.01, blipData.SpawnFraction ) -- always show at least 1% so there is a black bar
        alpha = 1
    end

    if blipData.EvolvePercentage ~= nil and not isEnemy and ( blipData.IsPlayer or isCrosshairTarget ) then        
        if not localPlayerIsCommander then
            blipHintText = blipData.EvolveClass or blipHintText
            showHints = true
        end
        -- If evolving show evolve progress and hide the researching spinner
        abilityFraction = math.max(0.01, blipData.EvolvePercentage ) -- always show at least 1% so there is a black bar
        statusFraction = 0
        alpha = 1
    end
    
    if blipData.Destination and not isEnemy then
        if isCrosshairTarget then
            if not showHints then
                blipHintText = blipData.Destination
            end
            showHints = true
            alpha = 1
        elseif not localPlayerIsCommander then
            blipNameText = blipData.Destination
            showHints = false
            alpha = 1
        end
    end

    local textColor
    if isEnemy then
        textColor = GUIUnitStatus.kEnemyColor
    elseif blipData.IsParasited and blipData.IsFriend then
        textColor = kCommanderColorFloat
    elseif blipData.IsSteamFriend then
        textColor = kSteamFriendColor
    else
        textColor = kNameTagFontColors[teamType]
    end
        
    -- status icon, color and unit name

    local updateBlip = self.activeBlipList[blipIndex]
    updateBlip.GraphicsItem:SetTexturePixelCoordinates(GetUnitStatusTextureCoordinates(blipData.Status))
    updateBlip.GraphicsItem:SetPosition(blipData.Position - GUIUnitStatus.kUnitStatusSize * .5 )
    updateBlip.GraphicsItem:SetIsVisible(self.visible)

    local color = kWhite
    if playerTeamType == kTeam1Index and (blipData.Status == kUnitStatus.Unrepaired or blipData.Status == kUnitStatus.Damaged) then
        if GUIUnitStatus.kUseColoredWrench then
            local percentage = blipData.IsPlayer and blipData.ArmorFraction or (blipData.HealthFraction + blipData.ArmorFraction)/2
            color = (percentage < 0.5 and LerpColor(kRed, kYellow, percentage*2)) or (percentage >= 0.5 and LerpColor(kYellow, kWhite, (percentage-0.5)*2))
        else 
            if blipData.Status == kUnitStatus.Unrepaired then
                color = kYellow
            end
        end

        color.a = updateBlip.GraphicsItem:GetColor().a -- to not override the pulsate
    end
    updateBlip.GraphicsItem:SetColor(color)

    updateBlip.statusBg:SetColor(Color(1,1,1,1))
    updateBlip.statusBg:SetTexture(kTransparentTexture)
    updateBlip.statusBg:SetPosition(blipData.HealthBarPosition - GUIUnitStatus.kStatusBgSize * .5 )

    -- Name
    if ( blipData.ForceName and blipData.IsPlayer ) or alpha > 0 then
        updateBlip.NameText:SetIsVisible(self.visible)
        updateBlip.NameText:SetText(blipNameText)
        updateBlip.NameText:SetColor(textColor) -- use the entities team color here, so you can make a difference between enemy or friend
    else
        updateBlip.NameText:SetIsVisible(false)
    end
        
    -- Health Bar
    if alpha > 0 and healthFraction ~= 0 then
        updateBlip.HealthBarBg:SetIsVisible(self.visible)

        if blipData.IsPlayer and isEnemy and not blipData.EvolvePercentage then
            updateBlip.HealthBarBg:SetColor( kHealthBarBgEnemyPlayerColor )
            updateBlip.HealthBar:SetColor( kHealthBarEnemyPlayerColor )
            updateBlip.RegenBar:SetColor( kRegenBarEnemyColor )
        else
            updateBlip.HealthBarBg:SetColor( kHealthBarBgColors[teamType] )
            updateBlip.HealthBar:SetColor( kHealthBarColors[teamType] )
            updateBlip.HealthBar:SetColor( kHealthBarColors[teamType] )
            updateBlip.RegenBar:SetColor( kRegenBarFriendlyColor )
        end

        if healthFraction < regenFraction then
            updateBlip.RegenBar:SetIsVisible(self.visible)
            updateBlip.RegenBar:SetSize(Vector(kHealthBarWidth * ( regenFraction - healthFraction ), kHealthBarHeight, 0))
            updateBlip.RegenBar:SetTexturePixelCoordinates(GetPixelCoordsForFractionPiece(healthFraction,regenFraction))
            updateBlip.RegenBar:SetPosition(Vector(kHealthBarWidth * healthFraction,0,0))
        else
            updateBlip.RegenBar:SetIsVisible(false)
        end

        updateBlip.HealthBar:SetSize(Vector(kHealthBarWidth * healthFraction, kHealthBarHeight, 0))
        updateBlip.HealthBar:SetTexturePixelCoordinates(GetPixelCoordsForFraction(healthFraction))
    else
        updateBlip.HealthBarBg:SetIsVisible(false)
    end

    -- Armor Bar
    if alpha > 0 and armorFraction ~= 0 then
        updateBlip.ArmorBarBg:SetIsVisible(self.visible)
        if blipData.IsPlayer and isEnemy and not blipData.EvolvePercentage then
            updateBlip.ArmorBarBg:SetColor(kArmorBarBgEnemyPlayerColor)
            updateBlip.ArmorBar:SetColor(kArmorBarEnemyPlayerColor)
        else
            updateBlip.ArmorBarBg:SetColor(kArmorBarBgColors[teamType])
            updateBlip.ArmorBar:SetColor(kArmorBarColors[teamType])
        end
        updateBlip.ArmorBar:SetSize(Vector(kArmorBarWidth * armorFraction, kArmorBarHeight, 0))
        updateBlip.ArmorBar:SetTexturePixelCoordinates(GetPixelCoordsForFraction(armorFraction)) 
    else
        updateBlip.ArmorBarBg:SetIsVisible(false)
    end

    -- Ammo/Ability Bar
    if abilityFraction > 0 then
        if not updateBlip.AbilityBarBg then    
            AddAbilityBar(updateBlip)
        end

        if alpha > 0 then      
            updateBlip.AbilityBarBg:SetIsVisible( self.visible )
            updateBlip.AbilityBarBg:SetColor(kAbilityBarBgColors[teamType])
            updateBlip.AbilityBar:SetSize(Vector(kArmorBarWidth * abilityFraction, kArmorBarHeight * 2, 0))
            updateBlip.AbilityBar:SetTexturePixelCoordinates(GetPixelCoordsForFraction(abilityFraction)) 

            if blipData.IsWorldWeapon and GUIPickups.kShouldShowExpirationBars then
                local ammoBarColor = GUIPickups_GetExpirationBarColor( blipData.AbilityFraction, 1 )
                updateBlip.AbilityBar:SetColor(ammoBarColor)
            else
                local ammoBarColor = blipData.PrimaryWeapon and kAmmoBarColors[blipData.PrimaryWeapon]
                if ammoBarColor then
                    updateBlip.AbilityBar:SetColor(ammoBarColor)
                    updateBlip.AbilityBarBg:SetColor(Color(ammoBarColor.r * 0.5, ammoBarColor.g * 0.5, ammoBarColor.b * 0.5, 1))
                else
                    updateBlip.AbilityBar:SetColor(kAbilityBarColors[teamType])
                end
            end

        else
            updateBlip.AbilityBarBg:SetIsVisible( false )
        end
    else
        if updateBlip.AbilityBarBg then
            updateBlip.AbilityBarBg:SetIsVisible( false )
        end
    end

    -- Hints
    if showHints and blipHintText ~= nil and blipHintText ~= "" and alpha > 0 then
        updateBlip.HintText:SetIsVisible(self.visible)
        updateBlip.HintText:SetText(blipHintText)
        updateBlip.HintText:SetColor(textColor)

        local bgsize = GUIUnitStatus.kStatusBgSize
        local hintTextWidth = updateBlip.HintText:GetTextWidth(blipHintText) + 8
        if kStatusBgSizeUnscaled.x < hintTextWidth then
            bgsize = Vector( kStatusBgSizeUnscaled )
            bgsize.x = hintTextWidth
            bgsize = GUIScale( bgsize )
        end

        updateBlip.statusBg:SetSize(bgsize)
        updateBlip.statusBg:SetPosition(blipData.HealthBarPosition - updateBlip.statusBg:GetSize() * .5 )
    else
        updateBlip.HintText:SetIsVisible(false)
        updateBlip.statusBg:SetSize(GUIUnitStatus.kStatusBgNoHintSize)
    end

    -- Research Progress
    if isCrosshairTarget and statusFraction > 0 and statusFraction < 1 then        
        updateBlip.ProgressingIcon:SetIsVisible(self.visible)
        updateBlip.ProgressingIcon:SetRotation(Vector(0, 0, -2 * math.pi * baseResearchRot))
        updateBlip.ProgressText:SetText(math.floor(statusFraction * 100) .. "%")
        updateBlip.ActionText:SetText(blipData.Action)
        updateBlip.ActionText:SetColor(textColor)
        updateBlip.ActionTextShadow:SetText(blipData.Action)
        updateBlip.ActionTextShadow:SetColor(Color(0, 0, 0, 1))
    else
        updateBlip.ProgressingIcon:SetIsVisible(false)
    end

    -- Sustenance
    if maturityFraction and (isCrosshairTarget or commHealthBarsToggle) and not isEnemy then
        local dotsToShow = math.ceil(catalystTime/kNutrientMistDuration/scalar)
        local dotTimeRemaining = math.max(catalystTime - (dotsToShow-1) * scalar * kNutrientMistDuration, 0)
        local dotAlpha = math.min(dotTimeRemaining, 1)
        local currentColor = updateBlip.CatalystIndicator1:GetColor()
        currentColor.a = dotAlpha
        if scalar > 1 and scalar ~= updateBlip.maturityBall.lastScalar then
            -- Use single texture
            updateBlip.maturityBall.dialBackground:SetTexture(kMaturityCircleSolidForeground)
            updateBlip.maturityBall:SetForegroundTexture(kMaturityCircleSolidBackground)
            updateBlip.CatalystIndicator1:SetPosition(Vector(kMaturityCircleOffset.x/2 + kMaturityCircleWidth/2 + GUIScale(19), kMaturityCircleOffset.y, 0))
            updateBlip.maturityBall.lastScalar = scalar
        elseif scalar ~= updateBlip.maturityBall.lastScalar then
            -- Use split tex
            updateBlip.maturityBall.dialBackground:SetTexture(kMaturityCircleSplitForeground)
            updateBlip.maturityBall:SetForegroundTexture(kMaturityCircleSplitBackground)
            updateBlip.CatalystIndicator1:SetPosition(Vector(kMaturityCircleOffset.x/2 + kMaturityCircleWidth/2 + GUIScale(14), kMaturityCircleOffset.y - 5, 0))
            updateBlip.maturityBall.lastScalar = scalar
        end

        updateBlip.maturityBall:SetIsVisible(self.visible)
        updateBlip.CatalystIndicator1:SetIsVisible(self.visible and dotsToShow >= 1)
        updateBlip.CatalystIndicator1:SetColor(dotsToShow == 1 and currentColor or updateBlip.CatalystIndicator1.cachedColor)
        updateBlip.CatalystIndicator2:SetIsVisible(self.visible and dotsToShow >= 2)
        updateBlip.CatalystIndicator2:SetColor(dotsToShow == 2 and currentColor or updateBlip.CatalystIndicator1.cachedColor)
        updateBlip.CatalystIndicator3:SetIsVisible(self.visible and dotsToShow >= 3)
        updateBlip.CatalystIndicator3:SetColor(dotsToShow == 3 and currentColor or updateBlip.CatalystIndicator1.cachedColor)

        updateBlip.maturityBall:SetPercentage(maturityFraction)
        updateBlip.maturityBall:Update(0)
    else
        updateBlip.maturityBall:SetIsVisible(false)
        updateBlip.CatalystIndicator1:SetIsVisible(false)
        updateBlip.CatalystIndicator2:SetIsVisible(false)
        updateBlip.CatalystIndicator3:SetIsVisible(false)
    end
    
    -- Badges
    if alpha > 0 and not GetGameInfoEntity():GetGameStarted() then
        assert( #updateBlip.Badges >= #blipData.BadgeTextures )
        for i = 1, #updateBlip.Badges do

            local badge = updateBlip.Badges[i]
            local texture = blipData.BadgeTextures[i]

            if texture then

                badge:SetTexture(texture)
                badge:SetIsVisible(self.visible)

            else
                badge:SetIsVisible(false)
            end

        end
    else
        for i = 1, #updateBlip.Badges do
            updateBlip.Badges[i]:SetIsVisible(false)
        end
    end

end

local oldGUIUnitStatusInitialize = GUIUnitStatus.Initialize
function GUIUnitStatus:Initialize()
	oldGUIUnitStatusInitialize(self)

    kCatalystIndicatorSize = GUIScale(Vector(12, 12, 0))
    kMaturityCircleOffset = GUIScale(Vector(-102, 20, 0))
    kMaturityCircleWidth = GUIScale(48)
    kMaturityCircleHeight = GUIScale(48)
    kHealthBarWidth = GUIScale(130)
    kHealthBarHeight = GUIScale(8)
    kArmorBarWidth = GUIScale(130)
    kArmorBarHeight = GUIScale(4)
end

local oldCreateBlipItem = GetUpValue(GUIUnitStatus.UpdateUnitStatusList, "CreateBlipItem", { LocateRecurse = true })

local function newCreateBlipItem(self)
	local newBlip = oldCreateBlipItem(self)

    local maturitySettings = { }
    maturitySettings.BackgroundWidth = kMaturityCircleWidth
    maturitySettings.BackgroundHeight = kMaturityCircleHeight
    maturitySettings.BackgroundAnchorX = GUIItem.Middle
    maturitySettings.BackgroundAnchorY = GUIItem.Center
    maturitySettings.BackgroundOffset = kMaturityCircleOffset
    maturitySettings.BackgroundTextureName = kMaturityCircleSplitForeground -- This doesnt make sense, but... yea
    maturitySettings.BackgroundTextureX1 = 0
    maturitySettings.BackgroundTextureY1 = 0
    maturitySettings.BackgroundTextureX2 = 48
    maturitySettings.BackgroundTextureY2 = 48
    maturitySettings.ForegroundTextureName = kMaturityCircleSplitBackground
    maturitySettings.ForegroundTextureWidth = 48
    maturitySettings.ForegroundTextureHeight = 48
    maturitySettings.ForegroundTextureX1 = 0
    maturitySettings.ForegroundTextureY1 = 0
    maturitySettings.ForegroundTextureX2 = 48
    maturitySettings.ForegroundTextureY2 = 48
    maturitySettings.InheritParentAlpha = false
    newBlip.maturityBall = GUIDial()
    newBlip.maturityBall:Initialize(maturitySettings)
    newBlip.maturityBall.lastScalar = 1
    newBlip.maturityBall.reverse = true
    newBlip.statusBg:AddChild(newBlip.maturityBall.dialBackground)

    newBlip.CatalystIndicator1 = GUIManager:CreateGraphicItem()
    newBlip.CatalystIndicator1:SetSize(kCatalystIndicatorSize)
    newBlip.CatalystIndicator1:SetTexture(kCatalystIndicatorTexture)
    newBlip.CatalystIndicator1:SetTexturePixelCoordinates(0, 0, 12, 12)
    newBlip.CatalystIndicator1:SetPosition(Vector(kMaturityCircleOffset.x/2 + kMaturityCircleWidth/2 + GUIScale(14), kMaturityCircleOffset.y - 5, 0))
    newBlip.CatalystIndicator1:SetBlendTechnique(GUIItem.Add)
    newBlip.statusBg:AddChild(newBlip.CatalystIndicator1)
    newBlip.CatalystIndicator1.cachedColor = newBlip.CatalystIndicator1:GetColor()

    newBlip.CatalystIndicator2 = GUIManager:CreateGraphicItem()
    newBlip.CatalystIndicator2:SetSize(kCatalystIndicatorSize)
    newBlip.CatalystIndicator2:SetTexture(kCatalystIndicatorTexture)
    newBlip.CatalystIndicator2:SetTexturePixelCoordinates(0, 0, 12, 12)
    newBlip.CatalystIndicator2:SetPosition(Vector(kMaturityCircleOffset.x/2 + kMaturityCircleWidth/2 + GUIScale(19), kMaturityCircleOffset.y + 5, 0))
    newBlip.CatalystIndicator2:SetBlendTechnique(GUIItem.Add)
    newBlip.statusBg:AddChild(newBlip.CatalystIndicator2)

    newBlip.CatalystIndicator3 = GUIManager:CreateGraphicItem()
    newBlip.CatalystIndicator3:SetSize(kCatalystIndicatorSize)
    newBlip.CatalystIndicator3:SetTexture(kCatalystIndicatorTexture)
    newBlip.CatalystIndicator3:SetTexturePixelCoordinates(0, 0, 12, 12)
    newBlip.CatalystIndicator3:SetPosition(Vector(kMaturityCircleOffset.x/2 + kMaturityCircleWidth/2 + GUIScale(24), kMaturityCircleOffset.y - 5, 0))
    newBlip.CatalystIndicator3:SetBlendTechnique(GUIItem.Add)
    newBlip.statusBg:AddChild(newBlip.CatalystIndicator3)

    return newBlip
end

ReplaceUpValue(GUIUnitStatus.UpdateUnitStatusList, "CreateBlipItem", newCreateBlipItem, { LocateRecurse = true } )

local function DestroyActiveBlips(self)

    for _, blip in ipairs(self.activeBlipList) do
        --if blip.maturityBall then
            --blip.maturityBall:Uninitialize()
            --blip.maturityBall = nil
        --end
        GUI.DestroyItem(blip.statusBg)
        blip.GraphicsItem:Destroy()
    end

    self.activeBlipList = { }
    
end

ReplaceUpValue(GUIUnitStatus.Uninitialize, "DestroyActiveBlips", DestroyActiveBlips, { LocateRecurse = true } )