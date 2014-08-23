//Dont want to always replace random files, so this.

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