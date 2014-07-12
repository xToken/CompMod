//Dont want to always replace random files, so this.

local oldWeldableMixinOnWeld = WeldableMixin.OnWeld
function WeldableMixin:OnWeld(doer, elapsedTime, player)
    if self:GetCanBeWelded(doer) then
		local welded = true
        if self.OnWeldOverride then
            self:OnWeldOverride(doer, elapsedTime)
        elseif doer:isa("ExoWelder") then
            self:AddHealth(doer:GetRepairRate(self) * elapsedTime)
        else
			oldWeldableMixinOnWeld(self, doer, elapsedTime, player)
			welded = false
        end
        
		if welded and player and player.OnWeldTarget then
            player:OnWeldTarget(self)
        end
     
	end
end

local oldSentryOnWeldOverride = Sentry.OnWeldOverride
function Sentry:OnWeldOverride(entity, elapsedTime)

	if entity:isa("ExoWelder") then
        local amount = kWelderSentryRepairRate * elapsedTime     
        self:AddHealth(amount)
	else
		oldSentryOnWeldOverride(self, entity, elapsedTime)
	end
	
end