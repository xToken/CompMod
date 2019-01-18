-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Marine\Flamethrower\shared.lua
-- - Dragon

local networkVars =
{
    flamethrower_upg1 = "boolean",
	flamethrower_upg2 = "boolean",
}

local originalFlamethrowerOnInitialized
originalFlamethrowerOnInitialized = Class_ReplaceMethod("Flamethrower", "OnInitialized",
	function(self)
		originalFlamethrowerOnInitialized(self)
		self.flamethrower_upg1 = false
		self.flamethrower_upg2 = false
		self.flameCloud = Entity.invalidId
		if Server then
			self:AddTimedCallback(Flamethrower.OnTechOrResearchUpdated, 0.1)
		end
		
	end
)

function Flamethrower:GetRange()
    return self.flamethrower_upg1 and kFlamethrowerUpgradedRange or kFlamethrowerRange
end

function Flamethrower:GetUpgradeTier()
	if self.flamethrower_upg2 then
		return kTechId.None, 2
	elseif self.flamethrower_upg1 then
		return kTechId.FlamethrowerUpgrade1, 1
	end
    return kTechId.None, 0
end

function Flamethrower:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.FlamethrowerUpgrade1) then
		self.flamethrower_upg1 = true
	else
		self.flamethrower_upg1 = false
	end
end

function Flamethrower:GetMaxClips()
    return 2
end

function Flamethrower:GetIsAffectedByWeaponUpgrades()
    return true
end

function Flamethrower:BurnBileDOT(startPoint, endPoint)

    local toTarget = endPoint - startPoint
    local length = toTarget:GetLength()
    toTarget:Normalize()

    local stepLength = 2
    for i = 1, 5 do
    
        -- stop when target has reached, any spores would be behind
        if length < i * stepLength then
            break
        end

        local checkAtPoint = startPoint + toTarget * i * stepLength
        -- moar dots
        local dots = GetEntitiesWithinRange("DotMarker", checkAtPoint, 4)

        for i = 1, #dots do
            local dot = dots[i]
            dot:TriggerEffects("burn_bomb", { effecthostcoords = Coords.GetTranslation(dot:GetOrigin()) } )
            DestroyEntity(dot)
        end

    end

end

function Flamethrower:BurnParasites(startPoint, endPoint)

    local toTarget = endPoint - startPoint
    local length = toTarget:GetLength()
    toTarget:Normalize()

    local stepLength = 2
    for i = 1, 5 do
    
        if length < i * stepLength then
            break
        end

        local checkAtPoint = startPoint + toTarget * i * stepLength
        -- moar dots
        local paras = GetEntitiesWithMixinWithinRange("ParasiteAble", checkAtPoint, 2)

        for i = 1, #paras do
            local para = paras[i]
            if para:GetIsParasited() then
                para:RemoveParasite()
            end
        end

    end

end

function Flamethrower:ApplyConeDamage(player)

    local eyePos = player:GetEyePos()
    local ents = {}

    local fireDirection = player:GetViewCoords().zAxis
    local extents = Vector(self.kConeWidth, self.kConeWidth, self.kConeWidth)
    local remainingRange = self:GetRange()

    local startPoint = Vector(eyePos)
    local filterEnts = {self, player}
	
	for i = 1, 4 do
    
        if remainingRange <= 0 then
            break
        end
		
		local trace = TraceMeleeBox(self, startPoint, fireDirection, extents, remainingRange, PhysicsMask.Flame, EntityFilterList(filterEnts))

		local endPoint = trace.endPoint
		local normal = trace.normal

		-- Check for spores in the way.
	    if Server then
	        self:BurnSporesAndUmbra(startPoint, endPoint)
	        self:BurnBileDOT(startPoint, endPoint)
            self:BurnParasites(startPoint, endPoint)
	    end

		if trace.fraction ~= 1 then

			local traceEnt = trace.entity
			if traceEnt and HasMixin(traceEnt, "Live") and traceEnt:GetCanTakeDamage() then
				table.insertunique(ents, traceEnt)
                table.insertunique(filterEnts, traceEnt)
			end

		end
		
		remainingRange = remainingRange - (trace.endPoint - startPoint):GetLength() - self.kConeWidth
        startPoint = trace.endPoint + fireDirection * self.kConeWidth + trace.normal * 0.05
			
	end

    local attackDamage = kFlamethrowerDamage
    for i = 1, #ents do

        local ent = ents[i]
        local enemyOrigin = ent:GetModelOrigin()

        if ent ~= player and enemyOrigin then

            local toEnemy = GetNormalizedVector(enemyOrigin - eyePos)

            local health = ent:GetHealth()
            self:DoDamage( attackDamage, ent, enemyOrigin, toEnemy )
						
			-- Only light on fire if we successfully damaged them
			if ent:GetHealth() ~= health and HasMixin(ent, "Fire") and not ent:isa("Player") then
				ent:SetOnFire(player, self)
			end

			if ent.GetEnergy and ent.SetEnergy then
				ent:SetEnergy(ent:GetEnergy() - kFlameThrowerEnergyDamage)
			end
			
        end

    end

    --[[
    if Server then

	    local trace = Shared.TraceRay(
	        player:GetEyePos(), 
	        player:GetEyePos() + player:GetViewCoords().zAxis * FlameCloud.kMaxRange, 
	        CollisionRep.Damage, 
	        PhysicsMask.Bullets, 
	        EntityFilterTwo(player, self)
	    )

	    local flameEnt = Shared.GetEntity(self.flameCloud)
	    if flameEnt then
	    	flameEnt:AddIntermediateDestination(player:GetEyePos(), trace.endPoint)
	    else
	    	flameEnt = CreateEntity( FlameCloud.kMapName, player:GetEyePos(), player:GetTeamNumber() )
		    flameEnt:SetInitialDestination( trace.endPoint )
		    flameEnt:SetOwner(player)
		    self.flameCloud = flameEnt:GetId()
	    end

	end
	--]]
end

--[[
function Flamethrower:OnPrimaryAttack(player)

    if not self:GetIsReloading() then
    
        ClipWeapon.OnPrimaryAttack(self, player)
        
        if self:GetIsDeployed() and self:GetClip() > 0 and self:GetPrimaryAttacking() then
        
            self.createParticleEffects = true
            
            if Server and not self.loopingFireSound:GetIsPlaying() then
                self.loopingFireSound:Start()
            end
            
        end
        
        if self.createParticleEffects and self:GetClip() == 0 then
        
            self.createParticleEffects = false
            
            if Server then
                self.loopingFireSound:Stop()
            end
            
        end
        
    end
    
end

function Flamethrower:OnPrimaryAttackEnd(player)

    ClipWeapon.OnPrimaryAttackEnd(self, player)

    self.createParticleEffects = false
        
    if Server then    
        self.loopingFireSound:Stop()

        local flameEnt = Shared.GetEntity(self.flameCloud)
        if flameEnt then
        	flameEnt:FinishedFiring()
        end
        self.flameCloud = Entity.invalidId

    end
    
end
--]]

Shared.LinkClassToMap("Flamethrower", Flamethrower.kMapName, networkVars)