//Dont want to always replace random files, so this.

// Comp Mod change, fade damage type changes
local function DoubleHealthPerArmorForStructures(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
	if target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage(damageType) then
		healthPerArmor = healthPerArmor * (kStructureLightHealthPerArmor / kHealthPointsPerArmor)
		armorFractionUsed = kStructureLightArmorUseFraction
	end
    return damage, armorFractionUsed, healthPerArmor
end

local oldGetDamageByType = GetDamageByType
function GetDamageByType(...)
	local damage, armorUsed, healthUsed = oldGetDamageByType(...)
	kDamageTypeRules[kDamageType.StructuresOnlyLight] = {}
	table.insert(kDamageTypeRules[kDamageType.StructuresOnlyLight], DoubleHealthPerArmorForStructures)
	GetDamageByType = oldGetDamageByType
	//Seems odd, but should just run once to replace.  I hope.
	//If by some strange miracle the fade was the first thing to ever attack something, this would calculate the damage wrong once... im not so concerned.
	return damage, armorUsed, healthUsed
end

local originalFadeOnCreate
originalFadeOnCreate = Class_ReplaceMethod("Fade", "OnCreate",
	function(self)
		originalFadeOnCreate(self)
		self.timeMetabolize = 0
	end
)

function Fade:MovementModifierChanged(newMovementModifierState, input)

    if newMovementModifierState and self:GetActiveWeapon() ~= nil then
		//Just for Rantology
		local weaponMapName = self:GetActiveWeapon():GetMapName()
		local metabweapon = self:GetWeapon(Metabolize.kMapName)
		if metabweapon and not metabweapon:GetHasAttackDelay() and self:GetEnergy() >= metabweapon:GetEnergyCost() then
			self:SetActiveWeapon(Metabolize.kMapName)
			self:PrimaryAttack()
			if weaponMapName ~= Metabolize.kMapName then
				self.previousweapon = weaponMapName
			end
		end
    end
    
end

local originalFadeOnProcessMove
originalFadeOnProcessMove = Class_ReplaceMethod("Fade", "OnProcessMove",
	function(self, input)
		if not self:GetHasMetabolizeAnimationDelay() and self.previousweapon ~= nil then
			self:SetActiveWeapon(self.previousweapon)
			self.previousweapon = nil
		end
		originalFadeOnProcessMove(self, input)
	end
)

function Fade:GetAirFriction()
    return self:GetIsBlinking() and 0 or kFadeAirFriction
end

function Fade:GetCanJump()
    return self:GetIsOnGround() and not self:GetIsBlinking()
end

function Fade:GetIsShadowStepping()
    return false
end

local function GetIsStabbing(self)
	return false
end

ReplaceLocals(Fade.GetMaxSpeed, { GetIsStabbing = GetIsStabbing })

function Fade:GetHasShadowStepAbility()
    return false
end

function Fade:GetHasMetabolizeAnimationDelay()
    return self.timeMetabolize + kMetabolizeAnimationDelay > Shared.GetTime()
end

function Fade:GetMovementSpecialTechId()
    return kTechId.MetabolizeEnergy
end

function Fade:GetMovementSpecialCooldown()
	local cd = 0
	local ttm = (Shared.GetTime() - self.timeMetabolize)
	if ttm < kMetabolizeDelay then
		return Clamp(ttm / kMetabolizeDelay, 0, 1)
	end
	return cd
end

function Fade:GetCanMetabolizeHealth()
    return self:GetHasTwoHives()
end

function Fade:GetMovementSpecialEnergyCost()
    return kMetabolizeEnergyCost
end

function Fade:TriggerShadowStep(direction)
end

local originalFadeOnUpdateAnimationInput = Fade.OnUpdateAnimationInput
function Fade:OnUpdateAnimationInput(modelMixin)
	if not self:GetHasMetabolizeAnimationDelay() then
		originalFadeOnUpdateAnimationInput(self, modelMixin)
	else
		local weapon = self:GetActiveWeapon()
		if weapon ~= nil and weapon.OnUpdateAnimationInput and weapon:GetMapName() == Metabolize.kMapName then
			weapon:OnUpdateAnimationInput(modelMixin)
		end
	end
end

Shared.LinkClassToMap("Fade", nil, {timeMetabolize = "private compensated time"})

local originalJumpMoveMixinOnUpdateAnimationInput = JumpMoveMixin.OnUpdateAnimationInput
function JumpMoveMixin:OnUpdateAnimationInput(modelMixin)
	if not self.GetHasMetabolizeAnimationDelay or not self:GetHasMetabolizeAnimationDelay() then
		originalJumpMoveMixinOnUpdateAnimationInput(self, modelMixin)
	end
end

local originalBlinkOnUpdateAnimationInput
originalBlinkOnUpdateAnimationInput = Class_ReplaceMethod("Blink", "OnUpdateAnimationInput",
	function(self, modelMixin)
		if not self.GetHasMetabolizeAnimationDelay or not self:GetHasMetabolizeAnimationDelay() then
			originalBlinkOnUpdateAnimationInput(self, modelMixin)
		end
	end
)
