//Dont want to always replace random files, so this.

function UmbraMixin:ModifyDamageTaken(damageTable, attacker, doer, damageType)

    if self:GetHasUmbra() then
    
        local modifier = 1
        if doer then
			if HasMixin(self, "Fire") and self:GetIsOnFire() then
				modifier = 1 - ((1 - kUmbraModifier[doer:GetClassName()] or 1) * kUmbraOnFireReduction)
			else
				modifier = kUmbraModifier[doer:GetClassName()] or 1
			end
        end
    
        damageTable.damage = damageTable.damage * modifier
        
    end
    

end