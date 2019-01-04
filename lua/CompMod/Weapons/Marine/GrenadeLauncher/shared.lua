-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Marine\GrenadeLauncher\shared.lua
-- - Dragon

local networkVars =
{
    gl_upg1 = "boolean",
	gl_upg2 = "boolean",
}

local originalGrenadeLauncherOnInitialized
originalGrenadeLauncherOnInitialized = Class_ReplaceMethod("GrenadeLauncher", "OnInitialized",
	function(self)
		originalGrenadeLauncherOnInitialized(self)
		self.gl_upg1 = false
		self.gl_upg2 = false
		
		if Server then
			self:AddTimedCallback(GrenadeLauncher.OnTechOrResearchUpdated, 0.1)
		end
		
	end
)

local function ShootGrenade(self, player)

    PROFILE("ShootGrenade")
    
    self:TriggerEffects("grenadelauncher_attack")

    if Server or (Client and Client.GetIsControllingPlayer()) then

        local viewCoords = player:GetViewCoords()
        local eyePos = player:GetEyePos()

        local startPointTrace = Shared.TraceCapsule(eyePos, eyePos + viewCoords.zAxis, 0.2, 0, CollisionRep.Move, PhysicsMask.PredictedProjectileGroup, EntityFilterTwo(self, player))
        local startPoint = startPointTrace.endPoint

        local direction = viewCoords.zAxis
        
        if startPointTrace.fraction ~= 1 then
            direction = GetNormalizedVector(direction:GetProjection(startPointTrace.normal))
        end

        local grenade = player:CreatePredictedProjectile("Grenade", startPoint, direction * kGrenadeLauncherSpeed, 0.7, 0.45)
		if grenade then
			local level = self.gl_upg1 and 1 or 0
			if self.gl_upg2 then
				level = 2
			end
			grenade:SetIsUpgraded(level)
		end
    end

end

function GrenadeLauncher:FirePrimary(player)
    ShootGrenade(self, player)    
end

function GrenadeLauncher:GetIsAffectedByWeaponUpgrades()
    return true
end

function GrenadeLauncher:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.GLUpgrade1) then
		self.gl_upg1 = true
	else
		self.gl_upg1 = false
	end
end

function GrenadeLauncher:GetUpgradeTier()
	if self.gl_upg2 then
		return kTechId.None, 2
	elseif self.gl_upg1 then
		return kTechId.GLUpgrade1, 1
	end
    return kTechId.None, 0
end

Shared.LinkClassToMap("GrenadeLauncher", GrenadeLauncher.kMapName, networkVars)