//Dont want to always replace random files, so this.

function ARC:AcquireTarget()
    
    local finalTarget = nil
	
	if self.orderedEntity ~= Entity.invalidId and self.orderedEntity ~= nil then
		finalTarget = Shared.GetEntity(self.orderedEntity)
	end
	if finalTarget == nil or not self:ValidateTargetPosition(finalTarget:GetOrigin()) or not self:GetCanFireAtTarget(finalTarget, finalTarget:GetOrigin()) then
		finalTarget = self.targetSelector:AcquireTarget()
	end   
    
    if finalTarget ~= nil and self:ValidateTargetPosition(finalTarget:GetOrigin()) then
    
        self:SetMode(ARC.kMode.Targeting)
        self.targetPosition = finalTarget:GetOrigin()
        self.targetedEntity = finalTarget:GetId()
        
    else
    
        self:SetMode(ARC.kMode.Stationary)
        self.targetPosition = nil
		self.orderedEntity = Entity.invalidId
        self.targetedEntity = Entity.invalidId
        
    end
    
end