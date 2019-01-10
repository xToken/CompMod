-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Alien\Fade\shared.lua
-- - Dragon

function Fade:GetGroundTransistionTime()
    return 0.2
end

local kFadeOffsetSpeed = 5
local kFadeModelOffsetAmount = 0.70

local originalFadeOnCreate
originalFadeOnCreate = Class_ReplaceMethod("Fade", "OnCreate",
	function(self)
		originalFadeOnCreate(self)
		self.updateOffset = false
		self.modelOffset = 0
	end
)

local originalFadeModifyVelocity
originalFadeModifyVelocity = Class_ReplaceMethod("Fade", "ModifyVelocity",
	function(self, input, velocity, deltaTime)

		originalFadeModifyVelocity(self, input, velocity, deltaTime)

		-- Model offset for crouching blinking fades		
		-- Trace up to make sure we are against the ceiling.
		self.updateOffset = false
		local crouchoffset = self:GetCrouchAmount()

		-- Only update if we are crouching, or if our model is offset already
		if crouchoffset > 0 or self.modelOffset > 0 then
			local origin = self:GetOrigin()
			local maxoffset = math.min(crouchoffset - self:ModifyCrouchAnimation(crouchoffset), 1)
			local upTrace = Shared.TraceRay(origin, origin + Vector(0, 2, 0), CollisionRep.Move, PhysicsMask.AllButPCs, EntityFilterOneAndIsa(self, "Babbler"))

			-- This seems to return ghosted traces... so minimum trace to ensure we actually found SOMETHING above us thats REALLLY there
			if upTrace.fraction > 0.3 and upTrace.fraction < 0.8 then
				-- The ceiling is here.
				-- Trace down to make sure we are not against the floor.
				local downTrace = Shared.TraceRay(origin, origin - Vector(0, kFadeModelOffsetAmount + 0.1, 0), CollisionRep.Move, PhysicsMask.AllButPCs, EntityFilterOneAndIsa(self, "Babbler"))
				if downTrace.fraction == 1 then
					-- Not against the floor, update offset
					self.updateOffset = true
				end
			end
			
		    if self.updateOffset and self.modelOffset < maxoffset then
		        self.modelOffset = Clamp(self.modelOffset + (input.time * math.abs(velocity.y) * kFadeOffsetSpeed), 0, maxoffset)
		    elseif not self.updateOffset and self.modelOffset > 0 then
		    	self.modelOffset = Clamp(self.modelOffset - (input.time * math.abs(velocity.y) * kFadeOffsetSpeed), 0, maxoffset)
		    end
		end
	end
)

function Fade:OnAdjustModelCoords(modelCoords)
    modelCoords.origin = modelCoords.origin - Vector(0, self.modelOffset * kFadeModelOffsetAmount, 0)
    return modelCoords
end

function Fade:GetAdrenalineRecuperationRate()
	return kFadeAdrenalineRecuperationScalar
end

-- Actually set these values since locals
ReplaceLocals(Fade.GetMaxSpeed, { kMaxSpeed = kFadeMaxSpeed })
ReplaceLocals(Fade.GetMaxSpeed, { kBlinkSpeed = kFadeBlinkSpeed })

Shared.LinkClassToMap("Fade", Fade.kMapName, { modelOffset = "compensated interpolated float (0 to 1 by 0.01)", updateOffset = "compensated boolean" }, true)