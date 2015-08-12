// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Client\MinimapAdjustments.lua
// - Dragon

local function SetupGUIMinimap()
	local kBlipInfo 		= GetUpValue( GUIMinimap.Initialize,   "kBlipInfo", 			{ LocateRecurse = true } )
	local kBlipColorType 	= GetUpValue( GUIMinimap.Initialize,   "kBlipColorType", 		{ LocateRecurse = true } )
	local kBlipSizeType 	= GetUpValue( GUIMinimap.Initialize,   "kBlipSizeType", 		{ LocateRecurse = true } )
	local kStaticBlipsLayer = GetUpValue( GUIMinimap.Initialize,   "kStaticBlipsLayer", 	{ LocateRecurse = true } )
	if kBlipInfo then
		kBlipInfo[kMinimapBlipType.TunnelEntrance] = { kBlipColorType.MAC, kBlipSizeType.Normal, kStaticBlipsLayer }
	else
		Shared.Message("CompMod failed to register TunnelEntrance Minimap Icon.")
	end
end

AddPreInitOverride("GUIMinimapFrame", SetupGUIMinimap)