
for _, v in ipairs( { 'Return', 'GorgeTunnelEntrance', 'GorgeTunnelExit', 'EvolutionChamber', 'MetabolizeEnergy', 'MetabolizeHealth', } ) do
	AppendToEnum( kTechId, v )
end

AppendToEnum( kMinimapBlipType, 'TunnelExit' )