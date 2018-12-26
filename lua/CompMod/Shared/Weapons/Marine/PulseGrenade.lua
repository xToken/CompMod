-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\PulseGrenade.lua
-- - Dragon

PulseGrenade.kDetonateRadius = 0.15

function PulseGrenade:ProcessNearMiss( targetHit, endPoint )

    if targetHit and GetAreEnemies(self, targetHit) then
        if Server then
            self:Detonate( targetHit )
        end
        return true
    end
	
end

if Server then

	function PulseGrenade:OnUpdate(deltaTime)
		
		PredictedProjectile.OnUpdate(self, deltaTime)

	end
	
end