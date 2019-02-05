-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Alien\AlienCommander\server.lua
-- - Dragon

local kDrifterOrderScanRange = 40

local function GetNearestDrifter(self, orderType)

    local ents = GetEntitiesForTeam("Drifter", self:GetTeamNumber())
    Shared.SortEntitiesByDistance(self:GetOrigin(), ents)
    local isEchoOrder = GetIsEchoTeleportTechId(orderType)
    local isBuildOrder = table.contains(kDrifterStructures, orderType)
    local isCloudOrder = GetIsDrifterCloudTechId(orderType)
    -- Grab nearest drifter performing same type of order, or just nearest drifter
    for i = 1, #ents do
    	local dist = (ents[i]:GetOrigin() - self:GetOrigin()):GetLengthSquared()
    	local currentOrder = ents[i]:GetCurrentOrder()
    	if currentOrder and dist < (kDrifterOrderScanRange*kDrifterOrderScanRange) then
        	local techId = currentOrder:GetType()
        	if isEchoOrder and GetIsEchoTeleportTechId(techId) then
        		-- This drifter is echoing, and we have an echo order
        		return ents[i]
        	elseif isBuildOrder and table.contains(kDrifterStructures, techId) then
        		-- This drifter is building, and we have a build order
        		return ents[i]
        	elseif isCloudOrder and GetIsDrifterCloudTechId(orderType) then
        		--Who knows what this drifter is doing
        		return ents[i]
        	end
        end
    end
    return ents[1]

end

function AlienCommander:TrackedEntityUpdate(techId, newCount)
	if techId == kTechId.Shell then
		self.shellCount = Clamp(newCount, 0, 3)
	elseif techId == kTechId.Spur then
		self.spurCount = Clamp(newCount, 0, 3)
	elseif techId == kTechId.Veil then
		self.veilCount = Clamp(newCount, 0, 3)
	end
end

