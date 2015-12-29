// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Server\AlienAdjustments.lua
// - Dragon

//Not truly healable if you're not hurt...
function Alien:GetIsHealableOverride()
	return self:GetIsAlive() and self:AmountDamaged() > 0
end

local originalAlienGetIsHealableOverride
originalAlienGetIsHealableOverride = Class_ReplaceMethod("Alien", "UpdateAutoHeal",
	function(self)
	
		PROFILE("Alien:UpdateAutoHeal")
		local stime = Shared.GetTime()
		
		if self:GetIsHealable() and ( not self.timeLastAlienAutoHeal or self.timeLastAlienAutoHeal + kAlienRegenerationTime <= stime ) then

			local healRate = 1
			local hasRegenUpgrade = GetHasRegenerationUpgrade(self)
			local shellLevel = GetShellLevel(self:GetTeamNumber())
			local maxHealth = self:GetBaseHealth()
			
			hasRegenUpgrade = hasRegenUpgrade and (self.lastTakenDamageTime == nil or stime > self.lastTakenDamageTime + kAlienRegenBlockonDamage)
			
			if hasRegenUpgrade and shellLevel > 0 then
				healRate = Clamp(kAlienRegenerationPercentage * maxHealth, kAlienMinRegeneration, kAlienMaxRegeneration) * (shellLevel/3)
			else
				healRate = Clamp(kAlienInnateRegenerationPercentage * maxHealth, kAlienMinInnateRegeneration, kAlienMaxInnateRegeneration) 
			end
			
			if self:GetIsInCombat() then
				healRate = healRate * kAlienRegenerationCombatModifier
			end

			self:AddHealth(healRate, false, false, not hasRegenUpgrade)  
			self.timeLastAlienAutoHeal = stime
		
		end 

	end
)

function PlayerHallucinationMixin:OnKill()
   self:TriggerEffects("death_hallucination")
   self:SetBypassRagdoll(true)
end

local oldMucousableMixinComputeDamageOverrideMixin = MucousableMixin.ComputeDamageOverrideMixin
function MucousableMixin:ComputeDamageOverrideMixin(attacker, damage, damageType, hitPoint)
	local ogdamage = damage
	damage = oldMucousableMixinComputeDamageOverrideMixin(self, attacker, damage, damageType, hitPoint)
	if damage == 0 and ogdamage > 0 then
		local weapon = attacker:GetActiveWeapon()
		local techId
		if attacker:isa("Alien") and ( weapon.secondaryAttacking or weapon.shootingSpikes) then
			techId = weapon:GetSecondaryTechId()
		else
			techId = weapon:GetTechId()
		end
		if techId and HitSound_IsEnabledForWeapon( techId ) then
			// Damage message will be sent at the end of OnProcessMove by the HitSound system
			HitSound_RecordHit( attacker, self, ogdamage, self:GetOrigin(), ogdamage, techId )
		end
	end
    return damage
end