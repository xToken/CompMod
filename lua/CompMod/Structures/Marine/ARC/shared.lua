-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Marine\ARC\shared.lua
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

Shared.LinkClassToMap("ARC", ARC.kMapName, networkVars, true)