//Changes to fix stomping through walls.

function Shockwave:Detonate()

    local origin = self:GetOrigin()

    local groundTrace = Shared.TraceRay(origin, origin - Vector.yAxis * 3, CollisionRep.Move, PhysicsMask.Movement, EntityFilterAllButIsa("Tunnel"))
    local enemies = GetEntitiesWithMixinWithinRange("Live", groundTrace.endPoint, 2.2)
    
    // never damage the owner
    local owner = self:GetOwner()
	local onosViewPos
    if owner then
		onosViewPos = owner:GetEyePos()
        table.removevalue(enemies, owner)
    end
    
    if groundTrace.fraction < 1 then
    
        for _, enemy in ipairs(enemies) do
        
			local enemyId = enemy:GetId()
			local ShouldStun = enemy:GetIsAlive() and not table.contains(self.damagedEntIds, enemyId)	//Sanity checks
			ShouldStun = ShouldStun and math.abs(enemy:GetOrigin().y - groundTrace.endPoint.y) < 0.8	//Ground checks
			if onosViewPos then
				ShouldStun = ShouldStun and not GetWallBetween(onosViewPos, enemy:GetOrigin(), enemy)	//LOS checks
			end
            if ShouldStun then
                
                self:DoDamage(kStompDamage, enemy, enemy:GetOrigin(), GetNormalizedVector(enemy:GetOrigin() - groundTrace.endPoint), "none")
                table.insert(self.damagedEntIds, enemyId)
                
                if not HasMixin(enemy, "GroundMove") or enemy:GetIsOnGround() then
                    self:TriggerEffects("shockwave_hit", { effecthostcoords = enemy:GetCoords() })
                end

                if HasMixin(enemy, "Stun") then
                    enemy:SetStun(kDisruptMarineTime)
                end  
                
            end
        
        end
    
    end
    
    return true

end