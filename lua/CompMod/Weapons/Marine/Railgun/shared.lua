-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Marine\Railgun\shared.lua
-- - Dragon

local kMinRailgunRateOfFire = 0.6

Railgun.kSpreadVectors =
{    
    GetNormalizedVector(Vector(-0.45, 0.45, 14)),
    GetNormalizedVector(Vector(0.45, 0.45, 14)),
    GetNormalizedVector(Vector(0.45, -0.45, 14)),
    GetNormalizedVector(Vector(-0.45, -0.45, 14))
}

local networkVars =
{
    railgun_upg1 = "boolean",
	railgun_upg2 = "boolean",
    ammo = "integer (0 to " .. kRailgunMaxAmmo .. ")",
    nextAmmoTime = "float (0 to " .. kRailgunRegenAmmoRate .. " by 0.01)"
}

local originalRailgunOnInitialized
originalRailgunOnInitialized = Class_ReplaceMethod("Railgun", "OnInitialized",
	function(self)
		originalRailgunOnInitialized(self)
		self.railgun_upg1 = false
		self.railgun_upg2 = false
		self.ammo = kRailgunMaxAmmo
        self.nextAmmoTime = kRailgunRegenAmmoRate
		if Server then
			self:AddTimedCallback(Railgun.OnTechOrResearchUpdated, 0.1)
		end
		
	end
)

function Railgun:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.RailgunUpgrade1) then
		self.railgun_upg1 = true
	else
		self.railgun_upg1 = false
	end
end

function Railgun:GetUpgradeTier()
	if self.railgun_upg2 then
		return kTechId.None, 2
	elseif self.railgun_upg1 then
		return kTechId.RailgunUpgrade1, 1
	end
    return kTechId.None, 0
end

function Railgun:OnPrimaryAttack(player)
    if self:GetCanShoot() and self.ammo > 0 then
        self.railgunAttacking = true
    end
    if self.ammo == 0 and self.railgunAttacking then
        self:OnPrimaryAttackEnd(player)
    end
end

function Railgun:GetBulletsPerShot()
    return kRailgunBulletsPerShot
end

function Railgun:GetRange()
    return 100
end

function Railgun:GetCanShoot()
    return self.timeOfLastShot + kMinRailgunRateOfFire < Shared.GetTime()
end

function Railgun:GetBulletDamage(player, endPoint)
    local distanceTo = (player:GetEyePos() - endPoint):GetLength()
    if distanceTo > kRailgunMaxRange then
        return 1
    elseif distanceTo <= kRailgunDropOffStartRange then
        return kRailgunDamage
    else
        return kRailgunDamage * (1 - (distanceTo - kRailgunDropOffStartRange) / (kRailgunMaxRange - kRailgunDropOffStartRange))
    end
end

function Railgun:GetAmmoCount()
    return self.ammo
end

function Railgun:ProcessMoveOnWeapon(player, input)
    if self.nextAmmoTime == 0 and self.ammo < kRailgunMaxAmmo then
        self.ammo = math.min(self.ammo + 1, kRailgunMaxAmmo)
        self.nextAmmoTime = kRailgunRegenAmmoRate
    end
    if self.ammo < kRailgunMaxAmmo then self.nextAmmoTime = math.max(self.nextAmmoTime - input.time, 0) end
end

function Railgun:GetIsThrusterAllowed()
    return true
end

function Railgun:GetChargeAmount()
    return 0
end

