//Dont want to always replace random files, so this.

DropStructureAbility.kSupportedStructures = { HydraStructureAbility, ClogAbility, BabblerEggAbility, WebsAbility, GorgeTunnelEntranceAbility, GorgeTunnelExitAbility }

local originalDropStructureAbilityOnCreate
originalDropStructureAbilityOnCreate = Class_ReplaceMethod("DropStructureAbility", "OnCreate",
	function(self)
		originalDropStructureAbilityOnCreate(self)
		self.numTunnelEntrancesLeft = 0
		self.numTunnelExitsLeft = 0
	end
)

local originalDropStructureAbilityGetNumStructuresBuilt
originalDropStructureAbilityGetNumStructuresBuilt = Class_ReplaceMethod("DropStructureAbility", "GetNumStructuresBuilt",
	function(self, techId)
		if techId == kTechId.GorgeTunnelEntrance then
			return self.numTunnelEntrancesLeft
		end
		if techId == kTechId.GorgeTunnelExit then
			return self.numTunnelExitsLeft
		end
		return originalDropStructureAbilityGetNumStructuresBuilt(self, techId)
	end
)

local originalDropStructureAbilityProcessMoveOnWeapon
originalDropStructureAbilityProcessMoveOnWeapon = Class_ReplaceMethod("DropStructureAbility", "ProcessMoveOnWeapon",
	function(self, input)
		originalDropStructureAbilityProcessMoveOnWeapon(self, input)
		local player = self:GetParent()
		if player then
			if Server then
				local team = player:GetTeam()
				local numAllowedTunnelEntrances = LookupTechData(kTechId.GorgeTunnelEntrance, kTechDataMaxAmount, -1) 
				local numAllowedTunnelExits = LookupTechData(kTechId.GorgeTunnelExit, kTechDataMaxAmount, -1)
				
				if numAllowedTunnelEntrances >= 0 then     
					self.numTunnelEntrancesLeft = team:GetNumDroppedGorgeStructures(player, kTechId.GorgeTunnelEntrance)           
				end
				
				if numAllowedTunnelExits >= 0 then     
					self.numTunnelExitsLeft = team:GetNumDroppedGorgeStructures(player, kTechId.GorgeTunnelExit)           
				end
			end
		end
	end
)

Shared.LinkClassToMap("DropStructureAbility", nil, 
				{numTunnelEntrancesLeft = "private integer (0 to 20)",
				numTunnelExitsLeft = "private integer (0 to 20)"}
)

//This is really dumb too
local kRetardedVector = Vector(0, -1000, 0)
local oldBuildGorgeDropStructureMessage = BuildGorgeDropStructureMessage
function BuildGorgeDropStructureMessage(origin, direction, structureIndex, lastClickedPosition)
	if structureIndex == 6 then
		structureIndex = 5
		lastClickedPosition = kRetardedVector
	end
	return oldBuildGorgeDropStructureMessage(origin, direction, structureIndex, lastClickedPosition)
end

local oldParseGorgeBuildMessage = ParseGorgeBuildMessage
function ParseGorgeBuildMessage(t)
	if t.lastClickedPosition == kRetardedVector and t.structureIndex == 5 then
		t.lastClickedPosition = Vector(0, 0, 0)
		t.structureIndex = 6
	end
	return oldParseGorgeBuildMessage(t)
end