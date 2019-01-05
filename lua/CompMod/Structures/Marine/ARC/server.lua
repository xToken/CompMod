-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Marine\ARC\server.lua
-- - Dragon

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