//Dont want to always replace random files, so this.
//fffffffffffffffffff

local kUmbraModifier = GetUpValue( UmbraMixin.ModifyDamageTaken,   "kUmbraModifier" )

function UmbraMixin:ModifyDamageTaken(damageTable, attacker, doer, damageType)

    if self:GetHasUmbra() then
    
        local modifier = 1
        if doer then
			local umbraDR = kUmbraModifier[doer:GetClassName()] or 1
			if HasMixin(self, "Fire") and self:GetIsOnFire() then
				modifier = 1 - ((1 - umbraDR) * kUmbraOnFireReduction)
			else
				modifier = umbraDR
			end
        end
    
        damageTable.damage = damageTable.damage * modifier
        
    end
    

end