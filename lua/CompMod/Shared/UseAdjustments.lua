// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\UseAdjustments.lua
// - Dragon

Script.Load("lua/Class.lua")

local function AttemptToUse(self, timePassed)

    PROFILE("Player:AttemptToUse")
    
    assert(timePassed >= 0)
	local t = Shared.GetTime()
    
    if (t - self.timeOfLastUse) < kUseInterval then
        return false
    end
    
    -- Cannot use anything unless playing the game (a non-spectating player).
    if not self:GetIsOnPlayingTeam() then
        return false
    end
    
    if GetIsVortexed(self) then
        return false
    end
    
    -- Trace to find use entity.
    local entity, usablePoint = self:PerformUseTrace()
    
    -- Use it.
    if entity then
    
        -- if the game isn't started yet, check if the entity is usuable in non-started game
        -- (allows players to select commanders before the game has started)
        if not self:GetGameStarted() and not (entity.GetUseAllowedBeforeGameStart and entity:GetUseAllowedBeforeGameStart()) then
            return false
        end
        
		local dt = t - self.timeOfLastUse
		if self.timeOfLastUse == 0 then
			dt = kUseInterval
		end
        -- Use it.
        if self:UseTarget(entity, dt) then
        
            self:SetIsUsing(true)
            self.timeOfLastUse = t
            return true
            
        end
        
    end
    
end

ReplaceLocals(Player.HandleButtons, { AttemptToUse = AttemptToUse })

local originalMarineOnUseEnd
originalMarineOnUseEnd = Class_ReplaceMethod("Marine", "OnUseEnd",
	function(self)
		originalMarineOnUseEnd(self)
		self.timeOfLastUse = 0
	end
)

//just in case
function Player:OnUseEnd()
	self.timeOfLastUse = 0
end

function ConstructMixin:OnUse(player, elapsedTime, useSuccessTable)

    local used = false

    if not GetIsAlienUnit(self) and self:GetCanConstruct(player) then
		
		//If interpolation of fields works in a logical way, you actually
		//would want to pass the correct time delta here.  Passing a constant time
		//regardless of actual elapsed time would lead to slight fluxuations in the prediction.
        local success, playAV = self:Construct(elapsedTime, player)
        
        if success then

            used = true
        
        end
                
    end
    
    useSuccessTable.useSuccess = useSuccessTable.useSuccess or used
    
end