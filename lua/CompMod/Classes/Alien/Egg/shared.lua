-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Alien\Egg\shared.lua
-- - Dragon

function Egg:BuildUpgradeStructureTable()
end

function Egg:PickUpgrades(newPlayer)

    local lastUpgradeList = newPlayer.lastUpgradeList and newPlayer.lastUpgradeList["Skulk"] or {}
    local teamNumber = self:GetTeamNumber()

    for i = 1, #lastUpgradeList do
        local techId = lastUpgradeList[i]
        if techId then
            if GetIsTechUseable(techId, teamNumber) then
                newPlayer:GiveUpgrade(techId)
            end
        end
    end

end