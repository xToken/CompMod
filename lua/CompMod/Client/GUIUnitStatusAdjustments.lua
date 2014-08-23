//Dont want to always replace random files, so this.

local kMucousBarWidth
local kMucousBarHeight
local oldUpdateUnitStatusList
local useOldMethod
local kAmmoColors = 
{
[kTechId.Rifle] = Color(0,1,1,1), // teal
[kTechId.Shotgun] = Color(0,1,0,1), // green
[kTechId.Flamethrower] = Color(1,1,0,1), // yellow
[kTechId.GrenadeLauncher] = Color(1,0,1,1), // magenta
[kTechId.HeavyMachineGun] = Color(1,0,0,1), // red?
}

local function AddMucousBar(blipItem)

    blipItem.MucousShieldBg = GetGUIManager():CreateGraphicItem()
    blipItem.MucousShieldBg:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
    blipItem.MucousShieldBg:SetSize(Vector(kMucousBarWidth, kMucousBarHeight, 0))
    blipItem.MucousShieldBg:SetPosition(Vector(-kMucousBarWidth / 2, 0, 0))
    blipItem.MucousShieldBg:SetTexture("ui/unitstatus_neutral.dds")
    blipItem.MucousShieldBg:SetColor(Color(0,0,0,0))
    blipItem.MucousShieldBg:SetInheritsParentAlpha(true)
    blipItem.MucousShieldBg:SetTexturePixelCoordinates(unpack(GUIUnitStatus.kUnitStatusBarTexCoords))
    
    blipItem.MucousShield = GUIManager:CreateGraphicItem()
    blipItem.MucousShield:SetColor(Color(0.65, 0.65, 0.65, 1))
    blipItem.MucousShield:SetSize(Vector(kMucousBarWidth, kMucousBarHeight, 0))
    blipItem.MucousShield:SetTexture("ui/unitstatus_neutral.dds")
    blipItem.MucousShield:SetTexturePixelCoordinates(unpack(GUIUnitStatus.kUnitStatusBarTexCoords))
    blipItem.MucousShield:SetBlendTechnique(GUIItem.Add)
    blipItem.MucousShield:SetInheritsParentAlpha(true)
    blipItem.MucousShieldBg:AddChild(blipItem.MucousShield)

    blipItem.statusBg:AddChild(blipItem.MucousShieldBg)

end

local function GetPixelCoordsForFraction(fraction)

    local width = GUIUnitStatus.kUnitStatusBarTexCoords[3] - GUIUnitStatus.kUnitStatusBarTexCoords[1]
    local x1 = GUIUnitStatus.kUnitStatusBarTexCoords[1]
    local x2 = x1 + width * fraction
    local y1 = GUIUnitStatus.kUnitStatusBarTexCoords[2]
    local y2 = GUIUnitStatus.kUnitStatusBarTexCoords[4]
    
    return x1, y1, x2, y2
    
end

local function UpdateAfterUnitStatus(self, activeBlips)

    for i = 1, #self.activeBlipList do
	
		local blipData = activeBlips[i]
        local updateBlip = self.activeBlipList[i]
		
		if blipData.MucousShield and not updateBlip.MucousShieldBg then
        
            AddMucousBar(updateBlip)
        
        elseif blipData.MucousShield == nil and updateBlip.MucousShieldBg then
            
            GUI.DestroyItem(updateBlip.MucousShieldBg)
            updateBlip.MucousShieldBg = nil
            updateBlip.MucousShield = nil
            
        end
        
        if updateBlip.MucousShieldBg then

            local bgColor = Color(0,1,0,1)
			
            updateBlip.MucousShieldBg:SetColor(bgColor)            
            updateBlip.MucousShield:SetSize(Vector(kMucousBarWidth * blipData.MucousShield, kMucousBarHeight, 0))
            updateBlip.MucousShield:SetTexturePixelCoordinates(GetPixelCoordsForFraction(blipData.MucousShield)) 
                
        end
		
		if updateBlip.AbilityBarBg and useOldMethod then
			if blipData.PrimaryWeapon then
				if kAmmoColors[blipData.PrimaryWeapon] then
					updateBlip.AbilityBar:SetColor(kAmmoColors[blipData.PrimaryWeapon])
				end
			end
		end
	
	end
	
end

local function SetupExtraUnitStatusBars()
	//Add in new updateUnitStatus Logic
	//MENDASP I HATE YOU!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	local UpdateUnitStatusList = GetUpValue( GUIUnitStatus.Update,   "UpdateUnitStatusList", { LocateRecurse = true } )
	local kHealthBarWidth = GetUpValue( UpdateUnitStatusList,   "kHealthBarWidth" )
	
	//if we find this, old version
	if not kHealthBarWidth then
		local UpdateUnitStatusBlip = GetUpValue( UpdateUnitStatusList,   "UpdateUnitStatusBlip", { LocateRecurse = true } )
		local kAmmoBarColors = GetUpValue( UpdateUnitStatusBlip,   "kAmmoBarColors", { LocateRecurse = true } )
		kAmmoBarColors[kTechId.HeavyMachineGun] = Color(1,0,0,1)
	else
		useOldMethod = true
	end
	
	local function newUpdateUnitStatusList(self, activeBlips, deltaTime)
		UpdateUnitStatusList(self, activeBlips, deltaTime)
		UpdateAfterUnitStatus(self, activeBlips)
	end
	
	kMucousBarWidth = GUIScale(130)
	kMucousBarHeight = GUIScale(6)
	
	ReplaceUpValue( GUIUnitStatus.Update, "UpdateUnitStatusList", newUpdateUnitStatusList, { LocateRecurse = true } )
	
end

AddPostInitOverride("GUIUnitStatus", SetupExtraUnitStatusBars)

local oldPlayerUI_GetUnitStatusInfo = PlayerUI_GetUnitStatusInfo
function PlayerUI_GetUnitStatusInfo()

    local unitStates = oldPlayerUI_GetUnitStatusInfo()
	for i = 1, #unitStates do
		local unitState = unitStates[i]
		if unitState.AbilityFraction ~= nil and type(unitState.AbilityFraction) == "table" then
			//I approve this hack.
			local extraInfo = unitState.AbilityFraction
			unitState.AbilityFraction = nil
			if extraInfo.Energy then
				unitState.AbilityFraction = extraInfo.Energy
			end
			if extraInfo.Shield then
				unitState.MucousShield = extraInfo.Shield
			end
		end
	end
	return unitStates
	
end