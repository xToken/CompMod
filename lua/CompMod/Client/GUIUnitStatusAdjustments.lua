// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Client\GUIUnitStatusAdjustments.lua
// - Dragon

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

local oldPlayerMapBlipGetMapBlipTeam
oldPlayerMapBlipGetMapBlipTeam = Class_ReplaceMethod("PlayerMapBlip", "GetMapBlipTeam",
	function(self, minimap)
	
		local playerTeam = minimap.playerTeam
		local blipTeam = kMinimapBlipTeam.Neutral
		local isSteamFriend = false
		local blipTeamNumber = self:GetTeamNumber()
		
		if blipTeamNumber == kMarineTeamType then
			blipTeam = kMinimapBlipTeam.Marine
		elseif blipTeamNumber== kAlienTeamType then
			blipTeam = kMinimapBlipTeam.Alien
		end		
		
		if self.clientIndex and self.clientIndex > 0 and MinimapMappableMixin.OnSameMinimapBlipTeam(playerTeam, blipTeam) then

			local steamId = GetSteamIdForClientIndex(self.clientIndex)
            if steamId then
                isSteamFriend = Client.GetIsSteamFriend(steamId)
            end

        end
		
		if not self:GetIsActive() then

			if blipTeamNumber == kMarineTeamType then
				blipTeam = kMinimapBlipTeam.InactiveMarine
			elseif blipTeamNumber== kAlienTeamType then
				blipTeam = kMinimapBlipTeam.InactiveAlien
			end

		elseif isSteamFriend then
		
			if blipTeamNumber == kMarineTeamType then
				blipTeam = kMinimapBlipTeam.FriendMarine
			elseif blipTeamNumber== kAlienTeamType then
				blipTeam = kMinimapBlipTeam.FriendAlien
			end
			
		end  

		return blipTeam
	
	end
)

AddPostInitOverride("GUIUnitStatus", SetupExtraUnitStatusBars)

local oldPlayerUI_GetStatusInfoForUnit = PlayerUI_GetStatusInfoForUnit
function PlayerUI_GetStatusInfoForUnit(player, unit)

    local unitState = oldPlayerUI_GetStatusInfoForUnit(player, unit)
	if unitState then
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
		unitState.IsSteamFriend = (unit:isa("Player") and not GetAreEnemies(player, unit) and unit:GetIsSteamFriend()) or false
	end
	return unitState
	
end

//I stole this from mendasp, and totally dont give a fuck.
local function SetupBuildVersionTags()

	local originalFeedbackInit
	originalFeedbackInit = Class_ReplaceMethod("GUIFeedback", "Initialize",
	function(self)
		originalFeedbackInit(self)
		self.buildText:SetText(self.buildText:GetText() .. " (" .. "CompMod" .. " v"  .. kCompModVersion .. "R5 )")
	end)
	
end

AddPreInitOverride("GUIFeedback", SetupBuildVersionTags)