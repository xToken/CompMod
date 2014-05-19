Script.Load("lua/Hud/GUIEvent.lua")

local function GetUnlockIconParams(unlockId)

    if not kUnlockIconParams then
    
        kUnlockIconParams = { }
        
        kUnlockIconParams[kTechId.FlamethrowerTech] =       { description = "EVT_FLAMETHROWER_RESEARCHED", bottomText = "EVT_BUY_AT_ARMORY" }
        kUnlockIconParams[kTechId.ShotgunTech] =            { description = "EVT_SHOTGUN_RESEARCHED", bottomText = "EVT_BUY_AT_ARMORY" }
        kUnlockIconParams[kTechId.GrenadeLauncherTech] =    { description = "EVT_GRENADE_LAUNCHER_RESEARCHED", bottomText = "EVT_BUY_AT_ARMORY" }
        kUnlockIconParams[kTechId.GrenadeTech        ] =    { description = "EVT_GRENADES_RESEARCHED", bottomText = "EVT_BUY_AT_ARMORY" }
        kUnlockIconParams[kTechId.AdvancedWeaponry] =       { description = "EVT_ADVANCED_WEAPONRY_RESEARCHED", bottomText = "EVT_BUY_AT_ARMORY" }
        kUnlockIconParams[kTechId.DetonationTimeTech] =     { description = "EVT_DETONATION_TIME_RESEARCHED" }
        kUnlockIconParams[kTechId.FlamethrowerRangeTech] =  { description = "EVT_FLAMETHROWER_RANGE_RESEARCHED" }
        kUnlockIconParams[kTechId.JetpackTech] =            { description = "EVT_JETPACK_RESEARCHED", bottomText = "EVT_BUY_AT_PROTOTYPE_LAB" }
        kUnlockIconParams[kTechId.ExosuitTech] =            { description = "EVT_EXOSUIT_RESEARCHED", bottomText = "EVT_BUY_AT_PROTOTYPE_LAB" }
        kUnlockIconParams[kTechId.DualMinigunTech] =        { description = "EVT_DUALMINIGUN_RESEARCHED", bottomText = "EVT_BUY_AT_PROTOTYPE_LAB" }
        kUnlockIconParams[kTechId.ClawRailgunTech] =        { description = "EVT_CLAWRAILGUN_RESEARCHED", bottomText = "EVT_BUY_AT_PROTOTYPE_LAB" }
        kUnlockIconParams[kTechId.DualRailgunTech] =        { description = "EVT_DUALRAILGUN_RESEARCHED", bottomText = "EVT_BUY_AT_PROTOTYPE_LAB" }
        kUnlockIconParams[kTechId.WelderTech] =             { description = "EVT_WELDER_RESEARCHED", bottomText = "EVT_BUY_AT_ARMORY" }
        kUnlockIconParams[kTechId.MinesTech] =              { description = "EVT_MINES_RESEARCHED", bottomText = "EVT_BUY_AT_ARMORY" }
        
        kUnlockIconParams[kTechId.Armor1] = { description = "EVT_ARMOR_LEVEL_1_RESEARCHED" }
        kUnlockIconParams[kTechId.Armor2] = { description = "EVT_ARMOR_LEVEL_2_RESEARCHED" }
        kUnlockIconParams[kTechId.Armor3] = { description = "EVT_ARMOR_LEVEL_3_RESEARCHED" }
        
        kUnlockIconParams[kTechId.Weapons1] = { description = "EVT_WEAPON_LEVEL_1_RESEARCHED" }
        kUnlockIconParams[kTechId.Weapons2] = { description = "EVT_WEAPON_LEVEL_2_RESEARCHED" }
        kUnlockIconParams[kTechId.Weapons3] = { description = "EVT_WEAPON_LEVEL_3_RESEARCHED" }
        
        kUnlockIconParams[kTechId.Leap] = { description = "EVT_LEAP_RESEARCHED" }
		kUnlockIconParams[kTechId.Xenocide] = { description = "EVT_XENOCIDE_RESEARCHED" }
		
		kUnlockIconParams[kTechId.BabblerTech] = { description = "Babblers Unlocked" }
        kUnlockIconParams[kTechId.BileBomb] = { description = "EVT_BILE_BOMB_RESEARCHED" }
		kUnlockIconParams[kTechId.WebTech] = { description = "Webs Unlocked" }
		
		kUnlockIconParams[kTechId.Umbra] = { description = "EVT_UMBRA_RESEARCHED" }
        kUnlockIconParams[kTechId.Spores] = { description = "EVT_SPORES_RESEARCHED" }
		
        kUnlockIconParams[kTechId.MetabolizeEnergy] = { description = "Metabolize Unlocked" }
		kUnlockIconParams[kTechId.MetabolizeHealth] = { description = "Advanced Metabolize Unlocked" }
		kUnlockIconParams[kTechId.Stab] = { description = "Stab Unlocked" }
		
		kUnlockIconParams[kTechId.Charge] = { description = "Charge Unlocked" }
		kUnlockIconParams[kTechId.BoneShield] = { description = "EVT_BONESHIELD_RESEARCHED" }
        kUnlockIconParams[kTechId.Stomp] = { description = "EVT_STOMP_RESEARCHED" }
        
    end
    
    if kUnlockIconParams[unlockId] then
    
        return Locale.ResolveString(kUnlockIconParams[unlockId].description),
               kUnlockIconParams[unlockId].bottomText and Locale.ResolveString(kUnlockIconParams[unlockId].bottomText) or nil
        
    end
    
