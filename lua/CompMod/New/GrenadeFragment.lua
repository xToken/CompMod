-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\New\GrenadeFragment.lua
-- - Dragon

class 'GrenadeFragment' (Projectile)

GrenadeFragment.kMapName = "grenadefragment"

local networkVars = { }

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ModelMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)

function GrenadeFragment:OnCreate()

    Projectile.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ModelMixin)
    InitMixin(self, DamageMixin)
	
    if Server then
        self:AddTimedCallback(GrenadeFragment.TimedDetonateCallback, math.random() * 1 + 0.5)
    end
    
end

function GrenadeFragment:GetProjectileModel()
    return GrenadeFragment.kModelName
end

function GrenadeFragment:GetDeathIconIndex()
    return kDeathMessageIcon.Grenade
end

function GrenadeFragment:GetDamageType()
    return kGrenadeLauncherGrenadeDamageType
end

function GrenadeFragment:GetIsAffectedByWeaponUpgrades()
    return true
end

function GrenadeFragment:GetWeaponTechId()
    return kTechId.GrenadeLauncher
end

if Server then

    function GrenadeFragment:TimedDetonateCallback()
        self:Detonate()
    end

    function GrenadeFragment:Detonate(targetHit)

        local hitEntities = GetEntitiesWithMixinWithinRange("Live", self:GetOrigin(), kGrenadeFragmentDamageRadius)
        table.removevalue(hitEntities, self)

        if targetHit then
            table.removevalue(hitEntities, targetHit)
            self:DoDamage(kGrenadeFragmentDamage, targetHit, targetHit:GetOrigin(), GetNormalizedVector(targetHit:GetOrigin() - self:GetOrigin()), "none")
        end

        RadiusDamage(hitEntities, self:GetOrigin(), kGrenadeFragmentDamageRadius, kGrenadeFragmentDamage, self)
        
        local surface = GetSurfaceFromEntity(targetHit)

        local params = { surface = surface }
        if not targetHit then
            params[kEffectHostCoords] = Coords.GetLookIn( self:GetOrigin(), self:GetCoords().zAxis)
        end
        
        self:TriggerEffects("cluster_fragment_explode", params)
        CreateExplosionDecals(self)
        DestroyEntity(self)

    end

end

Shared.LinkClassToMap("GrenadeFragment", GrenadeFragment.kMapName, networkVars)