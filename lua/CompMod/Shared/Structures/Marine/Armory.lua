-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\Armory.lua
-- - Dragon

function Armory:GetItemList(forPlayer)

    return {
		kTechId.Welder,
		kTechId.LayMines,
		kTechId.Flamethrower,
		kTechId.Shotgun,
		kTechId.HeavyMachineGun,
		kTechId.GrenadeLauncher,
		kTechId.ClusterGrenade,
		kTechId.GasGrenade,
		kTechId.PulseGrenade,
	}

end

function Armory:GetTechButtons(techId)

    local techButtons = 
    {
        kTechId.FlamethrowerUpgrade1, kTechId.ShotgunUpgrade1, kTechId.MGUpgrade1, kTechId.GLUpgrade1,
        kTechId.None, kTechId.GrenadeTech, kTechId.MinesTech, kTechId.None
    }
    
    -- Show button to upgraded to advanced armory
    if self:GetTechId() == kTechId.Armory and self:GetResearchingId() ~= kTechId.AdvancedArmoryUpgrade then
        techButtons[kMarineUpgradeButtonIndex] = kTechId.AdvancedArmoryUpgrade
    end
	
	if GetHasTech(self, kTechId.ShotgunUpgrade1) then
		techButtons[2] = kTechId.ShotgunUpgrade2
	end
	
	if GetHasTech(self, kTechId.MGUpgrade1) then
		techButtons[3] = kTechId.MGUpgrade2
	end

    return techButtons

end