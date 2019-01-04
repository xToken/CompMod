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