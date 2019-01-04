-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Commander\client.lua
-- - Dragon

local GetIsMenu = GetUpValue( CommanderUI_MenuButtonOffset, "GetIsMenu")

function CommanderUI_MenuButtonOffset(index)

    local player = Client.GetLocalPlayer()
    if index <= table.icount(player.menuTechButtons) then
    
        local techId = player.menuTechButtons[index]
    
        if index == 4 then
            local selectedEnts = player:GetSelection()
            if selectedEnts and selectedEnts[1] then
                techId = selectedEnts[1]:GetTechId()
            end
        else
        
            -- show the back arrow when a menu button is at the bottom right
            if index == 12 and GetIsMenu(techId) then
                techId = kTechId.RootMenu
            end
        
        end

        return GetMaterialXYOffset(techId, player:isa("MarineCommander"))
        
    end
    
    return -1, -1
    
end