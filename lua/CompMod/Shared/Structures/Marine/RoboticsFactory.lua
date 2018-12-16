-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\RoboticsFactory.lua
-- - Dragon

RoboticsFactory.kResupplyUseRange = 4

function RoboticsFactory:GetTechButtons(techId)

    local techButtons = {  kTechId.ARC, kTechId.MAC, kTechId.None, kTechId.ARCUpgrade1, 
               kTechId.SentryUpgrade1, kTechId.MinigunUpgrade1, kTechId.RailgunUpgrade1, kTechId.None }
               
    if self:GetTechId() ~= kTechId.ARCRoboticsFactory then
        techButtons[5] = kTechId.UpgradeRoboticsFactory
    end
	
	if GetHasTech(self, kTechId.ARCUpgrade1) then
        techButtons[4] = kTechId.ARCUpgrade2
    end

    return techButtons
    
end

function RoboticsFactory:GetCanBeUsed(player, useSuccessTable)

    if (not self:GetIsBuilt() and player:isa("Exo")) or (player:isa("Exo") and player:GetHasDualGuns()) then
        useSuccessTable.useSuccess = false
    end
    
end

function RoboticsFactory:GetCanBeUsedConstructed()
    return true
end

function RoboticsFactory:GetItemList(forPlayer)

    return { kTechId.DualMinigunExosuit, kTechId.DualRailgunExosuit, }
    
end