end

ReplaceLocals(GUIEvent.UpdateUnlockDisplay, { GetUnlockIconParams = GetUnlockIconParams })

local oldAlienCommanderSetCurrentTech = AlienCommander.SetCurrentTech
function AlienCommander:SetCurrentTech(techId)

	if techId == kTechId.LifeFormMenu and self:GetEvoChamber() then
		DeselectAllUnits(self:GetTeamNumber())
		self:GetEvoChamber():SetSelected(self:GetTeamNumber(), true, false, true)
	else
		oldAlienCommanderSetCurrentTech(self, techId)
	end
end

local function GetIsMenu(techId)

    local techTree = GetTechTree()
    if techTree and techId ~= kTechId.LifeFormMenu then
    
        local techNode = techTree:GetTechNode(techId)
        return techNode ~= nil and techNode:GetIsMenu()
        
    end
    
    return false

end

ReplaceLocals(CommanderUI_MenuButtonOffset, { GetIsMenu = GetIsMenu })

local kPrettyInputNames = nil
local function InitInputNames()

	kPrettyInputNames = { }
	kPrettyInputNames["MouseButton0"] = Locale.ResolveString("LEFT_MOUSE_BUTTON")
	kPrettyInputNames["MouseButton1"] = Locale.ResolveString("RIGHT_MOUSE_BUTTON")
	kPrettyInputNames["LeftShift"] = Locale.ResolveString("LEFT_SHIFT")
	kPrettyInputNames["RightShift"] = Locale.ResolveString("RIGHT_SHIFT")
	kPrettyInputNames["Weapon6"] = "6"
	kPrettyInputNames["Weapon7"] = "7"
	kPrettyInputNames["Weapon8"] = "8"
	kPrettyInputNames["Weapon9"] = "9"
	kPrettyInputNames["Weapon10"] = "0"
	
end

function GetPrettyInputName(inputName)

	if not kPrettyInputNames then
		InitInputNames()
	end
	
	local prettyInputName = BindingsUI_GetInputValue(inputName)
	if prettyInputName == nil then
		prettyInputName = inputName
	end
	local foundPrettyInputName = kPrettyInputNames[prettyInputName]
	return foundPrettyInputName and foundPrettyInputName or prettyInputName
	
end


local kOtherTypes = {
    "CommandStructure",
    "ResourceTower",
    -- marine
    "Armory",
    "ArmsLab",
    "Observatory",
    "PhaseGate",
    "RoboticsFactory",
    "PowerPoint",
    "PrototypeLab",
    "PowerPack",
    "Sentry",
    "SentryBattery",
    "InfantryPortal",
    "MAC",
    "ARC",
    -- alien
    "Whip",
    "Crag",
    "Shade",
    "Shift",
    "Hydra",
    "Shell",
    "Veil",
    "Spur",
    "Drifter",
    "TunnelEntrance",
	"TunnelExit"
}

local kIndexToUpgrades =
{
    { kTechId.Shell, kTechId.Carapace, kTechId.Regeneration },
    { kTechId.Spur, kTechId.Celerity, kTechId.Adrenaline },
    { kTechId.Veil, kTechId.Silence, kTechId.Camouflage, kTechId.Aura },
}

local function SharedCreate(scriptName)

    local scriptPath = scriptName

    local result = StringSplit(scriptName, "/")    
    scriptName = result[table.count(result)]
    
    local creationFunction = _G[scriptName]
    
    if not creationFunction then
    
        Script.Load("lua/" .. scriptPath .. ".lua")
        creationFunction = _G[scriptName]
        
    end
    
    if creationFunction == nil then
    
        Shared.Message("Error: Failed to load GUI script named " .. scriptName)
        return nil
        
    else
    
        local newScript = creationFunction()
        newScript._scriptName = scriptName
		
		if scriptName == "GUIMinimapFrame" then
						
			Script.Load( "lua/CompMod/Elixer_Utility.lua" )
			Elixer.UseVersion( 1.3 )
			local kBlipInfo 		= GetUpValue( GUIMinimap.Initialize,   "kBlipInfo", 			{ LocateRecurse = true } )
			local kBlipColorType 	= GetUpValue( GUIMinimap.Initialize,   "kBlipColorType", 		{ LocateRecurse = true } )
			local kBlipSizeType 	= GetUpValue( GUIMinimap.Initialize,   "kBlipSizeType", 		{ LocateRecurse = true } )
			local kStaticBlipsLayer = GetUpValue( GUIMinimap.Initialize,   "kStaticBlipsLayer", 	{ LocateRecurse = true } )
			kBlipInfo[kMinimapBlipType.TunnelEntrance] = { kBlipColorType.MAC, kBlipSizeType.Normal, kStaticBlipsLayer }
			
		end
		
		if scriptName == "GUIInsight_OtherHealthbars" then
			ReplaceLocals(GUIInsight_OtherHealthbars.Update, { kOtherTypes = kOtherTypes })
		end
		
        newScript:Initialize()
		
		if scriptName == "GUIInsight_OtherHealthbars" then
			ReplaceLocals(GUIInsight_OtherHealthbars.Update, { otherList = table.array(25) })
		end
		
		if scriptName == "GUIUpgradeChamberDisplay" then
			ReplaceLocals(GUIUpgradeChamberDisplay.Update, { kIndexToUpgrades = kIndexToUpgrades })
		end
		
        return newScript
        
    end
    
end

ReplaceLocals(GUIManager.CreateGUIScriptSingle, { SharedCreate = SharedCreate })