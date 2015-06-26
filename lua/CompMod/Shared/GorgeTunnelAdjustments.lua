// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\GorgeTunnelAdjustments.lua
// - Dragon

function TunnelUserMixin:OnCapsuleTraceHit(entity)

    PROFILE("TunnelUserMixin:OnCapsuleTraceHit")

    if entity and (entity:isa("TunnelEntrance") or entity:isa("TunnelExit")) then
    
        self.enableTunnelEntranceCheck = true
        self.tunnelNearby = true
        
    end
    
end

local function GetNearbyTunnelEntrance(self)

    local tunnelEntrances = GetEntitiesWithinRange("TunnelEntrance", self:GetOrigin(), 1.3)
	local tunnelExits = GetEntitiesWithinRange("TunnelExit", self:GetOrigin(), 1.3)
    if #tunnelEntrances > 0 then
        return tunnelEntrances[1]
    end
	if #tunnelExits > 0 then
        return tunnelExits[1]
    end

end

ReplaceUpValue( TunnelUserMixin.SetOrigin, "GetNearbyTunnelEntrance", GetNearbyTunnelEntrance, { LocateRecurse = true } )
ReplaceUpValue( TunnelUserMixin.SetCoords, "GetNearbyTunnelEntrance", GetNearbyTunnelEntrance, { LocateRecurse = true } )
ReplaceUpValue( TunnelUserMixin.OnProcessMove, "GetNearbyTunnelEntrance", GetNearbyTunnelEntrance, { LocateRecurse = true } )
ReplaceUpValue( TunnelUserMixin.OnUpdate, "GetNearbyTunnelEntrance", GetNearbyTunnelEntrance, { LocateRecurse = true } )