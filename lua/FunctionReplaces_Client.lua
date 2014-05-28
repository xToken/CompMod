Script.Load("lua/Hud/GUIEvent.lua")
Script.Load("lua/AlienTechMap.lua")
Script.Load( "lua/CompMod/Elixer_Utility.lua" )
Elixer.UseVersion( 1.5 )

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
		
		kUnlockIconParams[kTechId.BabblerTech] = { description = "Babblers Researched" }
        kUnlockIconParams[kTechId.BileBomb] = { description = "EVT_BILE_BOMB_RESEARCHED" }
		kUnlockIconParams[kTechId.WebTech] = { description = "Webs Researched" }
		
		kUnlockIconParams[kTechId.Umbra] = { description = "EVT_UMBRA_RESEARCHED" }
        kUnlockIconParams[kTechId.Spores] = { description = "EVT_SPORES_RESEARCHED" }
		
        kUnlockIconParams[kTechId.MetabolizeEnergy] = { description = "Metabolize Researched" }
		kUnlockIconParams[kTechId.MetabolizeHealth] = { description = "Advanced Metabolize Researched" }
		kUnlockIconParams[kTechId.Stab] = { description = "Stab Researched" }
		
		kUnlockIconParams[kTechId.Charge] = { description = "Charge Researched" }
		kUnlockIconParams[kTechId.BoneShield] = { description = "Boneshield Researched" }
        kUnlockIconParams[kTechId.Stomp] = { description = "EVT_STOMP_RESEARCHED" }
        
    end
    
    if kUnlockIconParams[unlockId] then
    
        return Locale.ResolveString(kUnlockIconParams[unlockId].description),
               kUnlockIconParams[unlockId].bottomText and Locale.ResolveString(kUnlockIconParams[unlockId].bottomText) or nil
        
    end
    
end

ReplaceLocals(GUIEvent.UpdateUnlockDisplay, { GetUnlockIconParams = GetUnlockIconParams })

// Automatically selects hive specific evo chamber when triggering that tech client side.
local oldAlienCommanderSetCurrentTech = AlienCommander.SetCurrentTech
function AlienCommander:SetCurrentTech(techId)
	if techId == kTechId.LifeFormMenu then
		local evochamberId = Entity.invalidId
		for _, unit in ipairs(self:GetSelection()) do
			if unit:isa("Hive") and unit:GetEvolutionChamber() ~= Entity.invalidId then
				evochamberId = unit:GetEvolutionChamber()
				break
			end
		end
		if evochamberId ~= Entity.invalidId then
			local evochamber = Shared.GetEntity(evochamberId)
			if evochamber then
				DeselectAllUnits(self:GetTeamNumber())
				evochamber:SetSelected(self:GetTeamNumber(), true, false, true)
			end
		end
	elseif tech == kTechId.Return then
		//Return hack
		self.menuTechId = kTechId.BuildMenu
	else
		oldAlienCommanderSetCurrentTech(self, techId)
	end
end

// Overrides the setting changing the DNA icon into an arrow.
local function GetIsMenu(techId)

    local techTree = GetTechTree()
    if techTree and techId ~= kTechId.LifeFormMenu then
    
        local techNode = techTree:GetTechNode(techId)
        return techNode ~= nil and techNode:GetIsMenu()
        
    end
    
    return false

end

ReplaceLocals(CommanderUI_MenuButtonOffset, { GetIsMenu = GetIsMenu })

local kTechIdToMaterialOffset = GetUpValue( GetMaterialXYOffset,   "kTechIdToMaterialOffset" )
kTechIdToMaterialOffset[kTechId.MetabolizeEnergy] = 70
kTechIdToMaterialOffset[kTechId.MetabolizeHealth] = 70
kTechIdToMaterialOffset[kTechId.GorgeTunnelEntrance] = 103
kTechIdToMaterialOffset[kTechId.GorgeTunnelExit] = 103
kTechIdToMaterialOffset[kTechId.Return] = 133
kTechIdToMaterialOffset[kTechId.EvolutionChamber] = 136

local kIndexToUpgrades =
{
    { kTechId.Shell, kTechId.Carapace, kTechId.Regeneration },
    { kTechId.Spur, kTechId.Celerity, kTechId.Adrenaline },
    { kTechId.Veil, kTechId.Silence, kTechId.Camouflage, kTechId.Aura },
}

