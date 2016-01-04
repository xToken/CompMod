// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\SkulkAdjustments.lua
// - Dragon

//Skulk is exempt, just replace it
local originalSkulkModifyHeal
originalSkulkModifyHeal = Class_ReplaceMethod("Skulk", "ModifyHeal",
	function(self, healTable)
		if self.isOnFire then
			healTable.health = healTable.health * kOnFireHealingScalar
		end
	end
)

local kLeapTime = GetUpValue( Skulk.PreUpdateMove,   "kLeapTime", { LocateRecurse = true } )
local kNormalWallWalkRange = GetUpValue( Skulk.PreUpdateMove,   "kNormalWallWalkRange", { LocateRecurse = true } )
local kNormalWallWalkFeelerSize = GetUpValue( Skulk.PreUpdateMove,   "kNormalWallWalkFeelerSize", { LocateRecurse = true } )

local originalSkulkPreUpdateMove
originalSkulkPreUpdateMove = Class_ReplaceMethod("Skulk", "PreUpdateMove",
	function(self, input, runningPrediction)
	
		PROFILE("Skulk:PreUpdateMove")
    
		if self:GetCrouching() then
			self.wallWalking = false
		end

		if self.wallWalking then

			// Most of the time, it returns a fraction of 0, which means
			// trace started outside the world (and no normal is returned)           
			local goal = self:GetAverageWallWalkingNormal(kNormalWallWalkRange, kNormalWallWalkFeelerSize)
			if goal ~= nil then
			
				self.wallWalkingNormalGoal = goal
				self.wallWalking = true

			else
				self.wallWalking = false
			end
		
		end
		
		if not self:GetIsWallWalking() then
			// When not wall walking, the goal is always directly up (running on ground).
			self.wallWalkingNormalGoal = Vector.yAxis
		end

		if self.leaping and Shared.GetTime() > self.timeOfLeap + kLeapTime then
			self.leaping = false
		end
			
		self.currentWallWalkingAngles = self:GetAnglesFromWallNormal(self.wallWalkingNormalGoal or Vector.yAxis) or self.currentWallWalkingAngles

		// adjust the sneakOffset so sneaking skulks can look around corners without having to expose themselves too much
		local delta = input.time * math.min(1, self:GetVelocityLength())
		local sneakState = bit.band(input.commands, Move.ReadyRoom) ~= 0
		if sneakState then
			if self.sneakOffset < Skulk.kMaxSneakOffset then
				self.sneakOffset = math.min(Skulk.kMaxSneakOffset, self.sneakOffset + delta)
			end
		else
			if self.sneakOffset > 0 then
				self.sneakOffset = math.max(0, self.sneakOffset - delta)
			end
		end
	
	end
)


local originalSkulkGetMaxSpeed
originalSkulkGetMaxSpeed = Class_ReplaceMethod("Skulk", "GetMaxSpeed",
	function(self, possible)
	
		if possible then
			return kSkulkMaxGroundSpeed
		end

		local maxspeed = kSkulkMaxGroundSpeed
		
		if self.movementModiferState then
			maxspeed = maxspeed * 0.5
		end
		
		return maxspeed
		
	end
)

local Shared_TraceRay = Shared.TraceRay
function WallMovementMixin:GetAverageWallWalkingNormal(extraRange, feelerSize)

    PROFILE("WallMovementMixin:GetAverageWallWalkingNormal")
    
    local startPoint = Vector(self:GetOrigin())
    local extents = self:GetExtents()
    startPoint.y = startPoint.y + extents.y

    local numTraces = 8
	local numVertTraces = 4
    local wallNormals = {}

    // Trace in a circle around self, looking for walls we hit
    local wallWalkingRange = math.max(extents.x, extents.y) + extraRange
    local endPoint = Vector()
    local directionVector
    local angle
    local normalFound = true
    
    if not self.lastSuccessfullWallTraceDir or not self:TraceWallNormal(startPoint, startPoint + self.lastSuccessfullWallTraceDir * wallWalkingRange, wallNormals, feelerSize) then

        normalFound = false

        for i = 0, numTraces - 1 do
        
            angle = ((i * 360/numTraces) / 360) * math.pi * 2
            directionVector = Vector(math.cos(angle), 0, math.sin(angle))
            
            // Avoid excess vector creation
            endPoint.x = startPoint.x + directionVector.x * wallWalkingRange
            endPoint.y = startPoint.y
            endPoint.z = startPoint.z + directionVector.z * wallWalkingRange
            
            if self:TraceWallNormal(startPoint, endPoint, wallNormals, feelerSize) then
            
                self.lastSuccessfullWallTraceDir = directionVector
                normalFound = true
                break
                
            end   
            
        end
    
    end
	
	if not normalFound then
		//Try traces upwards
		endPoint = Vector()
		for i = 0, numVertTraces - 1 do
        
            angle = ((i * 360/numTraces) / 360) * math.pi * 2
            directionVector = Vector(math.cos(angle), 0, math.sin(angle))
			
			endPoint.x = startPoint.x + directionVector.x * wallWalkingRange
            endPoint.y = startPoint.y + wallWalkingRange
            endPoint.z = startPoint.z + directionVector.z * wallWalkingRange
            
            if self:TraceWallNormal(startPoint, endPoint, wallNormals, feelerSize) then
            
                self.lastSuccessfullWallTraceDir = directionVector
                normalFound = true
                break
                
            end
			
		end
		
	end
    
    // Trace above too.
    if not normalFound then
        normalFound = self:TraceWallNormal(startPoint, startPoint + Vector(0, wallWalkingRange, 0), wallNormals, feelerSize)
    end

    if normalFound then
    
        // Check if we are right above a surface we can stand on.
        // Even if we are in "wall walking mode", we want it to look
        // like it is standing on a surface if it is right above it.
        local groundTrace = Shared_TraceRay(startPoint, startPoint + Vector(0, -wallWalkingRange, 0), CollisionRep.Move, PhysicsMask.AllButPCs, EntityFilterOne(self))
        if (groundTrace.fraction > 0 and groundTrace.fraction < 1 and groundTrace.entity == nil) then
            return groundTrace.normal
        end
        
        return wallNormals[1]
        
    end
    
    return nil
    
end