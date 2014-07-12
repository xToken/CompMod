//Dont want to always replace random files, so this.

local oldHiveOnCreate = Hive.OnCreate
function Hive:OnCreate()
	oldHiveOnCreate(self)
	self.evochamber = Entity.invalidId
end

// Changes to handle the evolution chamber assigned to each hive.
function Hive:GetEvolutionChamber()
	return self.evochamber
end

function Hive:GetTechButtons(techId)

    local techButtons = { kTechId.ShiftHatch, kTechId.None, kTechId.None, kTechId.None,
                          kTechId.None, kTechId.None, kTechId.None, kTechId.None }

    if self:GetTechId() == kTechId.Hive then
    
        techButtons[5] = ConditionalValue(GetHiveTypeResearchAllowed(self, kTechId.UpgradeToCragHive), kTechId.UpgradeToCragHive, kTechId.None)
        techButtons[6] = ConditionalValue(GetHiveTypeResearchAllowed(self, kTechId.UpgradeToShadeHive), kTechId.UpgradeToShadeHive, kTechId.None)
        techButtons[7] = ConditionalValue(GetHiveTypeResearchAllowed(self, kTechId.UpgradeToShiftHive), kTechId.UpgradeToShiftHive, kTechId.None)
    
    end
	
	if self:GetEvolutionChamber() ~= Entity.invalidId then
		techButtons[4] = kTechId.LifeFormMenu
	end
    
    if self.bioMassLevel <= 1 then
        techButtons[2] = kTechId.ResearchBioMassOne
    elseif self.bioMassLevel <= 2 then
        techButtons[2] = kTechId.ResearchBioMassTwo
	else
		
    end
    
    return techButtons
    
end

Shared.LinkClassToMap("Hive", nil, {evochamber = "entityid"})