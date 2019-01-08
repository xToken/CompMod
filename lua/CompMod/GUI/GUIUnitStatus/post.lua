-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIUnitStatus\post.lua
-- - Dragon

local kMaturityBarWidth
local kMaturityBarHeight
local GetPixelCoordsForFraction = GetUpValue(GUIUnitStatus.UpdateUnitStatusBlip, "GetPixelCoordsForFraction")

local originalGUIUnitStatusUpdateUnitStatusBlip = GUIUnitStatus.UpdateUnitStatusBlip
function GUIUnitStatus:UpdateUnitStatusBlip( blipIndex, localPlayerIsCommander, baseResearchRot, showHints, playerTeamType )
	originalGUIUnitStatusUpdateUnitStatusBlip(self, blipIndex, localPlayerIsCommander, baseResearchRot, showHints, playerTeamType)
	local maturityFraction = self.activeStatusInfo[blipIndex].MaturityFraction
	local updateBlip = self.activeBlipList[blipIndex]
	local isCrosshairTarget = self.activeStatusInfo[blipIndex].IsCrossHairTarget 

	if localPlayerIsCommander and maturityFraction and isCrosshairTarget then
        updateBlip.MaturityBarBg:SetIsVisible(self.visible)
        updateBlip.MaturityBarBg:SetColor(kArmorBarBgColors[kAlienTeamType])
        if maturityFraction > kMaturityGrownThreshold then
        	updateBlip.MaturityBar:SetColor(Color(0,1,0,1))
        elseif maturityFraction > kMaturityStarvingThreshold then
        	updateBlip.MaturityBar:SetColor(Color(1,1,0,1))
        else
        	updateBlip.MaturityBar:SetColor(Color(1,0,0,1))
        end
        updateBlip.MaturityBar:SetSize(Vector(kMaturityBarWidth * maturityFraction, kMaturityBarHeight, 0))
        updateBlip.MaturityBar:SetTexturePixelCoordinates(GetPixelCoordsForFraction(maturityFraction))
    else
        updateBlip.MaturityBarBg:SetIsVisible(false)
    end

end

local oldGUIUnitStatusInitialize = GUIUnitStatus.Initialize
function GUIUnitStatus:Initialize()
	oldGUIUnitStatusInitialize(self)
	kMaturityBarWidth = GUIScale(130)
	kMaturityBarHeight = GUIScale(4)
end

local oldCreateBlipItem = GetUpValue(GUIUnitStatus.UpdateUnitStatusList, "CreateBlipItem", { LocateRecurse = true })

local function newCreateBlipItem(self)
	local newBlip = oldCreateBlipItem(self)
    local neutralTexture = "ui/unitstatus_neutral.dds"

	newBlip.MaturityBarBg = GetGUIManager():CreateGraphicItem()
    newBlip.MaturityBarBg:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    newBlip.MaturityBarBg:SetSize(Vector(kMaturityBarWidth, kMaturityBarHeight, 0))
    newBlip.MaturityBarBg:SetPosition(Vector(-kMaturityBarWidth / 2, -GUIScale(10), 0))
    newBlip.MaturityBarBg:SetTexture(neutralTexture)
    newBlip.MaturityBarBg:SetColor(Color(0,0,0,0))
    newBlip.MaturityBarBg:SetTexturePixelCoordinates(GUIUnpackCoords(GUIUnitStatus.kUnitStatusBarTexCoords))
    
    newBlip.MaturityBar = GUIManager:CreateGraphicItem()
    newBlip.MaturityBar:SetColor(Color(0,1,0,1))
    newBlip.MaturityBar:SetSize(Vector(kMaturityBarWidth, kMaturityBarHeight, 0))
    newBlip.MaturityBar:SetTexture(neutralTexture)
    newBlip.MaturityBar:SetTexturePixelCoordinates(GUIUnpackCoords(GUIUnitStatus.kUnitStatusBarTexCoords))
    newBlip.MaturityBar:SetBlendTechnique(GUIItem.Add)
    newBlip.MaturityBarBg:AddChild(newBlip.MaturityBar)
    newBlip.statusBg:AddChild(newBlip.MaturityBarBg)

    return newBlip
end

ReplaceUpValue(GUIUnitStatus.UpdateUnitStatusList, "CreateBlipItem", newCreateBlipItem, { LocateRecurse = true } )