local kHookedScripts = { }

local kGUIPreOverrides = { }
kGUIPreOverrides["GUIMinimapFrame"] 			= 	function() 
														local kBlipInfo 		= GetUpValue( GUIMinimap.Initialize,   "kBlipInfo", 			{ LocateRecurse = true } )
														local kBlipColorType 	= GetUpValue( GUIMinimap.Initialize,   "kBlipColorType", 		{ LocateRecurse = true } )
														local kBlipSizeType 	= GetUpValue( GUIMinimap.Initialize,   "kBlipSizeType", 		{ LocateRecurse = true } )
														local kStaticBlipsLayer = GetUpValue( GUIMinimap.Initialize,   "kStaticBlipsLayer", 	{ LocateRecurse = true } )
														kBlipInfo[kMinimapBlipType.TunnelEntrance] = { kBlipColorType.MAC, kBlipSizeType.Normal, kStaticBlipsLayer }
														return "0"
													end
kGUIPreOverrides["GUIInsight_OtherHealthbars"] = 	function() 
														local kOtherTypes 		= GetUpValue( GUIInsight_OtherHealthbars.Update,   "kOtherTypes", 			{ LocateRecurse = true } )
														table.insert(kOtherTypes, "TunnelExit")
														return "0"
													end
												
local kGUIPostOverrides = { }
kGUIPostOverrides["GUIInsight_OtherHealthbars"] = 	function() 
														return ReplaceLocals(GUIInsight_OtherHealthbars.Update, { otherList = table.array(25) })
													end
kGUIPostOverrides["GUIUpgradeChamberDisplay"] 	= 	function() 
														return ReplaceLocals(GUIUpgradeChamberDisplay.Update, { kIndexToUpgrades = kIndexToUpgrades }) 
													end

local function PreInitOverrides(scriptName)
	if not kHookedScripts[scriptName] and kGUIPreOverrides[scriptName] then
        Script.Load("lua/" .. scriptName .. ".lua")
		kGUIPreOverrides[scriptName]()
		//Shared.Message(string.format("Replacing %s for %s ", kGUIPreOverrides[scriptName](), scriptName))
    end
end

local function PostInitOverrides(scriptName)
	if not kHookedScripts[scriptName] and kGUIPostOverrides[scriptName] then
		//Shared.Message(string.format("Replacing %s for %s ", kGUIPostOverrides[scriptName](), scriptName))
		kGUIPostOverrides[scriptName]()
		kHookedScripts[scriptName] = true
	end
end
													
local origGUIManagerCreateGUIScriptSingle = GUIManager.CreateGUIScriptSingle
function GUIManager:CreateGUIScriptSingle(scriptName)
	local script
    PreInitOverrides(scriptName)
	script = origGUIManagerCreateGUIScriptSingle(self, scriptName)
	PostInitOverrides(scriptName)
	return script
end

local origGUIManagerCreateGUIScript = GUIManager.CreateGUIScript
function GUIManager:CreateGUIScript(scriptName)
	local script
    PreInitOverrides(scriptName)
	script = origGUIManagerCreateGUIScript(self, scriptName)
	PostInitOverrides(scriptName)
	return script
end

