// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\UnitStatusMixinAdjustments.lua
// - Dragon

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