local originalRailgunOnUpdateRender
originalRailgunOnUpdateRender = Class_ReplaceMethod("Railgun", "OnUpdateRender",
    function(self)
        originalRailgunOnUpdateRender(self)

        if self.chargeDisplayUI and not self.betterChargeDisplayUI then
            -- lol...
            Client.DestroyGUIView(self.chargeDisplayUI)
            self.chargeDisplayUI = Client.CreateGUIView(246, 256)
            self.chargeDisplayUI:Load("lua/CompMod/GUI/GUI" .. self:GetExoWeaponSlotName():gsub("^%l", string.upper) .. "RailgunAmmoDisplay/view.lua")
            self.chargeDisplayUI:SetTargetTexture("*exo_railgun_" .. self:GetExoWeaponSlotName())
            self.betterChargeDisplayUI = true
            
        end
    
        local ammoAmmount = self:GetAmmoCount()
        local parent = self:GetParent()
        if parent and parent:GetIsLocalPlayer() and not Shared.GetIsRunningPrediction() then

            self.chargeDisplayUI:SetGlobal("ammoCount" .. self:GetExoWeaponSlotName(), ammoAmmount)
            self.chargeDisplayUI:SetGlobal("ammoTime" .. self:GetExoWeaponSlotName(), 1 - Clamp(self.nextAmmoTime / kRailgunRegenAmmoRate, 0, 1))

        end

    end
)

local function TriggerSteamEffect(self, player)

    if self:GetIsLeftSlot() then
        --player:TriggerEffects("railgun_steam_left")
    elseif self:GetIsRightSlot() then
        --player:TriggerEffects("railgun_steam_right")
    end
    
end

local function ExecuteShot(self, startPoint, player)

    local viewAngles = player:GetViewAngles()
    viewAngles.roll = NetworkRandom() * math.pi * 2

    local shootCoords = viewAngles:GetCoords()

    -- Filter ourself out of the trace so that we don't hit ourselves.
    local filter = EntityFilterTwo(player, self)
    local range = self:GetRange()
    
    local numberBullets = self:GetBulletsPerShot()

    for bullet = 1, math.min(numberBullets, #self.kSpreadVectors) do
    
        if not self.kSpreadVectors[bullet] then
            break
        end    
    
        local spreadDirection = shootCoords:TransformVector(self.kSpreadVectors[bullet])

        local endPoint = startPoint + spreadDirection * range
        --startPoint = player:GetEyePos() + shootCoords.xAxis * self.kSpreadVectors[bullet].x * self.kStartOffset + shootCoords.yAxis * self.kSpreadVectors[bullet].y * self.kStartOffset
        
        local targets, trace, hitPoints = GetBulletTargets(startPoint, endPoint, spreadDirection, kRailgunBulletSize, filter)
        
        HandleHitregAnalysis(player, startPoint, endPoint, trace)        
            
        local direction = (trace.endPoint - startPoint):GetUnit()
        local hitOffset = trace.normal * 0.3
        local impactPoint = trace.endPoint - hitOffset
        local effectFrequency = self:GetTracerEffectFrequency()
        local showTracer = bullet % effectFrequency == 0
        
        local numTargets = #targets
        
        if numTargets == 0 then
            self:ApplyBulletGameplayEffects(player, nil, impactPoint, direction, 0, trace.surface, showTracer)
        end
        
        if Client and showTracer then
            TriggerFirstPersonTracer(self, impactPoint)
        end

        for i = 1, numTargets do

            local target = targets[i]
            local hitPoint = hitPoints[i]
			local damage = self:GetBulletDamage(player, hitPoint)
			
            self:ApplyBulletGameplayEffects(player, target, hitPoint, direction, damage, "", showTracer and i == numTargets)
            
            local client = Server and player:GetClient() or Client
            if not Shared.GetIsRunningPrediction() and client.hitRegEnabled then
                RegisterHitEvent(player, bullet, startPoint, trace, damage)
            end
        
        end
        
    end
    
end

local function Shoot(self, leftSide)

    local player = self:GetParent()

    if player and self.ammo > 0 then
    
        player:TriggerEffects("railgun_attack")
        
        local viewAngles = player:GetViewAngles()
        local shootCoords = viewAngles:GetCoords()
        
        local startPoint = player:GetEyePos()

        ExecuteShot(self, startPoint, player)
        
        if Client then
            TriggerSteamEffect(self, player)
        end

        self.ammo = self.ammo - 1
        
        self.timeOfLastShot = Shared.GetTime()
    end
    
end

ReplaceUpValue(Railgun.OnTag, "Shoot", Shoot)

Shared.LinkClassToMap("Railgun", Railgun.kMapName, networkVars)