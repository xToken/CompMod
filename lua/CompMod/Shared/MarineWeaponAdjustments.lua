// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\MarineWeaponAdjustments.lua
// - Dragon

//Fix for ghost firing when releasing E.
function Builder:OnDraw(player, previousWeaponMapName)

    Weapon.OnDraw(self, player, previousWeaponMapName)
    self.building = true
    // Attach weapon to parent's hand
    self:SetAttachPoint(Weapon.kHumanAttachPoint)
    
end

function Builder:OnUpdateAnimationInput(modelMixin)

    PROFILE("Builder:OnUpdateAnimationInput")
    
    local activity = "none"
    if self.building then
        activity = "primary"
    end
    
    modelMixin:SetAnimationInput("activity", activity)
    modelMixin:SetAnimationInput("welder", false)
    self:SetPoseParam("welder", 0)
    
end

if Client then

	local oldRifleUpdateAttackEffects = Rifle.UpdateAttackEffects
	function Rifle:UpdateAttackEffects(deltaTime)
    end
	
	//This seems wierd, but updating in the above callback isnt really the 'best' way.  Its the same function as the mixin, so call orders are messy.
	function Rifle:OnClientPrimaryAttacking()
		oldRifleUpdateAttackEffects(self, deltaTime)
    end
	
	Class_Reload("Rifle")
	
end