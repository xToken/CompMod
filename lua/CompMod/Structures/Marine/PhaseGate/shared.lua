-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Marine\PhaseGate\shared.lua
-- - Dragon

local TransformPlayerCoordsForPhaseGate = GetUpValue(PhaseGate.Phase, "TransformPlayerCoordsForPhaseGate")

function PhaseGate:Phase(user)

    if HasMixin(user, "PhaseGateUser") and self.linked and ((self.timeOfLastPhase or 0) + kPhaseGateDepartureRate < Shared.GetTime()) then

        local destinationCoords = Angles(0, self.targetYaw, 0):GetCoords()
        destinationCoords.origin = self.destinationEndpoint
        
        user:OnPhaseGateEntry(self.destinationEndpoint) --McG: Obsolete for PGs themselves, but required for Achievements
        
        TransformPlayerCoordsForPhaseGate(user, self:GetCoords(), destinationCoords)
        
        -- Fix view angle for players using inverted mouse
        if Client and Client.GetOptionBoolean(kInvertedMouseOptionsKey, false) then
            local angles = user:GetViewAngles()
            angles.pitch = -angles.pitch
            user:SetViewAngles(angles)
        end

        user:SetOrigin(self.destinationEndpoint)

        --Mark PG to trigger Phase/teleport FX next update loop. This does incure a _slight_ delay in FX but it's worth it
        --to remove the need for the plyaer-centric 2D sound, and simplify effects definitions
        self.performedPhaseLastUpdate = true

        self.timeOfLastPhase = Shared.GetTime()
        
        return true
        
    end
    
    return false

end