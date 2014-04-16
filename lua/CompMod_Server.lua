//Dont want to always replace random files, so this.

// Possible Comp Mod change regarding Hallu's, not approved currently.
/*
function PlayerHallucinationMixin:OnKill()
   self:TriggerEffects("death_hallucination")
   self:SetBypassRagdoll(true)
end
*/

function MucousMembrane:Perform()

	//Not a huge fan of this, but this heals HP based on max armor :S
	for _, unit in ipairs(GetEntitiesWithMixinForTeamWithinRange("Live", self:GetTeamNumber(), self:GetOrigin(), MucousMembrane.kRadius)) do
		// Comp Mod change, this now heals health, but at twice the rate.
		if unit:GetHealth() < unit:GetMaxHealth() then
			local addHealth = Clamp(unit:GetMaxArmor() * MucousMembrane.kThinkTime * 0.5, 2, 10)
			unit:SetHealth(math.min(unit:GetHealth() + addHealth, unit:GetMaxHealth()))
		end
	end

end