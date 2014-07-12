//Dont want to always replace random files, so this.

local oldUnitStatusMixinGetAbilityFraction = UnitStatusMixin.GetAbilityFraction
function UnitStatusMixin:GetAbilityFraction(forEntity)

    local fraction = oldUnitStatusMixinGetAbilityFraction(self, forEntity)
	local t = { }
	if not GetAreEnemies(forEntity, self) then
		if self:isa("Alien") and not self:isa("Hallucination") then
			fraction = self:GetEnergy() / self:GetMaxEnergy()
			t.Energy = fraction
		end
		if HasMixin(self, "Mucousable") and self:GetHasMucousShield() then
			fraction = self:GetShieldPercentage()
			t.Shield = fraction
		end
	end
	if t.Energy and t.Shield then
		fraction = t
	end
    return fraction    

end