-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\AlienUpgradeManager\server.lua
-- - Dragon

-- Hooking this to remove upgrades if we are switching between categories
local GetHasCategory = GetUpValue(AlienUpgradeManager.AddUpgrade, "GetHasCategory")
local RemoveCategoryUpgrades = GetUpValue(AlienUpgradeManager.AddUpgrade, "RemoveCategoryUpgrades")
function AlienUpgradeManager:GetHasChanged()

    -- Scan our new upgrades.. Remove
    for _, upgradeId in ipairs(self.upgrades) do
        local categoryId = LookupTechData(upgradeId, kTechDataCategory)
        if not GetHasCategory(self.newUpgrades, categoryId) then
            -- We didnt request this category, so we must have removed it
            if categoryId then
                RemoveCategoryUpgrades(self, categoryId)
            end
        end
    end

    local changed = #self.upgrades ~= #self.initialUpgrades
    
    if not changed then
    
        for _, upgradeId in ipairs(self.upgrades) do
            
            if not table.icontains(self.initialUpgrades, upgradeId) then
                changed = true
                break
            end
            
        end
        
    end
    
    return changed
end

local oldAlienUpgradeManagerAddUpgrade = AlienUpgradeManager.AddUpgrade
function AlienUpgradeManager:AddUpgrade(upgradeId, override)
    local allowed = oldAlienUpgradeManagerAddUpgrade(self, upgradeId, override)
    if allowed then
        if not self.newUpgrades then
            self.newUpgrades = { }
        end
        table.insert(self.newUpgrades, upgradeId)
    end
    return allowed
end