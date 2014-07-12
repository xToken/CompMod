//Dont want to always replace random files, so this.

/*function PlayerHallucinationMixin:OnKill()
   self:TriggerEffects("death_hallucination")
   self:SetBypassRagdoll(true)
end*/

function MucousMembrane:Perform()

	//Activate shield on any 'mucousable' ents nearby
	for _, unit in ipairs(GetEntitiesWithMixinForTeamWithinRange("Mucousable", self:GetTeamNumber(), self:GetOrigin(), MucousMembrane.kRadius)) do
		unit:SetMucousShield()
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

function OnCommanderLogOut(commander)
end

//Fix for double catpacks?
function CatPack:OnInitialized()

    DropPack.OnInitialized(self)
    
    self:SetModel(CatPack.kModelName)
    
    InitMixin(self, PickupableMixin, { kRecipientType = {"Marine", "Exo"} })

end