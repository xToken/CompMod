-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Server\AlienCommander.lua
-- - Dragon

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

end]]