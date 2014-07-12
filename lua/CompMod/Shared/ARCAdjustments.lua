//Dont want to always replace random files, so this.

// Comp Mod change, allow targetting of arcs.
function ARC:GetTechButtons(techId)

    return  { kTechId.Stop, kTechId.Attack, kTechId.None, kTechId.None,
              kTechId.ARCDeploy, kTechId.ARCUndeploy, kTechId.None, kTechId.None }
              
end

function ARC:OnOverrideOrder(order)
	if order:GetType() == kTechId.Default then
		if self.deployMode == ARC.kDeployMode.Deployed then
			order:SetType(kTechId.Attack)
		else
			order:SetType(kTechId.Move)
		end
	end
end

function ARC:OnOrderGiven(order)
	if order ~= nil and (order:GetType() == kTechId.Attack or order:GetType() == kTechId.SetTarget) then
		local target = Shared.GetEntity(order:GetParam())
		if target then
			local dist = (self:GetOrigin() - target:GetOrigin()):GetLength()
			local valid = true
			if not HasMixin(target, "Live") or not target:GetIsAlive() then
				valid = false
			end
			if not GetAreEnemies(self, target) then        
				valid = false
			end
			if not target.GetReceivesStructuralDamage or not target:GetReceivesStructuralDamage() then        
				valid = false
			end
			if dist and valid and dist >= ARC.kMinFireRange and dist <= ARC.kFireRange then
				self.targetedEntity = order:GetParam()
				self.orderedEntity = order:GetParam()
			end
		end
    end
end