// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\RailgunAdjustments.lua
// - Dragon

local function ExecuteShot(self, startPoint, endPoint, player)

    // Filter ourself out of the trace so that we don't hit ourselves.
    local filter = EntityFilterTwo(player, self)
    local trace = Shared.TraceRay(startPoint, endPoint, CollisionRep.Damage, PhysicsMask.Bullets, EntityFilterAllButIsa("Tunnel"))
    local hitPointOffset = trace.normal * 0.3
    local direction = (endPoint - startPoint):GetUnit()
    local damage = kRailgunDamage + math.min(1, (Shared.GetTime() - self.timeChargeStarted) / kChargeTime) * kRailgunChargeDamage
    
    local extents = GetDirectedExtentsForDiameter(direction, kBulletSize)
    
    if trace.fraction < 1 then
    
        // do a max of 10 capsule traces, should be sufficient
        local hitEntities = {}
        for i = 1, 20 do
        
            local capsuleTrace = Shared.TraceBox(extents, startPoint, trace.endPoint, CollisionRep.Damage, PhysicsMask.Bullets, filter)
            if capsuleTrace.entity then
            
                if not table.find(hitEntities, capsuleTrace.entity) then
                
                    table.insert(hitEntities, capsuleTrace.entity)
                    self:DoDamage(damage, capsuleTrace.entity, capsuleTrace.endPoint + hitPointOffset, direction, capsuleTrace.surface, false, false)
					
					if kRailgunSplashesStructures and #hitEntities == 1 then
						//Only splash on first thing hit
						
					end
                
                end
                
            end    
                
            if (capsuleTrace.endPoint - trace.endPoint):GetLength() <= extents.x then
                break
            end
            
            // use new start point
            startPoint = Vector(capsuleTrace.endPoint) + direction * extents.x * 3
        
        end
        
        // for tracer
        local effectFrequency = self:GetTracerEffectFrequency()
        local showTracer = ConditionalValue(GetIsVortexed(player), false, math.random() < effectFrequency)
        self:DoDamage(0, nil, trace.endPoint + hitPointOffset, direction, trace.surface, false, showTracer)
        
        if Client and showTracer then
            TriggerFirstPersonTracer(self, trace.endPoint)
        end
    
    end
    
end