-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Marine\ClusterGrenade\shared.lua
-- - Dragon

local CreateFragments = GetUpValue( ClusterGrenade.Detonate, "CreateFragments")
local kGrenadeCameraShakeDistance = GetUpValue( ClusterGrenade.Detonate, "kGrenadeCameraShakeDistance")
local kGrenadeMinShakeIntensity = GetUpValue( ClusterGrenade.Detonate, "kGrenadeMinShakeIntensity")
local kGrenadeMaxShakeIntensity = GetUpValue( ClusterGrenade.Detonate, "kGrenadeMaxShakeIntensity")

function ClusterGrenade:Detonate(targetHit)

        CreateFragments(self)

        local hitEntities = GetEntitiesWithMixinWithinRange("Live", self:GetOrigin(), kClusterGrenadeDamageRadius)
		local owner = Shared.GetEntity(self.ownerId)
		
		for i = 1, #hitEntities do
			local ent = hitEntities[i]
			if ent ~= owner and owner then
				if HasMixin(ent, "Fire") then
					ent:SetOnFire(owner, self)
				end
			end
		end
		
        table.removevalue(hitEntities, self)

        if targetHit then
            table.removevalue(hitEntities, targetHit)
            self:DoDamage(kClusterGrenadeDamage, targetHit, targetHit:GetOrigin(), GetNormalizedVector(targetHit:GetOrigin() - self:GetOrigin()), "none")
        end

        RadiusDamage(hitEntities, self:GetOrigin(), kClusterGrenadeDamageRadius, kClusterGrenadeDamage, self)
        
        local surface = GetSurfaceFromEntity(targetHit)

        local params = { surface = surface }
        if not targetHit then
            params[kEffectHostCoords] = Coords.GetLookIn( self:GetOrigin(), self:GetCoords().zAxis)
        end
        
        self:TriggerEffects("cluster_grenade_explode", params)
        CreateExplosionDecals(self)
        TriggerCameraShake(self, kGrenadeMinShakeIntensity, kGrenadeMaxShakeIntensity, kGrenadeCameraShakeDistance)
        
        DestroyEntity(self)

end