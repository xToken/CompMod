-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Alien\Lerk\shared.lua
-- - Dragon

-- Actually set these values since locals
ReplaceLocals(Lerk.GetMaxSpeed, { kMaxSpeed = kLerkMaxSpeed })

local originalLerkOnInitialized
originalLerkOnInitialized = Class_ReplaceMethod("Lerk", "OnInitialized",
    function(self)
        originalLerkOnInitialized(self)
        self:AddTimedCallback(Lerk.UpdateRoostHealing, 1)
    end
)

function Lerk:UpdateRoostHealing()
    if self:GetIsWallGripping() then
        if GetHasTech(self, kTechId.HealingRoost, true) then
            local totalHealed = self:AddHealth(kHealingRoostHealthRegain, false, false)
            if Client and totalHealed > 0 then
                local GUIRegenerationFeedback = ClientUI.GetScript("GUIRegenerationFeedback")
                GUIRegenerationFeedback:TriggerRegenEffect()
                local cinematic = Client.CreateCinematic(RenderScene.Zone_ViewModel)
                cinematic:SetCinematic(kRegenerationViewCinematic)
            end
        end
    end
    return self:GetIsAlive()
end

function Lerk:GetHasMovementSpecial()
    return GetHasTech(self, kTechId.HealingRoost, true)
end

function Lerk:GetAdrenalineRecuperationRate()
	return kLerkAdrenalineRecuperationScalar
end

local kMaxGlideRoll = math.rad(10)
function Lerk:GetDesiredAngles()

    if self:GetIsWallGripping() then
        return self:GetAnglesFromWallNormal( self.wallGripNormalGoal )
    end

    local desiredAngles = Alien.GetDesiredAngles(self)

    if not self:GetIsOnGround() and not self:GetIsWallGripping() then
        -- There seems to be an issue where sometimes the pitch scales from 1.5pi to 2pi when looking up
        -- Normally angles always seem to be +/- 1/2pi as expected...
        -- If our view pitch is greater than pi, just ignore any clamping here.  We are only looking to keep the lerk model from pitching downwards too much
        --Print(ToString(Server and "Server: " or (Client and "Client: " or "Predict: ")).."viewPitch: "..ToString(self.viewPitch))
    	if self.viewPitch < math.pi then
        	desiredAngles.pitch = math.min(self.viewPitch, 0.4)
        else
        	desiredAngles.pitch = self.viewPitch
        end
        local diff = RadianDiff( self:GetAngles().yaw, self.viewYaw )
        if math.abs(diff) < 0.001 then
            diff = 0
        end
        desiredAngles.roll = Clamp(diff, -kMaxGlideRoll, kMaxGlideRoll)
    end
    
    return desiredAngles

end