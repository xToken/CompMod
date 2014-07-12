//Dont want to always replace random files, so this.

//Fixes for whips below.
function EntityFilterTwoAndIsa(entity1, entity2, classname)
    return function (test) return test == entity1 or test == entity2 or test:isa(classname) end
end

local toEntity = Vector()
function GetCanSeeEntity(seeingEntity, targetEntity, considerObstacles)

    PROFILE("NS2Utility:GetCanSeeEntity")
    
    local seen = false
    
    // See if line is in our view cone
    if targetEntity:GetIsVisible() then
    
        local targetOrigin = HasMixin(targetEntity, "Target") and targetEntity:GetEngagementPoint() or targetEntity:GetOrigin()
        local eyePos = GetEntityEyePos(seeingEntity)
        
        // Not all seeing entity types have a FOV.
        // So default to within FOV.
        local withinFOV = true
        
        // Anything that has the GetFov method supports FOV checking.
        if seeingEntity.GetFov ~= nil then
        
            // Reuse vector
            toEntity.x = targetOrigin.x - eyePos.x
            toEntity.y = targetOrigin.y - eyePos.y
            toEntity.z = targetOrigin.z - eyePos.z
            
            // Normalize vector        
            local toEntityLength = math.sqrt(toEntity.x * toEntity.x + toEntity.y * toEntity.y + toEntity.z * toEntity.z)
            if toEntityLength > kEpsilon then
            
                toEntity.x = toEntity.x / toEntityLength
                toEntity.y = toEntity.y / toEntityLength
                toEntity.z = toEntity.z / toEntityLength
                
            end
            
            local seeingEntityAngles = GetEntityViewAngles(seeingEntity)
            local normViewVec = seeingEntityAngles:GetCoords().zAxis        
            local dotProduct = Math.DotProduct(toEntity, normViewVec)
            local fov = seeingEntity:GetFov()
            
            // players have separate fov for marking enemies as sighted
            if seeingEntity.GetMinimapFov then
                fov = seeingEntity:GetMinimapFov(targetEntity)
            end
            
            local halfFov = math.rad(fov / 2)
            local s = math.acos(dotProduct)
            withinFOV = s < halfFov
            
        end
        
        if withinFOV then
        
            local filter = EntityFilterAllButIsa("Door") // EntityFilterAll()
            if considerObstacles then
				// Weapons dont block FOV
                filter = EntityFilterTwoAndIsa(seeingEntity, targetEntity, "Weapon")
            end
        
            // See if there's something blocking our view of the entity.
            local trace = Shared.TraceRay(eyePos, targetOrigin, CollisionRep.LOS, PhysicsMask.All, filter)
            
            if trace.fraction == 1 then
                seen = true
            end
			
        end
		
    end
    
    return seen
    
end

function AiAttacksMixin:OnTag(tagName)

    PROFILE("AiAttacksMixin:OnTag")

    if self.currentAttack then
    
        // note that all the OnStart and OnHit is only called if the target or location is valid
        
        if tagName == "start" then
        
            if self.currentAttack:IsValid()  then
            
                // uncloak 
                if HasMixin(self, "Cloakable") then
                    self:TriggerUncloak() 
                end
                
                // pay for any energy
                if HasMixin(self, "Energy") then
                    self:SetEnergy(self:GetEnergy() - self.currentAttack.energyCost)
                end
				
				// The animation is already started by the attack starting, sooooooooo wtf.
                /*if self.OnAiAttackStart then
                    self:OnAiAttackStart(self.currentAttack)
                end*/
                
                self.currentAttack:OnStart()
                
            end
            
        end
        
        if tagName == "hit" then
        
            if self.currentAttack:IsValid() then
            
                if self.OnAiAttackHit then
                    self:OnAiAttackHit(self.currentAttack)
                end
                
                self.currentAttack:OnHit()
                
            else
            
                // notify that the target wasn't valid at the hit
                if self.OnAiAttackHitFail then
                    self:OnAiAttackHitFail(self.currentAttack)
                end
                
            end
            
        end
        
        if tagName == "end" then
		
			self.currentAttack:OnEnd()
        
            self:UpdateNextAiAttackTime()
            
			// AI attack mixin handles ending of attacks also, easier to override here.
			// Not all anims might have end tags.
            /*if self.OnAiAttackEnd then
                self:OnAiAttackEnd(self.currentAttack)
            end*/
            
        end
        
    end
    
end

//Guesssssssingggggg..
function AiAttackType:OnEnd()
	local nextAttacktime = 1
	if self:GetIsOnFire() then
		nextAttacktime = 2
	end
	self.nextAttackTime = nextAttacktime
end

