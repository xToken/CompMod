-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\Flamethrower.lua
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

function Flamethrower:GetIsAffectedByWeaponUpgrades()
    return true
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

		if trace.fraction ~= 1 then

			local traceEnt = trace.entity
			if traceEnt and HasMixin(traceEnt, "Live") and traceEnt:GetCanTakeDamage() then
				table.insertunique(ents, traceEnt)
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

end

Shared.LinkClassToMap("Flamethrower", Flamethrower.kMapName, networkVars)