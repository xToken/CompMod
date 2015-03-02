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

local OtherNades = 
{
[kTechId.ClusterGrenade] = { kTechId.GasGrenade, kTechId.PulseGrenade },
[kTechId.GasGrenade] = { kTechId.ClusterGrenade, kTechId.PulseGrenade },
[kTechId.PulseGrenade] = { kTechId.ClusterGrenade, kTechId.GasGrenade }
}

local kGrenades =
{
    kTechId.ClusterGrenade,
    kTechId.GasGrenade,
    kTechId.PulseGrenade
}

function MarineBuy_GetEquipment()
    
    local inventory = {}
    local player = Client.GetLocalPlayer()
    local items = GetChildEntities( player, "ScriptActor" )
    
    for index, item in ipairs(items) do
    
        local techId = item:GetTechId()
        
        if techId ~= kTechId.Pistol and techId ~= kTechId.Axe and techId ~= kTechId.Rifle then
        //can't buy above, so skip
            
            local itemName = GetDisplayNameForTechId(techId)    //simple validity check
            if itemName then
                inventory[techId] = true
            end
			
			if OtherNades[techId] then
				//Block all other nade types
				for i = 1, #OtherNades[techId] do
					inventory[OtherNades[techId][i]] = true
				end
				//Block this type only if you are full.
				if item.GetRemainingGrenades and item:GetRemainingGrenades() < kMaxHandGrenades then
					//Need to manually specify false :/
					inventory[techId] = nil
				end
			end
			
        end

    end
    
    if player:isa("JetpackMarine") then
        inventory[kTechId.Jetpack] = true
    //elseif player:isa("Exo") then
        //Exo's are inheriently handled by how the BuyMenus are organized
    end
    
    return inventory
    
end

function PlayerUI_GetHasItem(techId)

    local hasItem = false
    local isaGrenade = table.contains(kGrenades, techId)

    if techId and techId ~= kTechId.None then
    
        local player = Client.GetLocalPlayer()
        if player then
        
            local items = GetChildEntities(player, "ScriptActor")

            for index, item in ipairs(items) do
			
				if isaGrenade and table.contains(kGrenades, item:GetTechId()) then
					
					if item:GetTechId() == techId and item.GetRemainingGrenades and item:GetRemainingGrenades() < kMaxHandGrenades then
						//Have grenades, but missing some
						break
					end
				
					hasItem = true
                    break
				
				elseif item:GetTechId() == techId then
                
                    hasItem = true
                    break
					
				end

            end
        
        end
    
    end
    
    return hasItem

end