-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\Welder.lua
-- - Dragon

kWelderHUDSlot = 4

function Welder:GetMeleeBase()
	if self.friendlies then
		return 2, 2
	end
	return Weapon.kMeleeBaseWidth, Weapon.kMeleeBaseHeight
end

local function PrioritizeDamagedFriends(weapon, player, newTarget, oldTarget)
    local orig = player:GetOrigin()
    local eyePos = player:GetEyePos()
    local vCoords = player:GetViewCoords()
    local sameTeam = HasMixin(newTarget, "Team") and newTarget:GetTeamNumber() == player:GetTeamNumber()
    local isWeldable = HasMixin(newTarget, "Weldable") and newTarget:GetCanBeWelded(weapon)

    if not oldTarget then
        return true
    end

    if (sameTeam and isWeldable) or (HasMixin(newTarget, "Live") and newTarget:GetIsAlive() and GetAreEnemies(player, newTarget)) then
        -- Don't bother about the distance, the welder has a short enough range aready for us to bother
        -- taking it into account here (~2.5m)
        local oldAngle = 1 - vCoords.zAxis:DotProduct(GetNormalizedVector(oldTarget:GetOrigin() - eyePos))
        local newAngle = 1 - vCoords.zAxis:DotProduct(GetNormalizedVector(newTarget:GetOrigin() - eyePos))

        -- Trying to check with the model origin if provided, useful for big high units
        -- (no need to do a real traceray with both the origin and modelOrigin check, it's good enough)
        if oldTarget.GetModelOrigin then
            local oldAngleModelOrig = 1-vCoords.zAxis:DotProduct(GetNormalizedVector(oldTarget:GetModelOrigin() - eyePos))
            oldAngle = oldAngleModelOrig < oldAngle and oldAngleModelOrig or oldAngle
        end

        if newTarget.GetModelOrigin then
            local newAngleModelOrig = 1-vCoords.zAxis:DotProduct(GetNormalizedVector(newTarget:GetModelOrigin() - eyePos))
            newAngle = newAngleModelOrig < newAngle and newAngleModelOrig or newAngle
        end

        -- Log("Shoot cone for (old target: %s(%s)) %s(%s)", oldTarget, oldAngle, newTarget, newAngle)
        if newAngle < oldAngle then
            -- Log("NEW: %s closer than %s", newTarget, oldTarget)
            return true
        end
    end

    return false
end

local function CheckForTeammatesToWeld(self, player, attackDirection)
	-- This kinda sucks, but its the easiest way.
	local success
	
	self.friendlies = true
	
	local didHit, target, endPoint, direction, surface = CheckMeleeCapsule(self, player, 0, kWelderFriendlyRange, nil, true, 1, PrioritizeDamagedFriends, nil, PhysicsMask.Flame)
	
    if didHit and target and HasMixin(target, "Live") then
		if player:GetTeamNumber() == target:GetTeamNumber() and HasMixin(target, "Weldable") then
			if target:GetHealthScalar() < 1 then
                
                local prevHealthScalar = target:GetHealthScalar()
                local prevHealth = target:GetHealth()
                local prevArmor = target:GetArmor()
                target:OnWeld(self, kWelderFireDelay, player)
                success = prevHealthScalar ~= target:GetHealthScalar()
                
                if success then
                
                    local addAmount = (target:GetHealth() - prevHealth) + (target:GetArmor() - prevArmor)
                    player:AddContinuousScore("WeldHealth", addAmount, Welder.kAmountHealedForPoints, Welder.kHealScoreAdded)
                    
                    -- weld owner as well
                    player:SetArmor(player:GetArmor() + kWelderFireDelay * kSelfWeldAmount)
                    
                end
                
            end
            
            if HasMixin(target, "Construct") and target:GetCanConstruct(player) then
                target:Construct(kWelderFireDelay, player)
				success = true
            end
		end
	end
	
	self.friendlies = false
	
	return success, endPoint
end

local function CheckForEnemiesToDamage(self, player, attackDirection)
	local success
	
	local didHit, target, endPoint, direction, surface = CheckMeleeCapsule(self, player, 0, kWelderAttackRange, nil, true, 1, nil, nil, PhysicsMask.Flame)
	if didHit and target and HasMixin(target, "Live") then
        if GetAreEnemies(player, target) then
		
			if target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage() then
				self:DoDamage(kWelderStructureDamagePerSecond * kWelderFireDelay, target, endPoint, attackDirection)
			else
				self:DoDamage(kWelderDamagePerSecond * kWelderFireDelay, target, endPoint, attackDirection)
			end
			
            success = true
		end
	end
	
	return success, endPoint
end

function Welder:PerformWeld(player)
    local attackDirection = player:GetViewCoords().zAxis
    local success = false
	local endPoint
	success, endPoint = CheckForTeammatesToWeld(self, player, attackDirection)
	if not success then
		success, endPoint = CheckForEnemiesToDamage(self, player, attackDirection)
	end
    return endPoint
	
end

function Weapon:GetWeight()
    return kWelderWeight
end

Welder.GetReplacementWeaponMapName = nil