//Dont want to always replace random files, so this.
Script.Load("lua/Hud/GUIEvent.lua")

local function SetupGUIMarineBuymenu()
	local GetSmallIconPixelCoordinates 		= GetUpValue( GUIMarineBuyMenu._InitializeEquipped,   "GetSmallIconPixelCoordinates", 			{ LocateRecurse = true } )
	local GetBigIconPixelCoords 		= GetUpValue( GUIMarineBuyMenu._InitializeContent,   "GetBigIconPixelCoords", 			{ LocateRecurse = true } )
	GetSmallIconPixelCoordinates(kTechId.Rifle)
	GetBigIconPixelCoords(kTechId.Rifle)
	local gSmallIconIndex 		= GetUpValue( GetSmallIconPixelCoordinates,   "gSmallIconIndex" )
	local gBigIconIndex 		= GetUpValue( GetBigIconPixelCoords,   "gBigIconIndex" )
	gBigIconIndex[kTechId.HeavyMachineGun] = 15
	gSmallIconIndex[kTechId.HeavyMachineGun] = 48
end

AddPostInitOverride("GUIMarineBuyMenu", SetupGUIMarineBuymenu)

//Build table, again sigh.
MarineBuy_GetWeaponDescription(kTechId.Rifle)
//Grab table
local gWeaponDescription = GetUpValue( MarineBuy_GetWeaponDescription,   "gWeaponDescription" )
//Add HMG
gWeaponDescription[kTechId.HeavyMachineGun] = "Heavy Machine Gun"

//This isnt actually loaded as a GUIScript, more as a resource.
local GetUnlockIconParams = GetUpValue( GUIEvent.UpdateUnlockDisplay,   "GetUnlockIconParams" )
//Build table
GetUnlockIconParams(kTechId.Armor1)
//Get the table
local kUnlockIconParams = GetUpValue( GetUnlockIconParams,   "kUnlockIconParams" )
//Make adjustments
kUnlockIconParams[kTechId.HeavyMachineGunTech] = { description = "Heavy Machine Gun Researched" }

//Build table
local GetDisplayTechId = GetUpValue( MarineBuy_GetEquipped,   "GetDisplayTechId")
GetDisplayTechId(kTechId.Rifle)
local gDisplayTechs = GetUpValue( GetDisplayTechId,   "gDisplayTechs")
//Add HMG
gDisplayTechs[kTechId.HeavyMachineGun] = true

local kMarineBuyMenuSounds = GetUpValue( MarineBuy_OnItemSelect,   "kMarineBuyMenuSounds")
local oldMarineBuy_OnItemSelect = MarineBuy_OnItemSelect
function MarineBuy_OnItemSelect(techId)
	if techId == kTechId.HeavyMachineGun then
		StartSoundEffect(kMarineBuyMenuSounds.SelectWeapon)
	else
		oldMarineBuy_OnItemSelect(techId)
	end
end

local function SetupActionIcons()
	local kIconOffsets = GetUpValue( GUIActionIcon.ShowIcon,   "kIconOffsets")
	kIconOffsets["HeavyMachineGun"] = 9
end

AddPostInitOverride("GUIActionIcon", SetupActionIcons)

local function SetupAmmoColor()
	local kAmmoColors = GetUpValue( GUIInsight_PlayerHealthbars.UpdatePlayers,   "kAmmoColors")
	kAmmoColors["heavymachinegun"] = Color(1,0,0,1)
end

AddPostInitOverride("GUIInsight_PlayerHealthbars", SetupAmmoColor)

local function SetupPickupOffset()
	local kPickupTextureYOffsets = GetUpValue( GUIPickups.Update,   "kPickupTextureYOffsets", 			{ LocateRecurse = true } )
	kPickupTextureYOffsets["HeavyMachineGun"] = 12
end

AddPostInitOverride("GUIPickups", SetupPickupOffset)

local oldPlayerUI_GetCrosshairY = PlayerUI_GetCrosshairY
function PlayerUI_GetCrosshairY()
	local player = Client.GetLocalPlayer()
    if(player and not player:GetIsThirdPerson()) then  
        local weapon = player:GetActiveWeapon()
        if weapon ~= nil and weapon:GetMapName() == HeavyMachineGun.kMapName then
			return 0 * 64
		end
	end
	return oldPlayerUI_GetCrosshairY()
end

local function SetupInsightShit()
	local iconSize = Vector(32,32,0)
	local kIconCoords = GetUpValue( GUIInsight_PlayerFrames.UpdatePlayer,   "kIconCoords" )
	kIconCoords["HMG"] = { 4*iconSize.x, 0, 5*iconSize.x, iconSize.y }
end

AddPostInitOverride("GUIInsight_PlayerFrames", SetupInsightShit)