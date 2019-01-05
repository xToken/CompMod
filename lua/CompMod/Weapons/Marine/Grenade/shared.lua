-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Marine\Grenade\shared.lua
-- - Dragon

Grenade.kRadius = 0.05
Grenade.kDetonateRadius = 0.10
Grenade.kMinLifeTime = 0.0

-- Load GL Fragment file

local kGrenadeFragmentPoints =
{
    Vector(0.1, 0.12, 0.1),
    Vector(-0.1, 0.12, -0.1),
    Vector(0.1, 0.12, -0.1),
    Vector(-0.1, 0.12, 0.1),

}

-- Grenade changes (the actual grenade itself (not the launcher).
function Grenade:GetIsAffectedByWeaponUpgrades()
    return true
end

function Grenade:SetIsUpgraded(level)
	if level >= 1 then
		self.gl_upg1 = true
	end
	if level >= 2 then
		self.gl_upg2 = true
	end
end

if Server then

	local function CreateFragments(self)

		local origin = self:GetOrigin()
		local player = self:GetOwner()
			
		for i = 1, #kGrenadeFragmentPoints do
		
			local creationPoint = origin + kGrenadeFragmentPoints[i]
			local fragment = CreateEntity(GrenadeFragment.kMapName, creationPoint, self:GetTeamNumber())
			
			local startVelocity = GetNormalizedVector(creationPoint - origin) * (3 + math.random() * 6) + Vector(0, 4 * math.random(), 0)
			fragment:Setup(player, startVelocity, true, nil, self)
		
		end

	end

	local originalGrenadeDetonate
	originalGrenadeDetonate = Class_ReplaceMethod("Grenade", "Detonate",
		function(self, targetHit)
			if self.gl_upg1 then
				CreateFragments(self)
			end
			originalGrenadeDetonate(self, targetHit)
		end
	)

end