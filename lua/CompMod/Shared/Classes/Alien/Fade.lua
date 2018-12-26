-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\Fade.lua
-- - Dragon

function Fade:GetGroundTransistionTime()
    return 0.2
end

local kFadeOffsetSpeed = 10
local kFadeModelOffset = 0.70

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
		-- Default to no updates
		local origin = self:GetOrigin()
		self.updateOffset = false
		local upTrace = Shared.TraceRay(origin, origin + Vector(0, 2, 0), CollisionRep.Move, PhysicsMask.AllButPCs, EntityFilterOneAndIsa(self, "Babbler"))
		if upTrace.fraction < 0.8 then
			-- The ceiling is here.
			-- Trace down to make sure we are not against the floor.
			local downTrace = Shared.TraceRay(origin, origin - Vector(0, kFadeModelOffset + 0.1, 0), CollisionRep.Move, PhysicsMask.AllButPCs, EntityFilterOne(self))
			if downTrace.fraction == 1 then
				-- Not against the floor, update offset
				self.updateOffset = true
			end
		end
		
		local crouchoffset = self:GetCrouchAmount() 
		local modelcrouchoffset = self:ModifyCrouchAnimation(crouchoffset)
		local maxoffset = math.min(crouchoffset - modelcrouchoffset, 1)
	    if crouchoffset > 0 and self.updateOffset then
	        if self.modelOffset < maxoffset then
	            self.modelOffset = Clamp(self.modelOffset + (input.time * math.abs(velocity.y) * kFadeOffsetSpeed), 0, maxoffset)
	        end
	    else
	        if self.modelOffset > 0 then
	            self.modelOffset = Clamp(self.modelOffset - (input.time * math.abs(velocity.y) * kFadeOffsetSpeed), 0, 1)
	        end
	    end
	end
)

function Fade:OnAdjustModelCoords(modelCoords)
    modelCoords.origin = modelCoords.origin - Vector(0, self.modelOffset * kFadeModelOffset, 0)
    return modelCoords
end

-- Actually set these values since locals
ReplaceLocals(Fade.GetMaxSpeed, { kMaxSpeed = kFadeMaxSpeed })
ReplaceLocals(Fade.GetMaxSpeed, { kBlinkSpeed = kFadeBlinkSpeed })

Shared.LinkClassToMap("Fade", Fade.kMapName, { modelOffset = "compensated interpolated float (0 to 1 by 0.01)", updateOffset = "compensated boolean" }, true)