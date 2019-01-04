-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Alien\LerkBite\shared.lua
-- - Dragon

function LerkBite:OnTag(tagName)

    PROFILE("LerkBite:OnTag")

    if tagName == "hit" then
    
        local player = self:GetParent()
        
        if player then
        
            self:TriggerEffects("lerkbite_attack")
            self:OnAttack(player)
            
            self.spiked = false
        
            local didHit, target, endPoint, surface = AttackMeleeCapsule(self, player, kLerkBiteDamage, self:GetRange(), nil, false, EntityFilterOneAndIsa(player, "Babbler"))
            
            if didHit and target then
            
                if Client then
                    self:TriggerFirstPersonHitEffects(player, target)
                end
            
            end
            
            if target and HasMixin(target, "Live") and not target:GetIsAlive() then
                self:TriggerEffects("bite_kill")
            end
            
        end
        
    end
    
end