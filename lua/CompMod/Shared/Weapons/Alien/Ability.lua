-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\Ability.lua
-- - Dragon

local originalAbilityGetFocusAttackCooldown
originalAbilityGetFocusAttackCooldown = Class_ReplaceMethod("Ability", "GetFocusAttackCooldown",
	function(self)
		local player = self:GetParent()
		if player then
			return kFocusAttackSlowAtMax/3*player:GetVeilLevel()
		end
		return kFocusAttackSlowAtMax
    end
)