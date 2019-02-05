-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Marine\Marine\server.lua
-- - Dragon

local function UpdateNanoArmor(self)
    self.nanoArmor = GetHasTech(self, kTechId.NanoArmor)
    return false
end

ReplaceUpValue(Marine.OnInitialized, "UpdateNanoArmor", UpdateNanoArmor, { LocateRecurse = true } )

function Marine:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.NanoArmor) then
		self.nanoArmor = true
	else
		self.nanoArmor = false
	end
end

local GetHostSupportsTechId = GetUpValue( GetHostStructureFor, "GetHostSupportsTechId" )

function GetHostStructureFor(entity, techId)

    local hostStructures = {}
    table.copy(GetEntitiesForTeamWithinRange("Armory", entity:GetTeamNumber(), entity:GetOrigin(), Armory.kResupplyUseRange), hostStructures, true)
    table.copy(GetEntitiesForTeamWithinRange("PrototypeLab", entity:GetTeamNumber(), entity:GetOrigin(), PrototypeLab.kResupplyUseRange), hostStructures, true)
	table.copy(GetEntitiesForTeamWithinRange("RoboticsFactory", entity:GetTeamNumber(), entity:GetOrigin(), RoboticsFactory.kResupplyUseRange), hostStructures, true)
    
    if table.icount(hostStructures) > 0 then
    
        for _, host in ipairs(hostStructures) do
        
            -- check at first if the structure is hostign the techId:
            if GetHostSupportsTechId(entity,host, techId) then
                return host
            end
        
        end
            
    end
    
    return nil

end

local originalMarineAttemptToBuy
originalMarineAttemptToBuy = Class_ReplaceMethod("Marine", "AttemptToBuy",
	function(self, techIds)
		local success = originalMarineAttemptToBuy(self, techIds)
		if success then
			if techIds[1] == kTechId.Welder then
				self.utilitySlot3 = techIds[1]
			elseif techIds[1] == kTechId.ClusterGrenade or techIds[1] == kTechId.GasGrenade or techIds[1] == kTechId.PulseGrenade then
				self.utilitySlot5 = techIds[1]
			end
		end
		return success
	end
)

local originalMarineDropAllWeapons
originalMarineDropAllWeapons = Class_ReplaceMethod("Marine", "DropAllWeapons",
	function(self)
		-- local weaponSpawnCoords = self:GetAttachPointCoords(Weapon.kHumanAttachPoint)
		local weaponList = self:GetHUDOrderedWeaponList()
		for w = 1, #weaponList do
		
			local weapon = weaponList[w]
			
			if weapon:isa("GrenadeThrower") then
				weapon:DropItLikeItsHot(self)
			elseif weapon:isa("Welder") then
				-- do nothing, delete these
			elseif weapon:GetIsDroppable() and LookupTechData(weapon:GetTechId(), kTechDataCostKey, 0) > 0 then
				self:Drop(weapon, true, true)
			end
			
		end
	end
)

local originalMarineCopyPlayerDataFrom
originalMarineCopyPlayerDataFrom = Class_ReplaceMethod("Marine", "CopyPlayerDataFrom",
	function(self, player)
		Player.CopyPlayerDataFrom(self, player)
    
		local playerInRR = player:GetTeamNumber() == kNeutralTeamType
		
		if not playerInRR and GetGamerules():GetGameStarted() then
			
			self.utilitySlot3 = player.utilitySlot3 or kTechId.None
			self.utilitySlot5 = player.utilitySlot5 or kTechId.None
			self.grenadesLeft = nil
			self.grenadeType = nil
			
			if player:isa("Marine") then
				self:TransferParasite(player)
			elseif player:isa("Exo") then
				self:TransferParasite( { parasited = player.prevParasited, timeParasited = player.prevParasitedTime, parasiteDuration = player.prevParasiteDuration } ) 
			end
			
		end
	end
)

local originalMarineProcessBuyAction
originalMarineProcessBuyAction = Class_ReplaceMethod("Marine", "ProcessBuyAction",
	function (self, techIds)
		-- Marines only buy 1 tech ID at a time
		local techTree = self:GetTechTree()
		local techId = techIds[1]
		local techNode = techTree:GetTechNode(techId)
		-- If we have the tech, and already have a purchased utility item
		local totalCost = kMarineReBuyGrenadesCost
		if(techNode and techNode.available) and not self:GetHasUpgrade(techId) and self.utilitySlot5 ~= kTechId.None and totalCost <= self:GetResources() then
			if techId == kTechId.ClusterGrenade or techId == kTechId.GasGrenade or techId == kTechId.PulseGrenade then
				-- Buying alternative type or rebuying
				local mapName = LookupTechData(techId, kTechDataMapName)
				if mapName then
					Shared.PlayPrivateSound(self, Marine.kSpendResourcesSoundName, nil, 1.0, self:GetOrigin())
					local newItem = self:GiveItem(mapName)
					if newItem then
						if newItem.UpdateWeaponSkins then
							-- Apply weapon variant
							newItem:UpdateWeaponSkins( self:GetClient() )
						end
						self:TriggerEffects("marine_weapon_pickup", { effecthostcoords = self:GetCoords() })
						self.utilitySlot5 = techId
						self:AddResources(-totalCost)
						return
					end
				end
			end
		end
		return originalMarineProcessBuyAction(self, techIds)
	end
)
		