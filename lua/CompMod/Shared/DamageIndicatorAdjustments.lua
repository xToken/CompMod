// Natural Selection 2 'Tweaks' Mod
// Source located at - https://github.com/xToken/NS2-Tweaks
// lua\CompMod\Shared\MinimapAdjustments.lua
// - Dragon

local kZeroVector = Vector(0, 0, 0)
//Using this just to prevent showing the indicator.  Things which have the indicator set to our OWN origin make little sense, if anything they are just confusing.
//Should be mainly from poison bite, which is pretty clearly indicated to players (sorta).
if Server then

	local oldCombatMixinOnTakeDamage = CombatMixin.OnTakeDamage
    function CombatMixin:OnTakeDamage(damage, attacker, doer, point, direction, damageType, preventAlert)
		oldCombatMixinOnTakeDamage(self, damage, attacker, doer, point, direction, damageType, preventAlert)
        local notifiyTarget = not doer or not doer.GetNotifiyTarget or doer:GetNotifiyTarget(self)
        if attacker and notifiyTarget and (damage > 0 or (attacker:isa("Hallucination") or attacker.isHallucination)) and point then
			//Try moar things here.
			if doer then
				//Special case whip bombs cause NS2
				if doer:isa("WhipBomb") then
					if doer.shooter and doer.shooter:GetOrigin() then
						self.lastTakenDamageOrigin = doer.shooter:GetOrigin()
					else
						//Dont even try for anything else
						self.lastTakenDamageOrigin = kZeroVector
					end
				elseif doer.GetOwner and doer:GetOwner() and doer.UseOwnerForDamageOrigin and doer:UseOwnerForDamageOrigin() then
					self.lastTakenDamageOrigin = doer:GetOwner():GetOrigin()
				elseif doer.GetParent and doer:GetParent() then
					self.lastTakenDamageOrigin = doer:GetParent():GetOrigin()
				elseif doer.GetOrigin then
					self.lastTakenDamageOrigin = doer:GetOrigin()
				else
					self.lastTakenDamageOrigin = kZeroVector
				end
			else
				self.lastTakenDamageOrigin = kZeroVector
			end
        end
    end
	
elseif Client then
	
	local kDamageCameraShakeAmount = 0.10
	local kDamageCameraShakeSpeed = 5
	local kDamageCameraShakeTime = 0.25
  
    function CombatMixin:OnCombatUpdate(deltaTime)
        // Special case for client side player combat effects.
        if self == Client.GetLocalPlayer() then
        
            self.clientLastTakenDamageTime = self.clientLastTakenDamageTime or 0
            if self.lastTakenDamageTime ~= self.clientLastTakenDamageTime then
            
                self.clientLastTakenDamageTime = self.lastTakenDamageTime
                
				if self.lastTakenDamageOrigin ~= kZeroVector then
					self:AddTakeDamageIndicator(self.lastTakenDamageOrigin)
				end
                
                // Shake the camera if this player supports it.
                if self.SetCameraShake ~= nil then
                
                    local amountScalar = self.lastTakenDamageAmount / self:GetMaxHealth()
                    self:SetCameraShake(amountScalar * kDamageCameraShakeAmount, kDamageCameraShakeSpeed, kDamageCameraShakeTime)
                    
                end
                
            end            
            return true
            
        end
        return false
        
    end

end

function Spit:UseOwnerForDamageOrigin()
    return true
end

function Shockwave:UseOwnerForDamageOrigin()
    return true
end

function DotMarker:GetNotifiyTarget()
    return true
end

function Flamethrower:GetNotifiyTarget()
    return true
end