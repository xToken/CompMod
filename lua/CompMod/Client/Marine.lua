-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Client\Marine.lua
-- - Dragon

-- returns 0 - 3
function PlayerUI_GetArmorLevel()
    local gameInfoEnt = GetGameInfoEntity()
    assert(gameInfoEnt)

    if gameInfoEnt:GetWarmUpActive() then
        return 3
    end

    local armorLevel = 0
	local player = Client.GetLocalPlayer()
	
	if player then
		local teamInfo = GetTeamInfoEntity(player:GetTeamNumber())
		if teamInfo then
			armorLevel = teamInfo:GetUpgradeLevel(kTechId.ArmorArmsLab)
		end
	end

    return armorLevel
end

function PlayerUI_GetWeaponLevel()
    local gameInfoEnt = GetGameInfoEntity()
    assert(gameInfoEnt)

    if gameInfoEnt:GetWarmUpActive() then
        return 3
    end
	
	local weaponLevel = 0
	local player = Client.GetLocalPlayer()
	
	if player then
		local teamInfo = GetTeamInfoEntity(player:GetTeamNumber())
		if teamInfo then
			weaponLevel = teamInfo:GetUpgradeLevel(kTechId.WeaponsArmsLab)
		end
	end

    return weaponLevel
end

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

-- Little weird, but if we have the tech, we have the arms lab now.
function MarineUI_GetHasArmsLab()
    return true
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
	
	local slot4, slot5
	slot4 = PlayerUI_GetUtilitySlotTech(4)
    slot5 = PlayerUI_GetUtilitySlotTech(5)
	
	if slot4 ~= kTechId.None then
		inventory[slot4] = true
	end
	
	if slot5 ~= kTechId.None then
		inventory[slot5] = true
	end
	
    return inventory
    
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
	
		local slot4, slot5
		slot4 = PlayerUI_GetUtilitySlotTech(4)
		slot5 = PlayerUI_GetUtilitySlotTech(5)
		
		if slot4 == techId then
			hasItem = true
		end
		
		if slot5 == techId then
			hasItem = true
		end
		
	end
	
    return hasItem

end