-- Really NS2?
function AlienCommander:OnProcessMove(input)

    Commander.OnProcessMove(self, input)
    
    if Server then
    
        UpdateAbilityAvailability(self, self.tierOneTechId, self.tierTwoTechId, self.tierThreeTechId)
        
        --self.shellCount = Clamp( #GetEntitiesForTeam("Shell", self:GetTeamNumber()), 0, 3)
        --self.spurCount = Clamp( #GetEntitiesForTeam("Spur", self:GetTeamNumber()), 0, 3)
        --self.veilCount = Clamp( #GetEntitiesForTeam("Veil", self:GetTeamNumber()), 0, 3) 
        
    end
    
end

function AlienCommander:ProcessMist(pickVec, orientation, worldCoordsSpecified, targetId)

    local targetEnt = Shared.GetEntity(targetId)
    local success = false

    if targetEnt then

        local team = self:GetTeam()
        local cost = GetCostForTech(kTechId.NutrientMist)

        -- Dont allow stacking more than 30s of catalyst
        if HasMixin(targetEnt, "Catalyst") and (not targetEnt.DisableSustenance or not targetEnt:DisableSustenance()) then
        	local duration = kNutrientMistDuration
        	if targetEnt.GetSustenanceScalar then
        		duration = duration * targetEnt:GetSustenanceScalar()
        	end
            if targetEnt:GetCanCatalyst(duration) then
                targetEnt:TriggerCatalyst(duration)
                self:TriggerEffects("comm_nutrient_mist")
                team:AddTeamResources(-cost)
                success = true
            end
        end

    end

    if not success then
    	self:TriggerInvalidSound()
    end

end

local oldAlienCommanderProcessTechTreeAction = AlienCommander.ProcessTechTreeAction
function AlienCommander:ProcessTechTreeAction(techId, pickVec, orientation, worldCoordsSpecified, targetId, shiftDown)
	if techId == kTechId.NutrientMist then
		self:ProcessMist(pickVec, orientation, worldCoordsSpecified, targetId)
		return false, false
	end
	if techId == kTechId.Cyst then
		-- bypass normal cyst logic
		return Commander.ProcessTechTreeAction(self, techId, pickVec, orientation, worldCoordsSpecified, targetId, shiftDown)  
	end
	return oldAlienCommanderProcessTechTreeAction(self, techId, pickVec, orientation, worldCoordsSpecified, targetId, shiftDown)
end

local GetNearest = GetUpValue( AlienCommander.ProcessTechTreeActionForEntity, "GetNearest" )

local oldAlienCommanderProcessTechTreeActionForEntity = AlienCommander.ProcessTechTreeActionForEntity
function AlienCommander:ProcessTechTreeActionForEntity(techNode, position, normal, pickVec, orientation, entity, trace, targetId)
	local techId = techNode:GetTechId()
	if GetIsEchoTeleportTechId(techId) and targetId then
		if not entity then
			entity = GetNearestDrifter(self, techId)
		end
		if entity then
			return entity:PerformActivation(techId, position, normal, self, targetId)
		end
		return false, false
	end
	if table.contains(kDrifterStructures, techId) then
		if not entity then
			entity = GetNearestDrifter(self, techId)
		end
		if entity then
			return entity:PerformActivation(techId, position, normal, self, targetId)
		end
		return false, false
	end
	if techId == kTechId.EnzymeCloud or techId == kTechId.Hallucinate or techId == kTechId.MucousMembrane or techId == kTechId.Storm or techId == kTechId.ParasiteCloud then
		if not entity then
			entity = GetNearestDrifter(self, techId)
		end
		if entity then
			return entity:PerformActivation(techId, position, normal, self, targetId)
		end
		return false, false
	end
	if not entity and techId == kTechId.ShiftEnergize then
        local className = "Shift"
        entity = GetNearest(self, className)
    end
	return oldAlienCommanderProcessTechTreeActionForEntity(self, techNode, position, normal, pickVec, orientation, entity, trace, targetId)
end

-- Disabled directly castable alien commander abilities
--[[
local function GetIsCloud(techId)
    return techId == kTechId.EnzymeCloud or techId == kTechId.Hallucinate or techId == kTechId.MucousMembrane or techId == kTechId.Storm
end

local GetNearest = GetUpValue( AlienCommander.ProcessTechTreeActionForEntity, "GetNearest" )
local GetIsPheromone = GetUpValue( AlienCommander.ProcessTechTreeActionForEntity, "GetIsPheromone" )

function AlienCommander:ProcessTechTreeActionForEntity(techNode, position, normal, pickVec, orientation, entity, trace, targetId)
    
	local techId = techNode:GetTechId()
	local success = false
	local keepProcessing = false
	local processForEntity = true
	
	if not entity and ( techId == kTechId.ShadeInk or techId == kTechId.HealWave ) then
	
		local className = techId == kTechId.HealWave and "Crag" or "Shade"
		entity = GetNearest(self, className)
		processForEntity = entity ~= nil
		
	end

	if techId == kTechId.Cyst then
		success = self:BuildCystChain(position)
	elseif techId == kTechId.SelectDrifter then

		SelectNearest(self, "Drifter")

	elseif GetIsPheromone(techId) then

		success = CreatePheromone(techId, position, self:GetTeamNumber()) ~= nil
		keepProcessing = false

	elseif GetIsCloud(techId) then

		success = self:TriggerKhammAbilities(techId, position, trace)
		keepProcessing = false

	end
	
	if success then
	
		local location = GetLocationForPoint(position)
		local locationName = location and location:GetName() or ""
		self:TriggerNotification(Shared.GetStringIndex(locationName), techId)

	elseif processForEntity then
		success, keepProcessing = Commander.ProcessTechTreeActionForEntity(self, techNode, position, normal, pickVec, orientation, entity, trace, targetId)
	end
	
	return success, keepProcessing
	
end

function AlienCommander:TriggerKhammAbilities(techId, position, trace)

    local team = self:GetTeam()
    local cost = GetCostForTech(techId)

    if cost <= team:GetTeamResources() then

        self:TriggerEffects("drifter_shoot_enzyme", {effecthostcoords = Coords.GetTranslation(position)} )

        local mapName = LookupTechData(techId, kTechDataMapName)
        if mapName then

            local cloudEntity = CreateEntity(mapName, position, self:GetTeamNumber())
            team:AddTeamResources(-cost)
			
			return true

        end

    end
	
	return false

end
--]]