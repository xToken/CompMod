-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\FireMixin.lua
-- - Dragon

function FireMixin:SetOnFire(attacker, doer)

    if Server and not self:GetIsDestroyed() then
    
        if not self:GetCanBeSetOnFire() then
            return
        end
        
        self:SetGameEffectMask(kGameEffect.OnFire, true)
        
        if attacker then
            self.fireAttackerId = attacker:GetId()
        end
        
        if doer then
            self.fireDoerId = doer:GetId()
        end
        
        local time = Shared.GetTime()

        self.timeBurnRefresh = time
        --self.timeLastFireDamageUpdate = time

        self.isOnFire = true
        
        --Flat restriction to single-shot player burn time. ideally will diminish "burn-out" deaths
        if self:isa("Player") then
            self.timeBurnDuration = kFlamethrowerBurnDuration
        else
            self.timeBurnDuration = math.min(self.timeBurnDuration + kFlamethrowerBurnDuration, kFlamethrowerMaxBurnDuration)
        end
        
    end
    
end