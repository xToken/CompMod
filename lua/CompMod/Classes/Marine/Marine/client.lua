-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Marine\Marine\client.lua
-- - Dragon

function PlayerUI_GetWeaponUpgradeTier()

	local player = Client.GetLocalPlayer()
    if player then

        local weapon = player:GetActiveWeapon()
        if weapon and weapon.GetUpgradeTier then
            return weapon:GetUpgradeTier()
        end

    end
	
	return kTechId.None, 0

end

function PlayerUI_GetUtilitySlotTech(slot)

	local player = Client.GetLocalPlayer()
	
	if player then
		if player.GetUtilitySlotTechId then
			return player:GetUtilitySlotTechId(slot)
		end
	end

    return kTechId.None
end

function MarineBuy_GetEquipment()
    
    local inventory = {}
    local player = Client.GetLocalPlayer()
    local items = GetChildEntities( player, "ScriptActor" )
    
    for _, item in ipairs(items) do
    
        local techId = item:GetTechId()
        
        if techId ~= kTechId.Pistol and techId ~= kTechId.Axe and techId ~= kTechId.Rifle then
        --can't buy above, so skip
            
            local itemName = GetDisplayNameForTechId(techId)    --simple validity check
            if itemName then
                inventory[techId] = true
            end
            
        end

    end
    
    if player:isa("JetpackMarine") then
        inventory[kTechId.Jetpack] = true
    --elseif player:isa("Exo") then
        --Exo's are inheriently handled by how the BuyMenus are organized
    end
	
	local slot3, slot5
	slot3 = PlayerUI_GetUtilitySlotTech(3)
    slot5 = PlayerUI_GetUtilitySlotTech(5)
	
	if slot3 ~= kTechId.None then
		inventory[slot3] = true
	end
	
	if slot5 ~= kTechId.None then
		--inventory[slot5] = true
	end
	
    return inventory
    
end

local oldMarineBuy_GetCosts = MarineBuy_GetCosts
function MarineBuy_GetCosts(techId)
    if techId == kTechId.ClusterGrenade or techId == kTechId.GasGrenade or techId == kTechId.PulseGrenade then
		local slot5 = PlayerUI_GetUtilitySlotTech(5)
		if slot5 ~= kTechId.None then
			return kMarineReBuyGrenadesCost
		else
			return oldMarineBuy_GetCosts(techId)
		end
    else
        return oldMarineBuy_GetCosts(techId)
    end
end

function PlayerUI_GetHasItem(techId)

    local hasItem = false

    if techId and techId ~= kTechId.None then

        local player = Client.GetLocalPlayer()
        if player then

            local items = GetChildEntities(player, "ScriptActor")

            for index, item in ipairs(items) do

                if item:GetTechId() == techId then

                    hasItem = true
                    break

                end

            end

        end

    end
	
	if not kAllowMarineUtilityRebuy then
	
		local slot3, slot5
		slot3 = PlayerUI_GetUtilitySlotTech(3)
		--slot5 = PlayerUI_GetUtilitySlotTech(5)
		
		if slot3 == techId then
			hasItem = true
		end
		
		if slot5 == techId then
			hasItem = true
		end
		
	end
	
    return hasItem

end