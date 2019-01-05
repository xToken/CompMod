-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\AlienUpgradeManager\server.lua
-- - Dragon

function AlienUpgradeManager:Populate(player)

    assert(player)
    assert(HasMixin(player, "Upgradable"))
    
    self.upgrades = { }
    table.insert(self.upgrades, player:GetTechId())
    
    self.availableResources = player:GetPersonalResources()
    self.initialResources = player:GetPersonalResources()
    self.lifeFormTechId = player:GetTechId()
    self.initialLifeFormTechId = player:GetTechId()
    self.teamNumber = player:GetTeamNumber()
    
    self.initialUpgrades = { }
    table.copy(self.upgrades, self.initialUpgrades)

end