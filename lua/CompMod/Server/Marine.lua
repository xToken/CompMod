-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Server\Marine.lua
-- - Dragon

local function UpdateNanoArmor(self)
    self.hasNanoArmor = GetHasTech(self, kTechId.NanoArmor)
    return true
end

ReplaceLocals(Marine.OnInitialized, { UpdateNanoArmor = UpdateNanoArmor })

function Marine:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.NanoArmor) then
		self.hasNanoArmor = true
	else
		self.hasNanoArmor = false
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

local originalMarineGiveItem
originalMarineGiveItem = Class_ReplaceMethod("Marine", "GiveItem",
	function(self, itemMapName, setActive, suppressError)
		local newItem

		if setActive == nil then
			setActive = true
		end

		if itemMapName then
			
			local continue = true
			
			if itemMapName == LayMines.kMapName then
			
				local mineWeapon = self:GetWeapon(LayMines.kMapName)
				
				if mineWeapon then
					mineWeapon:Refill(kNumMines)
					continue = false
					setActive = false
				end
			
			end
			
			if continue == true then
				return Player.GiveItem(self, itemMapName, setActive, suppressError)
			end
			
		end

		return newItem
	end
)

local originalMarineAttemptToBuy
originalMarineAttemptToBuy = Class_ReplaceMethod("Marine", "AttemptToBuy",
	function(self, techIds)
		local success = originalMarineAttemptToBuy(self, techIds)
		if success then
			if techIds[1] == kTechId.Welder then
				self.utilitySlot4 = techIds[1]
			elseif techIds[1] == kTechId.ClusterGrenade or techIds[1] == kTechId.GasGrenade or techIds[1] == kTechId.PulseGrenade or techIds[1] == kTechId.LayMines then
				self.utilitySlot5 = techIds[1]
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
			
			self.utilitySlot4 = player.utilitySlot4 or kTechId.None
			self.utilitySlot5 = player.utilitySlot5 or kTechId.None
			self.grenadesLeft = nil
			self.grenadeType = nil
			
			if player:isa("Marine") then
				self:TransferParasite(player)
			elseif player:isa("Exo") then
				self:TransferParasite( { parasited = player.prevParasited, timeParasited = player.prevParasitedTime } ) 
			end
			
		end
	end
)