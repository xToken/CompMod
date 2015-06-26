// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Client\GorgeBuildMenuAdjustments.lua
// - Dragon

//Hardcoded binds for extra slots :/
local function UpdateGUIMenu(slot)
	local player = Client.GetLocalPlayer()
	local activeweapon = player:GetActiveWeapon()
	if activeweapon.buildMenu then
	    activeweapon.buildMenu:AdditionalInputs(slot)
	end
end

local function slot6()
	UpdateGUIMenu(6)
end

Event.Hook("Console_slot6", slot6)

local function SetupGUIGorgeBuildMenu()

	//Setup item changes.
	local GetRowForTechId 		= GetUpValue( GUIGorgeBuildMenu.Update,   "GetRowForTechId", 			{ LocateRecurse = true } )
	GetRowForTechId(kTechId.Hydra)
	local rowTable 		= GetUpValue( GetRowForTechId,   "rowTable" )
	rowTable[kTechId.GorgeTunnelEntrance] = 4
	rowTable[kTechId.GorgeTunnelExit] = 4
	
	//Add ButtonUpdate override to support color changes
	local UpdateButton = GetUpValue( GUIGorgeBuildMenu.Update,   "UpdateButton", 			{ LocateRecurse = true } )

	local function NewUpdateButton(button, index)

		UpdateButton(button, index)

		local col = 1
		local color = GUIGorgeBuildMenu.kAvailableColor

		if not GorgeBuild_GetCanAffordAbility(button.techId) then
			col = 2
			color = GUIGorgeBuildMenu.kTooExpensiveColor
		elseif not GorgeBuild_GetIsAbilityAvailable(index) then
			col = 3
			color = GUIGorgeBuildMenu.kUnavailableColor
		elseif button.techId == kTechId.GorgeTunnelEntrance then
			color = Color(0, 1, 0.2, 1)
		end
		
		button.description:SetColor(color)
		button.costIcon:SetColor(color)
		button.costText:SetColor(color)
		button.structuresLeft:SetColor(color)
		
	end

	ReplaceLocals(GUIGorgeBuildMenu.Update, { UpdateButton = NewUpdateButton })
	
	//Add new function for additional input
	function GUIGorgeBuildMenu:AdditionalInputs(key)
		local selectPressed = false
		local player = Client.GetLocalPlayer()
		if player then
			local dropStructureAbility = player:GetWeapon(DropStructureAbility.kMapName)
			if GorgeBuild_GetIsAbilityAvailable(key) and GorgeBuild_GetCanAffordAbility(self.buttons[key].techId) and dropStructureAbility and dropStructureAbility.menuActive then
				GorgeBuild_SendSelect(key)
				GorgeBuild_OnClose()
				GorgeBuild_Close()
				dropStructureAbility.menuActive = false
			end
		end
	end
end

AddPostInitOverride("GUIGorgeBuildMenu", SetupGUIGorgeBuildMenu)
