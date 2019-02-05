-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Marine\MarineCommander\shared.lua
-- - Dragon

local gMarineMenuButtons =
{

    [kTechId.BuildMenu] = { kTechId.CommandStation, kTechId.Extractor, kTechId.InfantryPortal, kTechId.Armory,
                            kTechId.RoboticsFactory, kTechId.ArmsLab, kTechId.PowerNode, kTechId.None },
                            
    [kTechId.AdvancedMenu] = { kTechId.Sentry, kTechId.Observatory, kTechId.PhaseGate, kTechId.PrototypeLab, 
                               kTechId.SentryBattery, kTechId.None, kTechId.None, kTechId.None },

    [kTechId.AssistMenu] = { kTechId.AmmoPack, kTechId.MedPack, kTechId.NanoShield, kTechId.Scan,
                             kTechId.PowerSurge, kTechId.CatPack, kTechId.WeaponsMenu, kTechId.None, },
                             
    [kTechId.WeaponsMenu] = { kTechId.DropShotgun, kTechId.DropGrenadeLauncher, kTechId.DropFlamethrower, kTechId.DropWelder,
                              kTechId.DropMines, kTechId.DropJetpack, kTechId.DropHeavyMachineGun, kTechId.AssistMenu}


}

local gMarineMenuIds = {}
do
    for menuId, _ in pairs(gMarineMenuButtons) do
        gMarineMenuIds[#gMarineMenuIds+1] = menuId
    end
end

function MarineCommander:GetButtonTable()
    return gMarineMenuButtons
end

function MarineCommander:GetMenuIds()
    return gMarineMenuIds
end

-- Top row always the same. Alien commander can override to replace.
function MarineCommander:GetQuickMenuTechButtons(techId)

    -- Top row always for quick access
    local marineTechButtons = { kTechId.BuildMenu, kTechId.AdvancedMenu, kTechId.AssistMenu, kTechId.RootMenu }
    local menuButtons = gMarineMenuButtons[techId]    
    
    if not menuButtons then
        menuButtons = {kTechId.None, kTechId.None, kTechId.None, kTechId.None, kTechId.None, kTechId.None, kTechId.None, kTechId.None }
    end

    table.copy(menuButtons, marineTechButtons, true)        

    -- Return buttons and true/false if we are in a quick-access menu
    return marineTechButtons
    
end

--[[
function MarineCommander:GetShowPowerIndicator()
    return false
end
--]]