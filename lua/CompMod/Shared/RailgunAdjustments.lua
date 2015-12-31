// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\RailgunAdjustments.lua
// - Dragon

local kChargeTime = GetUpValue( Railgun.OnTag,   "kChargeTime", { LocateRecurse = true } )
local kBulletSize = GetUpValue( Railgun.OnTag,   "kBulletSize", { LocateRecurse = true } )

local function ExecuteAOEShot(self, startPoint, endPoint, player)

    // Filter ourself out of the trace so that we don't hit ourselves.
    local filter = EntityFilterTwo(player, self)
    local trace = Shared.TraceRay(startPoint, endPoint, CollisionRep.Damage, PhysicsMask.Bullets, EntityFilterAllButIsa("Tunnel"))
    local hitPointOffset = trace.normal * 0.3
    local direction = (endPoint - startPoint):GetUnit()
    local damage = kModRailgunDamage + math.min(1, (Shared.GetTime() - self.timeChargeStarted) / kChargeTime) * kModRailgunChargeDamage
    
    local extents = GetDirectedExtentsForDiameter(direction, kBulletSize)
    
    if trace.fraction < 1 then
            
		local capsuleTrace = Shared.TraceBox(extents, startPoint, trace.endPoint, CollisionRep.Damage, PhysicsMask.Bullets, filter)
		local hitEntities = GetEntitiesWithMixinWithinRange("Live", capsuleTrace.endPoint + hitPointOffset, kRailgunSplashRadius)        
		if capsuleTrace.entity then
			local e = capsuleTrace.entity
			self:DoDamage(damage, capsuleTrace.entity, capsuleTrace.endPoint + hitPointOffset, direction, capsuleTrace.surface, false, false)
			table.removevalue(hitEntities, capsuleTrace.entity)
		end
		// Do damage to every target in range
		RadiusDamage(hitEntities, trace.endPoint + hitPointOffset, kRailgunSplashRadius, damage, self)

    end
    
end

local kRailgunSpread = GetUpValue( Railgun.OnTag,   "kRailgunSpread", { LocateRecurse = true } )
local ExecuteShot = GetUpValue( Railgun.OnTag,   "ExecuteShot", { LocateRecurse = true } )
local TriggerSteamEffect = GetUpValue( Railgun.OnTag,   "TriggerSteamEffect", { LocateRecurse = true } )
local kRailgunRange = GetUpValue( Railgun.OnTag,   "kRailgunRange", { LocateRecurse = true } )

local function Shoot(self, leftSide)

    local player = self:GetParent()
    
    // We can get a shoot tag even when the clip is empty if the frame rate is low
    // and the animation loops before we have time to change the state.
    if player and not Predict then
    
        player:TriggerEffects("railgun_attack")
        
        local viewAngles = player:GetViewAngles()
        local shootCoords = viewAngles:GetCoords()
        
        local startPoint = player:GetEyePos()
        
        local spreadDirection = CalculateSpread(shootCoords, kRailgunSpread, NetworkRandom)
        
        local endPoint = startPoint + spreadDirection * kRailgunRange
        ExecuteShot(self, startPoint, endPoint, player)
		ExecuteAOEShot(self, player:GetEyePos(), endPoint, player)
        
        if Client then
            TriggerSteamEffect(self, player)
        end
        
        self:LockGun()
        self.lockCharging = true
        
    end
    
end

ReplaceLocals(Railgun.OnTag, { Shoot = Shoot })