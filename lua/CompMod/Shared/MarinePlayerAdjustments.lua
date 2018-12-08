-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\MarinePlayerAdjustments.lua
-- - Dragon

-- Offer overrides to increase ROF (Catalyst ONLY increases reload speeds in vanilla)
function Marine:OnUpdateAnimationInput(modelMixin)

    PROFILE("Marine:OnUpdateAnimationInput")
    
    Player.OnUpdateAnimationInput(self, modelMixin)
    
    local animationLength = modelMixin:isa("ViewModel") and 0 or 0.5
    
    if not self:GetIsJumping() and self:GetIsSprinting() then
        modelMixin:SetAnimationInput("move", "sprint")
    end

    if self:GetIsStunned() and self:GetRemainingStunTime() > animationLength then
        modelMixin:SetAnimationInput("move", "stun")
    end
    
    local activeWeapon = self:GetActiveWeapon()
    local catalystSpeed = 1
	local attackSpeed = 1
    
    if activeWeapon and activeWeapon.GetCatalystSpeedBase then
        catalystSpeed = activeWeapon:GetCatalystSpeedBase()
    end
    
    if self.catpackboost then
        catalystSpeed = kCatPackWeaponSpeed * catalystSpeed
    end
	
	if activeWeapon and activeWeapon.GetBaseAttackSpeed then
        attackSpeed = activeWeapon:GetBaseAttackSpeed()
    end
	
	modelMixin:SetAnimationInput("attack_speed", attackSpeed)

    modelMixin:SetAnimationInput("catalyst_speed", catalystSpeed)
    
end