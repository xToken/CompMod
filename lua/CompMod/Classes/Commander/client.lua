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

local oldCommanderGhostStructureLeftMouseButtonDown = CommanderGhostStructureLeftMouseButtonDown
local ghostStructureCoords
function CommanderGhostStructureLeftMouseButtonDown(x, y)
    local commander = Client.GetLocalPlayer()
    local curTech = commander.currentTechId
    oldCommanderGhostStructureLeftMouseButtonDown(x, y)
    if curTech == kTechId.TeleportStructure and commander.lastTeleportTechId ~= kTechId.None then
        local techTree = GetTechTree()
        local techNode = techTree:GetTechNode(commander.lastTeleportTechId)
        local allowed, canAfford = commander:GetTechAllowed(commander.lastTeleportTechId, techNode, commander)
        if not allowed then
            commander.lastTeleportTechId = kTechId.None
            ghostStructureCoords = GetUpValue(oldCommanderGhostStructureLeftMouseButtonDown, "ghostStructureCoords")
            Client.AddWorldMessage(kWorldTextMessageType.CommanderError, Locale.ResolveString("COMMANDERERROR_TECH_NOT_AVAILABLE"), ghostStructureCoords.origin)
        elseif not canAfford then
            commander.lastTeleportTechId = kTechId.None
            ghostStructureCoords = GetUpValue(oldCommanderGhostStructureLeftMouseButtonDown, "ghostStructureCoords")
            Client.AddWorldMessage(kWorldTextMessageType.CommanderError, string.format(Locale.ResolveString("COMMANDERERROR_INSUFFICIENT_RESOURCES_%s"), ToString(techNode:GetCost())), ghostStructureCoords.origin)
        else
            commander:SetCurrentTech(commander.lastTeleportTechId)
            commander.lastTeleportTechId = kTechId.None
            -- This isnt ideal as well, involves a debug call each click for comms... buts its the comm.. he doesnt really need perfect FPS right?
            ghostStructureCoords = GetUpValue(oldCommanderGhostStructureLeftMouseButtonDown, "ghostStructureCoords")
            Client.AddWorldMessage(kWorldTextMessageType.CommanderError, Locale.ResolveString("SELECT_ECHO_LOCATION"), ghostStructureCoords.origin)
        end
    end
end