//Dont want to always replace random files, so this.

local function SetupGUIMinimap()
	local kBlipInfo 		= GetUpValue( GUIMinimap.Initialize,   "kBlipInfo", 			{ LocateRecurse = true } )
	local kBlipColorType 	= GetUpValue( GUIMinimap.Initialize,   "kBlipColorType", 		{ LocateRecurse = true } )
	local kBlipSizeType 	= GetUpValue( GUIMinimap.Initialize,   "kBlipSizeType", 		{ LocateRecurse = true } )
	local kStaticBlipsLayer = GetUpValue( GUIMinimap.Initialize,   "kStaticBlipsLayer", 	{ LocateRecurse = true } )
	kBlipInfo[kMinimapBlipType.TunnelEntrance] = { kBlipColorType.MAC, kBlipSizeType.Normal, kStaticBlipsLayer }
end

AddPreInitOverride("GUIMinimapFrame", SetupGUIMinimap)