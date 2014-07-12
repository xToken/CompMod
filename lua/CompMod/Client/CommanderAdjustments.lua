
// Automatically selects hive specific evo chamber when triggering that tech client side.
local oldAlienCommanderSetCurrentTech = AlienCommander.SetCurrentTech
function AlienCommander:SetCurrentTech(techId)
	if techId == kTechId.LifeFormMenu then
		local evochamberId = Entity.invalidId
		for _, unit in ipairs(self:GetSelection()) do
			if unit:isa("Hive") and unit:GetEvolutionChamber() ~= Entity.invalidId then
				evochamberId = unit:GetEvolutionChamber()
				break
			end
		end
		if evochamberId ~= Entity.invalidId then
			local evochamber = Shared.GetEntity(evochamberId)
			if evochamber then
				DeselectAllUnits(self:GetTeamNumber())
				evochamber:SetSelected(self:GetTeamNumber(), true, false, true)
			end
		end
	elseif tech == kTechId.Return then
		//Return hack
		self.menuTechId = kTechId.BuildMenu
	else
		oldAlienCommanderSetCurrentTech(self, techId)
	end
end

// Overrides the setting changing the DNA icon into an arrow.
local function GetIsMenu(techId)

    local techTree = GetTechTree()
    if techTree and techId ~= kTechId.LifeFormMenu then
    
        local techNode = techTree:GetTechNode(techId)
        return techNode ~= nil and techNode:GetIsMenu()
        
    end
    
    return false

end

ReplaceLocals(CommanderUI_MenuButtonOffset, { GetIsMenu = GetIsMenu })