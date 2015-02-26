//Dont want to always replace random files, so this.
Script.Load("lua/Hud/GUIEvent.lua")

local function SetupActionIcons()
	local kIconOffsets = GetUpValue( GUIActionIcon.ShowIcon,   "kIconOffsets")
	kIconOffsets["GasGrenadeThrower"] = 4
	kIconOffsets["ClusterGrenadeThrower"] = 4
	kIconOffsets["PulseGrenadeThrower"] = 4
end

AddPostInitOverride("GUIActionIcon", SetupActionIcons)

local function SetupPickupOffset()
	local kPickupTextureYOffsets = GetUpValue( GUIPickups.Update,   "kPickupTextureYOffsets", 			{ LocateRecurse = true } )
	kPickupTextureYOffsets["GasGrenadeThrower"] = 6
	kPickupTextureYOffsets["ClusterGrenadeThrower"] = 6
	kPickupTextureYOffsets["PulseGrenadeThrower"] = 6
end

AddPostInitOverride("GUIPickups", SetupPickupOffset)