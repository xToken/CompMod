-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\ArmsLab.lua
-- - Dragon

local function GetLocalPlayerIsACommander()

    local player = Client.GetLocalPlayer()
    if player then
        return player:isa("Commander"), player
    end
    
    return nil, nil
    
end

local CountToResearchId = { }
CountToResearchId[kTechId.WeaponsArmsLab] = { [0] = kTechId.Weapons1, [1] = kTechId.Weapons2, [2] = kTechId.Weapons3, [3] = kTechId.Weapons3 }
CountToResearchId[kTechId.ArmorArmsLab] = { [0] = kTechId.Armor1, [1] = kTechId.Armor2, [2] = kTechId.Armor3, [3] = kTechId.Armor3 }

local function GetTierTech(self, techId)
	local isCommander, player, techTree
	if Client then
		isCommander, player = GetLocalPlayerIsACommander()
		techTree = GetTechTree()
		
	end
	if Server then
		player = GetCommanderForTeam(self:GetTeamNumber())
		techTree = GetTechTree(self:GetTeamNumber())
		isCommander = true
	end
	if player and isCommander then
		local count = player:GetTrackedStructures(techId)
		local targetTech = CountToResearchId[techId][count]
		local techNode = techTree:GetTechNode(targetTech)
		if techNode then
			if techNode:GetResearching() then
				targetTech = CountToResearchId[techId][math.min(count + 1, 3)]
				techNode = techTree:GetTechNode(targetTech)
				if techNode:GetResearching() then
					return CountToResearchId[techId][math.min(count + 2, 3)]
				end
			end
		end
		return targetTech
	end
	return CountToResearchId[techId][3]
end

function ArmsLab:GetTechButtons(techId)
	
	if self:GetTechId() == kTechId.ArmsLab then
		return { GetTierTech(self, kTechId.WeaponsArmsLab), kTechId.None, kTechId.None, kTechId.None,
				 GetTierTech(self, kTechId.ArmorArmsLab), kTechId.None, kTechId.None, kTechId.None }
    end
	return { kTechId.None, kTechId.None, kTechId.None, kTechId.None,
             kTechId.None, kTechId.None, kTechId.None, kTechId.None }
end

if Server then

	local kArmsLabResearchesInFlight = { }
	
	function ArmsLab:GetCanResearchOverride(techId)		
		return not table.contains(kArmsLabResearchesInFlight, techId)
	end

	function ArmsLab:OnResearchComplete(researchId)
		local oldId = self:GetTechId()
		local newId = (researchId == kTechId.Weapons1 or researchId == kTechId.Weapons2 or researchId == kTechId.Weapons3) and kTechId.WeaponsArmsLab or kTechId.ArmorArmsLab
		if self:UpgradeToTechId(newId) then
			local team = self:GetTeam()
			if team then
				team:OnTeamEntityUpdated(oldId, newId, self)
			end
		end
		table.removevalue(kArmsLabResearchesInFlight, researchId)
	end

	function ArmsLab:OnDestroy()

		local team = self:GetTeam()

		if team then
			team:OnTeamEntityDestroyed(self)
		end

		ScriptActor.OnDestroy(self)

	end
	
	function ArmsLab:OnResearchCancel(researchId)
		table.removevalue(kArmsLabResearchesInFlight, researchId)
	end
	
	function ArmsLab:OnResearch(researchId)
		if researchId ~= kTechId.Weapons3 and researchId ~= kTechId.Armor3 then
			table.insert(kArmsLabResearchesInFlight, researchId)
		end
	end
	
end

Shared.LinkClassToMap("ArmsLab", ArmsLab.kMapName, { })

class 'ArmorArmsLab' (ArmsLab)
ArmorArmsLab.kMapName = "armorarmslab"
Shared.LinkClassToMap("ArmorArmsLab", ArmorArmsLab.kMapName, { })

class 'WeaponsArmsLab' (ArmsLab)
WeaponsArmsLab.kMapName = "weaponsarmslab"
Shared.LinkClassToMap("WeaponsArmsLab", WeaponsArmsLab.kMapName, { })