kAlienTechMap =
{
                    { kTechId.Whip, 5.5, 0.5 },          { kTechId.Shift, 6.5, 0.5 },          { kTechId.Shade, 7.5, 0.5 }, { kTechId.Crag, 8.5, 0.5 }, 


                    { kTechId.Harvester, 4, 1.5 },                           { kTechId.Hive, 7, 1.5 }, 
  
                   { kTechId.CragHive, 4, 3 },                               { kTechId.ShadeHive, 7, 3 },                            { kTechId.ShiftHive, 10, 3 },
              { kTechId.Shell, 4, 4, SetShellIcon },                     { kTechId.Veil, 7, 4, SetVeilIcon },                    { kTechId.Spur, 10, 4, SetSpurIcon },
  { kTechId.Carapace, 3.5, 5 },{ kTechId.Regeneration, 4.5, 5 }, { kTechId.Silence, 6, 5 },{ kTechId.Camouflage, 7, 5 },{ kTechId.Aura, 8, 5 },{ kTechId.Celerity, 9.5, 5 },{ kTechId.Adrenaline, 10.5, 5 },
  
  { kTechId.BioMassOne, 3, 7, nil, "1" }, { kTechId.BabblerEgg, 3, 8 },
  
  { kTechId.BioMassTwo, 4, 7, nil, "2" }, {kTechId.Rupture, 4, 8}, { kTechId.Charge, 4, 9 },
  
  { kTechId.BioMassThree, 5, 7, nil, "3" }, {kTechId.BoneWall, 5, 8}, {kTechId.BileBomb, 5, 9}, { kTechId.MetabolizeEnergy, 5, 10 },

  { kTechId.BioMassFour, 6, 7, nil, "4" }, {kTechId.Leap, 6, 8}, {kTechId.Umbra, 6, 9},
  
  { kTechId.BioMassFive, 7, 7, nil, "5" },  {kTechId.MetabolizeHealth, 7, 8}, {kTechId.BoneShield, 7, 9},
  
  { kTechId.BioMassSix, 8, 7, nil, "6" },  {kTechId.Spores, 8, 8},
  
  { kTechId.BioMassSeven, 9, 7, nil, "7" }, {kTechId.Stab, 9, 8}, {kTechId.Web, 9, 9},
  
  { kTechId.BioMassEight, 10, 7, nil, "8" },  {kTechId.Stomp, 10, 8}, 
  
  { kTechId.BioMassNine, 11, 7, nil, "9" }, {kTechId.Contamination, 11, 8}, {kTechId.Xenocide, 11, 9}, 

}

kAlienLines = 
{
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.Crag),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.Shift),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.Shade),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Hive, kTechId.Whip),

    GetLinePositionForTechMap(kAlienTechMap, kTechId.Harvester, kTechId.Hive),
    { 7, 1.5, 7, 2.5 },
    { 4, 2.5, 10, 2.5},
    { 4, 2.5, 4, 3},{ 7, 2.5, 7, 3},{ 10, 2.5, 10, 3},
    GetLinePositionForTechMap(kAlienTechMap, kTechId.CragHive, kTechId.Shell),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.ShadeHive, kTechId.Veil),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.ShiftHive, kTechId.Spur),
    
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Shell, kTechId.Carapace),GetLinePositionForTechMap(kAlienTechMap, kTechId.Shell, kTechId.Regeneration),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Veil, kTechId.Silence), GetLinePositionForTechMap(kAlienTechMap, kTechId.Veil, kTechId.Camouflage), GetLinePositionForTechMap(kAlienTechMap, kTechId.Veil, kTechId.Aura),
    GetLinePositionForTechMap(kAlienTechMap, kTechId.Spur, kTechId.Celerity),GetLinePositionForTechMap(kAlienTechMap, kTechId.Spur, kTechId.Adrenaline),

}

local origPlayerSendKeyEvent
origPlayerSendKeyEvent = Class_ReplaceMethod("Player", "SendKeyEvent", 
	function(self, key, down)
		local consumed = origPlayerSendKeyEvent(self, key, down)
		if not consumed and down then
			if GetIsBinding(key, "Weapon6") then
				Shared.ConsoleCommand("slot6")
				consumed = true
			end
		end	
		return consumed
	end
)

local origControlBindings = GetUpValue( BindingsUI_GetBindingsData,   "globalControlBindings", 			{ LocateRecurse = true } )
local newGlobalControlBindings = { }
for i = 1, #origControlBindings do
	table.insert(newGlobalControlBindings, origControlBindings[i])
	if origControlBindings[i] == "5" then
		table.insert(newGlobalControlBindings, "Weapon6")
		table.insert(newGlobalControlBindings, "input")
		table.insert(newGlobalControlBindings, "Weapon #6")
		table.insert(newGlobalControlBindings, "6")
	end	
end
ReplaceLocals(BindingsUI_GetBindingsData, { globalControlBindings = newGlobalControlBindings }) 

local defaults = GetUpValue( GetDefaultInputValue,   "defaults", 			{ LocateRecurse = true } )
table.insert(defaults, { "Weapon6", "6" })

local bindings = GetUpValue( ConsoleBindingsKeyPressed,   "bindings", 			{ LocateRecurse = true } )
local bindcommand = bindings["Num6"] and bindings["Num6"].command or nil

if bindcommand and string.gsub(bindcommand, " ", "") == "slot6" then
	bindings["Num6"] = nil
	SaveConfigFile("ConsoleBindings.json", bindings)
end