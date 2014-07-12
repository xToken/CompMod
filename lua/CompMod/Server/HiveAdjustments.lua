//Dont want to always replace random files, so this.

// Changes to handle evolution chamber for each Hive.
local oldHiveOnConstructionComplete = Hive.OnConstructionComplete
function Hive:OnConstructionComplete()
    oldHiveOnConstructionComplete(self)
	local evochamber = CreateEntityForTeam(kTechId.EvolutionChamber, self:GetOrigin(), self:GetTeamNumber(), nil)
	if evochamber then
		local origin = evochamber:GetOrigin()
		origin.y = origin.y - 3.9
		evochamber:SetOrigin(origin)
		self:SetEvolutionChamber(evochamber:GetId())
	end
end

function Hive:SetEvolutionChamber(chamberId)
	self.evochamber = chamberId
end

local oldHiveOnKill = Hive.OnKill
function Hive:OnKill(attacker, doer, point, direction)
	oldHiveOnKill(self, attacker, doer, point, direction)
	if self:GetEvolutionChamber() ~= Entity.invalidId and self:GetIsBuilt() then
		local evochamber = Shared.GetEntity(self:GetEvolutionChamber())
		local techTree = self:GetTeam():GetTechTree()
		if evochamber and evochamber:isa("EvolutionChamber") then
			if techTree then
				evochamber:PerformAction(techTree:GetTechNode(kTechId.Cancel), evochamber:GetOrigin()) // Trigger research abort :S
			end
			DestroyEntity(evochamber)
		end
	end
end

local function UpdateHealing(self)

    if GetIsUnitActive(self) then
    
        if self.timeOfLastHeal == nil or Shared.GetTime() > (self.timeOfLastHeal + Hive.kHealthUpdateTime) then
            
            local players = GetEntitiesForTeam("Player", self:GetTeamNumber())
            
            for index, player in ipairs(players) do
            
                if player:GetIsAlive() and ((player:GetOrigin() - self:GetOrigin()):GetLength() < Hive.kHealRadius) then   
                    // min healing, affects skulk only
					local heal = math.max(10, player:GetMaxHealth() * Hive.kHealthPercentage)					
					if player.GetBaseHealth then
						//Shared.Message(string.format("Healing reduced to %s from %s", math.max(10, player:GetBaseHealth() * Hive.kHealthPercentage)	, heal))
						heal = math.max(10, player:GetBaseHealth() * Hive.kHealthPercentage)	
					end
                    player:AddHealth(heal, true )       
                end
                
            end
            
            self.timeOfLastHeal = Shared.GetTime()
            
        end
        
    end
    
end

ReplaceLocals(Hive.OnUpdate, { UpdateHealing = UpdateHealing })