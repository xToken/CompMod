// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\SporeAdjustments.lua
// - Dragon

local function CreateSporeCloud(self, origin, player)

    local trace = Shared.TraceRay(player:GetEyePos(), player:GetEyePos() + player:GetViewCoords().zAxis * kSporesMaxCloudRange, CollisionRep.Damage, PhysicsMask.Bullets, EntityFilterTwo(self, player))
    local destination = trace.endPoint + trace.normal * 2
    
    local sporeCloud = CreateEntity(SporeCloud.kMapName, player:GetEyePos() + player:GetViewCoords().zAxis, player:GetTeamNumber())
    sporeCloud:SetOwner(player)
    sporeCloud:SetTravelDestination(destination)

end

function Spores:GetAttackDelay()
    return kSporesDustFireDelay
end

function Spores:OnPrimaryAttack(player)

	if player:GetEnergy() >= self:GetEnergyCost() and (Shared.GetTime() - self.lastPrimaryAttackStartTime) > self:GetAttackDelay() then
    
        self.primaryAttacking = true
        self:PerformPrimaryAttack(player)
        
    else
        self.primaryAttacking = false
    end
	
end

function Spores:PerformPrimaryAttack(player)

	self.lastPrimaryAttackStartTime = Shared.GetTime()

	self:TriggerEffects("spores_fire")
	
	if Server then
	
		local origin = player:GetModelOrigin()
		local sporecloud = CreateSporeCloud(self, origin, player)
		
		player:DeductAbilityEnergy(self:GetEnergyCost())
		
	end
        
end

local kLoopingEffect = PrecacheAsset("cinematics/alien/lerk/spores.cinematic")
local kSporesSound = PrecacheAsset("sound/compmod.fev/compmod/alien/lerk/spore_hit")
local kDamageInterval = GetUpValue( SporeCloud.SporeDamage, "kDamageInterval" )

function SporeCloud:GetRepeatCinematic()
    return SporeCloud.kSporeCloudEffect
end

function SporeCloud:GetThinkTime()
    return kDamageInterval
end

function SporeCloud:SetTravelDestination(position)
    self.destination = position
end

function SporeCloud:OnUpdate(deltaTime)

    if self.destination then
    
        local travelVector = self.destination - self:GetOrigin()
        if travelVector:GetLength() > 0.3 then
            local distanceFraction = (self.destination - self:GetOrigin()):GetLength() / kSporesMaxCloudRange
            self:SetOrigin( self:GetOrigin() + GetNormalizedVector(travelVector) * deltaTime * kSporesTravelSpeed * distanceFraction )
        end
        if travelVector:GetLength() < 3 and not self.soundplayed then
            StartSoundEffectAtOrigin(kSporesSound, self:GetOrigin())
            self.soundplayed = true
        end
    
    end
    
    local time = Shared.GetTime()
    if Server then 
        // we do damage until the spores have died away. 
        if time > self.nextDamageTime and time < self.endOfDamageTime then

            self:SporeDamage(time)
            self.nextDamageTime = time + kDamageInterval
        end
        
        if  time > self.destroyTime then
            DestroyEntity(self)
        end
     elseif Client then

        if self.sporeEffect then        
            self.sporeEffect:SetCoords(self:GetCoords())            
        else
        
            self.sporeEffect = Client.CreateCinematic(RenderScene.Zone_Default) 
            self.sporeEffect:SetCinematic(kLoopingEffect)
            self.sporeEffect:SetRepeatStyle(Cinematic.Repeat_Endless)
            self.sporeEffect:SetCoords(self:GetCoords())
        
        end
    
    end

end 