//Dont want to always replace random files, so this.

/*function PlayerHallucinationMixin:OnKill()
   self:TriggerEffects("death_hallucination")
   self:SetBypassRagdoll(true)
end*/

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

function EnzymeCloud:Perform()
        
	// search for aliens in range and buff their speed by 25%  
	for _, alien in ipairs(GetEntitiesForTeamWithinRange("Alien", self:GetTeamNumber(), self:GetOrigin(), EnzymeCloud.kRadius)) do
		alien:TriggerEnzyme(EnzymeCloud.kOnPlayerDuration)
	end
	
	// Comp Mod change, removed Enzyme Speed Boost.
	/*for _, unit in ipairs(GetEntitiesWithMixinForTeamWithinRange("Storm", self:GetTeamNumber(), self:GetOrigin(), EnzymeCloud.kRadius)) do
		unit:SetSpeedBoostDuration(kUnitSpeedBoostDuration)
	end*/

end

//Fix for double catpacks?
function CatPack:OnInitialized()

    DropPack.OnInitialized(self)
    
    self:SetModel(CatPack.kModelName)
    
    InitMixin(self, PickupableMixin, { kRecipientType = {"Marine", "Exo"} })

end