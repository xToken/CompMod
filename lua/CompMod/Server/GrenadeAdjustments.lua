// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Server\GrenadeAdjustments.lua
// - Dragon

function PulseGrenade:OnUpdate(deltaTime)
    
	PredictedProjectile.OnUpdate(self, deltaTime)

	for _, enemy in ipairs( GetEntitiesForTeamWithinRange("Alien", GetEnemyTeamNumber(self:GetTeamNumber()), self:GetOrigin(), kPulseGrenadeAutoDetonateRange) ) do
	
		if enemy:GetIsAlive() then
			self:Detonate()
			break
		end
	
	end

end

local function IgniteNearbyPlayers(self, range)
	local hitEntities = GetEntitiesWithMixinWithinRange("Fire", self:GetOrigin(), range)
	local player = self:GetOwner()
    table.removevalue(hitEntities, self)
	if player then
		for _, hitEnt in ipairs(hitEntities) do
			hitEnt:SetOnFire(player, self)
		end
	end
end

local oldClusterGrenadeDetonate = ClusterGrenade.Detonate
function ClusterGrenade:Detonate(targetHit)
	IgniteNearbyPlayers(self, kClusterGrenadeDamageRadius)
	oldClusterGrenadeDetonate(self, targetHit)
end


local GrenadeThrowers = { ClusterGrenadeThrower.kMapName, GasGrenadeThrower.kMapName, PulseGrenadeThrower.kMapName }

local oldMarineGiveItem
oldMarineGiveItem = Class_ReplaceMethod("Marine", "GiveItem",
	function(self, itemMapName)
		
		if itemMapName then
			if table.contains(GrenadeThrowers, itemMapName) then
				local grenadeWeapon = self:GetWeapon(itemMapName)
				if grenadeWeapon then
					grenadeWeapon:AddGrenades(kPurchasedHandGrenades)
					self:AddResources(0 - GetCostForTech(grenadeWeapon:GetTechId()))
					return
				end
			end
		end
		return oldMarineGiveItem(self, itemMapName)
    end
)