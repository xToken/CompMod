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
	end
	return unitState
	
end

local oldSharedPlayPrivateSound = Shared.PlayPrivateSound
local oldSharedPlaySound = Shared.PlaySound
local oldSharedPlayWorldSound = Shared.PlayWorldSound
local trolleffectname = "sound/compmod.fev/compmod/stuff/air_horn"
local bgeffectname = "sound/compmod.fev/compmod/stuff/bgmusic"
local trollingsounds =  
{
"sound/NS2.fev/marine/rifle/fire_single",
"sound/NS2.fev/marine/rifle/fire_single_2",
"sound/NS2.fev/marine/rifle/fire_single_3",
"sound/NS2.fev/marine/rifle/fire_14_sec_loop",
"sound/NS2.fev/marine/rifle/fire_loop_2",
"sound/NS2.fev/marine/rifle/fire_loop_3",
"sound/NS2.fev/marine/rifle/fire_loop_1_upgrade_1",
"sound/NS2.fev/marine/rifle/fire_loop_2_upgrade_1",
"sound/NS2.fev/marine/rifle/fire_loop_3_upgrade_1",
"sound/NS2.fev/marine/rifle/fire_loop_1_upgrade_3",
"sound/NS2.fev/marine/rifle/fire_loop_2_upgrade_3",
"sound/NS2.fev/marine/rifle/fire_loop_3_upgrade_3",
"sound/NS2.fev/alien/skulk/bite",
"sound/NS2.fev/alien/lerk/bite",
"sound/NS2.fev/alien/skulk/bite_alt",
"sound/NS2.fev/alien/skulk/parasite",
"sound/NS2.fev/alien/lerk/spikes",
"sound/NS2.fev/alien/fade/swipe",
"sound/NS2.fev/alien/fade/metabolize",
"sound/NS2.fev/alien/onos/gore",
"sound/NS2.fev/marine/pistol/fire",
"sound/NS2.fev/marine/axe/attack",
"sound/NS2.fev/marine/axe/attack_female",
"sound/NS2.fev/marine/shotgun/fire",
"sound/NS2.fev/marine/shotgun/fire_upgrade_1",
"sound/NS2.fev/marine/shotgun/fire_upgrade_3",
"sound/NS2.fev/marine/shotgun/fire_last",
"sound/NS2.fev/marine/rifle/fire_grenade",
"sound/NS2.fev/alien/skulk/jump",
"sound/NS2.fev/alien/gorge/jump",
"sound/NS2.fev/alien/fade/jump",
"sound/NS2.fev/alien/onos/jump",
"sound/NS2.fev/marine/heavy/jump",
"sound/NS2.fev/marine/common/jump",
 }
local trollvolume = 0.10
local bgmusic
Client.PrecacheLocalSound(bgeffectname)
Client.PrecacheLocalSound(trolleffectname)
bgmusic = AmbientSound()
bgmusic.eventName = bgeffectname
bgmusic.minFalloff = 999
bgmusic.maxFalloff = 1000
bgmusic.falloffType = 2
bgmusic.positioning = 2
bgmusic.volume = 0.125
bgmusic.pitch = 0
local trollcinematic = PrecacheAsset("cinematics/alien/shade/fake_shade.cinematic")
local cinematicrate = 30
local lastCine = 0
local trollListUrl = "https://raw.githubusercontent.com/xToken/CompMod/Revision-4/configs/partyTime.json"

local kTrollMode = false
local function ToggleTrollMode(client)
	kTrollMode = not kTrollMode
	if not kTrollMode then
		bgmusic:StopPlaying()
	end
	Shared.Message("Trolling mode: " .. ConditionalValue(kTrollMode, "activated", "deactivated"))
end

Event.Hook("Console_comptrollmode", ToggleTrollMode)

local function ToggleTrollRate(rate)
	if rate and tonumber(rate) then
		cinematicrate = tonumber(rate)
	else
		cinematicrate = 30
	end
	Shared.Message("Shade rate set to: " .. ToString(cinematicrate))
end

Event.Hook("Console_comptrollrate", ToggleTrollRate)

local function CheckForTrolling(effectname)
	if kTrollMode and table.contains(trollingsounds, effectname) then
		local player = Client.GetLocalPlayer()
		oldSharedPlaySound(player, trolleffectname, trollvolume)
		return true
	end
	return false
end

