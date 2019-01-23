-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Player\shared.lua
-- - Dragon

local originalPlayerOnGroundChanged
originalPlayerOnGroundChanged = Class_ReplaceMethod("Player", "OnGroundChanged",
	function(self, onGround, impactForce, normal, velocity)
		if onGround and self:GetTriggerLandEffect() and impactForce > 5 then
		
			local landSurface = GetSurfaceAndNormalUnderEntity(self)
			self:TriggerEffects("land", { surface = landSurface })
			
		end
		
		if normal and normal.y > 0.5 and self:GetSlowOnLand(impactForce) then    
		
			local slowdownScalar = Clamp(math.max(0, impactForce - 4) / 18, 0, 1)
			if self.ModifyJumpLandSlowDown then
				slowdownScalar = self:ModifyJumpLandSlowDown(slowdownScalar)
			end
			
			self:AddSlowScalar(slowdownScalar)
			velocity:Scale(1 - slowdownScalar)  
			
		end
	end
)

local function AttemptToUse(self, timePassed)

    PROFILE("Player:AttemptToUse")
    
    assert(timePassed >= 0)
    
    -- Cannot use anything unless playing the game (a non-spectating player).
    if Shared.GetTime() - self.timeOfLastUse < kUseInterval or self:isa("Spectator") then
        return false
    end
    
    -- Trace to find use entity.
    local entity, usablePoint = self:PerformUseTrace()
    -- Calc time since last use, if we are holding its simply the diff.  Otherwise, use max time plus half the move time for good avg
    local useTime = math.min(Shared.GetTime() - self.timeOfLastUse, kUseInterval + timePassed/2)
    
    -- Use it.
    if entity then
    
        -- if the game isn't started yet, check if the entity is usuable in non-started game
        -- (allows players to select commanders before the game has started)
        if not self:GetGameStarted() and not (entity.GetUseAllowedBeforeGameStart and entity:GetUseAllowedBeforeGameStart()) then
            return false
        end
        
        -- Use it.
        if self:UseTarget(entity, useTime) then
        
            self:SetIsUsing(true)
            self.timeOfLastUse = Shared.GetTime()
            return true
            
        end
        
    end
    
end

ReplaceUpValue(Player.HandleButtons, "AttemptToUse", AttemptToUse)