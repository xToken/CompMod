-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Alien\Blink\shared.lua
-- - Dragon
local TriggerBlinkOutEffects = GetUpValue(Blink.SetEthereal, "TriggerBlinkOutEffects")
local TriggerBlinkInEffects = GetUpValue(Blink.SetEthereal, "TriggerBlinkInEffects")
local kBlinkAddForce = GetUpValue(Blink.SetEthereal, "kBlinkAddForce")
local kEtherealForce = GetUpValue(Blink.SetEthereal, "kEtherealForce")

local originalBlinkSetEthereal
originalBlinkSetEthereal = Class_ReplaceMethod("Blink", "SetEthereal",
	function(self, player, state)

	    -- Enter or leave ethereal mode.
	    if player.ethereal ~= state then

	        if state then

	            player.etherealStartTime = Shared.GetTime()
	            TriggerBlinkOutEffects(self, player)

	            local celerityLevel = GetHasCelerityUpgrade(player) and player:GetSpurLevel() or 0
	            local oldSpeed = player:GetVelocity():GetLengthXZ()
	            local viewPitch = player:GetViewCoords()
	            local oldVelocity = player:GetVelocity()
	            oldVelocity.y = 0
	            local newSpeed = math.max(oldSpeed, kEtherealForce + celerityLevel * 0.5)

	            -- need to handle celerity different for the fade. blink is a big part of the basic movement, celerity wont be significant enough if not considered here
	            local celerityMultiplier = 1 + celerityLevel * 0.10

	            local newVelocity = player:GetViewCoords().zAxis * (kEtherealForce + celerityLevel * 0.5) + oldVelocity
	            if newVelocity:GetLength() > newSpeed then
	                newVelocity:Scale(newSpeed / newVelocity:GetLength())
	            end

	            local downTrace = Shared.TraceRay(player:GetOrigin(), player:GetOrigin() - Vector(0, 0.4, 0), CollisionRep.Move, PhysicsMask.AllButPCs, EntityFilterOneAndIsa(self, "Babbler"))
	            if downTrace.fraction < 1 then
	            	local upPitch = player.viewPitch < 0 and math.min(1 + math.abs(player.viewPitch), 2) or 1
	                newVelocity.y = math.max(newVelocity.y, 4 * upPitch)
	            end
	            
	            newVelocity:Add(player:GetViewCoords().zAxis * kBlinkAddForce * celerityMultiplier)
	            
	            player:SetVelocity(newVelocity)
	            player.onGround = false
	            player.jumping = true
	            
	        else
	        
	            TriggerBlinkInEffects(self, player)
	            player.etherealEndTime = Shared.GetTime()
	            
	        end
	        
	        player.ethereal = state        

	        -- Give player initial velocity in direction we're pressing, or forward if not pressing anything.
	        if player.ethereal then
	        
	            -- Deduct blink start energy amount.
	            player:DeductAbilityEnergy(kStartBlinkEnergyCost)
	            player:TriggerBlink()
	            
	        -- A case where OnBlinkEnd() does not exist is when a Fade becomes Commanders and
	        -- then a new ability becomes available through research which calls AddWeapon()
	        -- which calls OnHolster() which calls this function. The Commander doesn't have
	        -- a OnBlinkEnd() function but the new ability is still added to the Commander for
	        -- when they log out and become a Fade again.
	        elseif player.OnBlinkEnd then
	            player:OnBlinkEnd()
	        end
	        
	    end
	    
	end
)