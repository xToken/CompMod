// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Server\TunnelAdjustments.lua
// - Dragon

local function AddExitToTunnel(tunnelexit, tunnel)
	tunnel:AddExit(tunnelexit)
	tunnelexit.tunnelId = tunnel:GetId()
	tunnel:SetOwnerClientId(tunnelexit:GetOwnerClientId())
end

//Tunnels nil their clientId when both exits are destroyed.  This can lead to a valid tunnel existing for our client
//but finding a nil clientId tunnel here because it is first in the entlist returned.
function TunnelEntrance:UpdateConnectedTunnel()

	local hasValidTunnel = self.tunnelId ~= nil and Shared.GetEntity(self.tunnelId) ~= nil

	if hasValidTunnel or self:GetOwnerClientId() == nil or not self:GetIsBuilt() then
		return
	end

	// register if a tunnel entity already exists or a free tunnel has been found
	local foundTunnel
	for index, tunnel in ientitylist( Shared.GetEntitiesWithClassname("Tunnel") ) do
	
		if tunnel:GetOwnerClientId() == self:GetOwnerClientId() then
			//If we find our tunnel, set it now and exit
			AddExitToTunnel(self, tunnel)
			return
			
		elseif tunnel:GetOwnerClientId() == nil then
			foundTunnel = tunnel
		end
		
	end
	
	//We found an un-used tunnel, use that instead of creating a new one.
	if foundTunnel then
		AddExitToTunnel(self, foundTunnel)
		return
	end
	
	// no tunnel entity present, check if there is another tunnel entrance to connect with
	local tunnel = CreateEntity(Tunnel.kMapName, nil, self:GetTeamNumber())
	tunnel:SetOwnerClientId(self:GetOwnerClientId()) 
	tunnel:AddExit(self)
	self.tunnelId = tunnel:GetId()

end