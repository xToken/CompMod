
Script.Load( "lua/CompMod/Elixer_Utility.lua" )
Elixer.UseVersion( 1.4 )

for _, v in ipairs( { 'Return', 'GorgeTunnelEntrance', 'GorgeTunnelExit', 'EvolutionChamber', 'MetabolizeEnergy', 'MetabolizeHealth', } ) do
	AppendToEnum( kTechId, v )
end

AppendToEnum( kMinimapBlipType, 'TunnelExit' )