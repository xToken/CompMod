//Dont want to always replace random files, so this.

local kHealPlayerPercent = GetUpValue( HealSprayMixin.OnTag,   "kHealPlayerPercent", 	{ LocateRecurse = true } )
local kHealScoreAdded = GetUpValue( HealSprayMixin.OnTag,   "kHealScoreAdded", 	{ LocateRecurse = true } )
local kAmountHealedForPoints = GetUpValue( HealSprayMixin.OnTag,   "kAmountHealedForPoints", 	{ LocateRecurse = true } )

local function HealEntity(self, player, targetEntity)

    local onEnemyTeam = (GetEnemyTeamNumber(player:GetTeamNumber()) == targetEntity:GetTeamNumber())
    local isEnemyPlayer = onEnemyTeam and targetEntity:isa("Player")
    local toTarget = (player:GetEyePos() - targetEntity:GetOrigin()):GetUnit()
    
    // Heal players by base amount plus a scaleable amount so it's effective vs. small and large targets.
    local health = kHealsprayDamage + targetEntity:GetMaxHealth() * kHealPlayerPercent / 100.0
	
	if targetEntity.GetBaseHealth then
		//Shared.Message(string.format("Healing reduced to %s from %s", kHealsprayDamage + targetEntity:GetBaseHealth() * kHealPlayerPercent / 100.0, health))
		health = kHealsprayDamage + targetEntity:GetBaseHealth() * kHealPlayerPercent / 100.0
	end
    
    // Heal structures by multiple of damage(so it doesn't take forever to heal hives, ala NS1)
    if GetReceivesStructuralDamage(targetEntity) then
        health = 60
    // Don't heal self at full rate - don't want Gorges to be too powerful. Same as NS1.
    elseif targetEntity == player then
        health = health * 0.5
    end
    
    local amountHealed = targetEntity:AddHealth(health, true, false, true, player)
    
    // Do not count amount self healed.
    if targetEntity ~= player then
        player:AddContinuousScore("HealSpray", amountHealed, kAmountHealedForPoints, kHealScoreAdded)
    end
    
    if targetEntity.OnHealSpray then
        targetEntity:OnHealSpray(player)
    end
    
    // Put out entities on fire sometimes.
    if HasMixin(targetEntity, "GameEffects") and math.random() < kSprayDouseOnFireChance then
        targetEntity:SetGameEffectMask(kGameEffect.OnFire, false)
    end
    
    if Server and amountHealed > 0 then
        targetEntity:TriggerEffects("sprayed")
    end
    
end

ReplaceUpValue( HealSprayMixin.OnTag, "HealEntity", HealEntity, { LocateRecurse = true } )