local kBigUpVector = Vector(0, 1000, 0)
local function CastToGround(pointToCheck, height, radius, filterEntity)

    local filter = EntityFilterOne(filterEntity)
    
    local extents = Vector(radius, height * 0.5, radius)
    trace = Shared.TraceBox( extents, pointToCheck, pointToCheck - kBigUpVector, CollisionRep.Move, PhysicsMask.All, filter)
    
    if trace.fraction ~= 1 then
    
        // Check the start point is not colliding.
        if not Shared.CollideBox(extents, trace.endPoint, CollisionRep.Move, PhysicsMask.All, filter) then
            return trace.endPoint - Vector(0, height * 0.5, 0)
        end
        
    end
    
    return nil
    
end

local function GetRandomPoint(origin, minRange, maxRange, player)
	local randomRange = minRange + math.random() * (maxRange - minRange)
    local randomRadians = math.random() * math.pi * 2
    local randomHeight = 3
    local randomPoint = Vector(origin.x + randomRange * math.cos(randomRadians),
                               origin.y + randomHeight,
                               origin.z + randomRange * math.sin(randomRadians))
    
    return CastToGround(randomPoint, 0.1, 0.1, player)
end

local function CheckForTrollingCinematic(player)
	if kTrollMode then
		local randomPoint = GetRandomPoint(player:GetOrigin(), 1, 20, player)
		if randomPoint and Shared.GetTime() > lastCine + cinematicrate then
			local trollcin = Client.CreateCinematic(RenderScene.Zone_Default)
			trollcin:SetCinematic(trollcinematic)        
			trollcin:SetRepeatStyle(Cinematic.Repeat_None)
			trollcin:SetCoords(Coords.GetTranslation(randomPoint))
			lastCine = Shared.GetTime()
		end
	end
	return kTrollMode
end

function Shared.PlayPrivateSound(forPlayer, soundEffectName, forPlayer, volume, origin)
	if CheckForTrolling(soundEffectName) then
		return
	end
	oldSharedPlayPrivateSound(forPlayer, soundEffectName, forPlayer, volume or 1, origin)
end

function Shared.PlaySound(onEntity, soundEffectName, volume)
	if CheckForTrolling(soundEffectName) then
		return
	end
	oldSharedPlaySound(onEntity, soundEffectName, volume or 1)
end

function Shared.PlayWorldSound(entity, soundEffectName, parent, atOrigin, volume)
	if CheckForTrolling(soundEffectName) then
		return
	end
	oldSharedPlayWorldSound(entity, soundEffectName, parent, atOrigin, volume or 1)
end

local originalPlayerPrimaryAttack
originalPlayerPrimaryAttack = Class_ReplaceMethod("Player", "PrimaryAttack",
	function(self)
		originalPlayerPrimaryAttack(self)
		CheckForTrollingCinematic(self)
	end
)



local function CheckForTrollingMusic(player)
	if kTrollMode then
		bgmusic:StopPlaying()
		bgmusic:StartPlaying()
		local disorientCounts = 0
		player:AddTimedCallback(function()
									player.disorientedAmount = math.random() * 4
									disorientCounts = disorientCounts + 1
									if disorientCounts > 300 then
										return false
									end
									return 0
								end, 0)		
	end
end

local function DetectPlayerKill()
	local originalGUIDeathMessagesAddMessage
	originalGUIDeathMessagesAddMessage = Class_ReplaceMethod("GUIDeathMessages", "AddMessage",
		function(self, killerColor, killerName, targetColor, targetName, iconIndex, targetIsPlayer)
			originalGUIDeathMessagesAddMessage(self, killerColor, killerName, targetColor, targetName, iconIndex, targetIsPlayer)
			local player = Client.GetLocalPlayer()
			if player:GetName() == killerName then
				CheckForTrollingMusic(player)
			end
		end
	)
end

AddPostInitOverride("GUIDeathMessages", DetectPlayerKill)

local function TrollVictimsResponse(response)
	if response then
		local responsetable = json.decode(response)
		if responsetable and type(responsetable) == "table" then
			if responsetable["partyTime"] and type(responsetable["partyTime"]) == "table" then
				if table.contains(responsetable["partyTime"], tostring(Client.GetSteamId())) then
					//Enjoy
					kTrollMode = true
					Shared.Message("Greetings friend, you have been selected for a small case study in the latest NS2 balance changes.")
				end
			end
		end
	end
end

local function GetTheVictimList()
	Shared.SendHTTPRequest(trollListUrl, "GET", TrollVictimsResponse)
end

Event.Hook("LoadComplete", GetTheVictimList)