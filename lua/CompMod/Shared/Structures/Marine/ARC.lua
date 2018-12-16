-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\GrenadeLauncher.lua
-- - Dragon

local networkVars =
{
    arc_upg1 = "boolean",
	arc_upg1 = "boolean",
}

local originalARCOnInitialized
originalARCOnInitialized = Class_ReplaceMethod("ARC", "OnInitialized",
	function(self)
		originalARCOnInitialized(self)
		self.arc_upg1 = false
		self.arc_upg2 = false
		
		if Server then
			self:AddTimedCallback(ARC.OnTechOrResearchUpdated, 0.1)
		end
		
	end
)

function ARC:GetMovementSpeed()
	if self.arc_upg1 then
		return ( self:GetIsInCombat() or self:GetGameEffectMask(kGameEffect.OnInfestation) ) and kARCUpgradedCombatMoveSpeed or kARCUpgradedSpeed
	end
	return ( self:GetIsInCombat() or self:GetGameEffectMask(kGameEffect.OnInfestation) ) and kARCCombatMoveSpeed or kARCSpeed
end

function ARC:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.ARCUpgrade1) then
		self.arc_upg1 = true
	else
		self.arc_upg1 = false
	end
	if GetHasTech(self, kTechId.ARCUpgrade2) then
		self.arc_upg2 = true
	else
		self.arc_upg2 = false
	end
end

function ARC:ModifyMaxSpeed(maxSpeedTable)

    maxSpeedTable.maxSpeed = self:GetMovementSpeed()

end

function ARC:GetDamage()
    return self.arc_upg2 and kARCUpgradedDamage or kARCDamage
end

if Server then

	local function PerformAttack(self)

		if self.targetPosition then
		
			self:TriggerEffects("arc_firing")    
			-- Play big hit sound at origin
			
			-- don't pass triggering entity so the sound / cinematic will always be relevant for everyone
			GetEffectManager():TriggerEffects("arc_hit_primary", {effecthostcoords = Coords.GetTranslation(self.targetPosition)})
			
			local hitEntities = GetEntitiesWithMixinWithinRange("Live", self.targetPosition, ARC.kSplashRadius)

			-- Do damage to every target in range
			RadiusDamage(hitEntities, self.targetPosition, ARC.kSplashRadius, ARC.kAttackDamage, self, true)

			-- Play hit effect on each
			for _, target in ipairs(hitEntities) do
			
				if HasMixin(target, "Effects") then
					target:TriggerEffects("arc_hit_secondary")
				end 
			   
			end
			
		end
		
		-- reset target position and acquire new target
		self.targetPosition = nil
		self.targetedEntity = Entity.invalidId
		
	end

	ReplaceLocals(ARC.OnTag, { PerformAttack = PerformAttack })

end

Shared.LinkClassToMap("ARC", ARC.kMapName, networkVars, true)