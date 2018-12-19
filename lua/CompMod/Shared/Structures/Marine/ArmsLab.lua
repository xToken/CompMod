-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\ArmsLab.lua
-- - Dragon

local kStructureTechIdtoUpgradeTechId = { }
kStructureTechIdtoUpgradeTechId[kTechId.Weapons1] = kTechId.Weapons2Upgrade
kStructureTechIdtoUpgradeTechId[kTechId.Weapons2] = kTechId.Weapons3Upgrade
kStructureTechIdtoUpgradeTechId[kTechId.Weapons3] = kTechId.None
kStructureTechIdtoUpgradeTechId[kTechId.Armor1] = kTechId.Armor2Upgrade
kStructureTechIdtoUpgradeTechId[kTechId.Armor2] = kTechId.Armor3Upgrade
kStructureTechIdtoUpgradeTechId[kTechId.Armor3] = kTechId.None

function ArmsLab:GetTechButtons(techId)
	if self:GetTechId() == kTechId.ArmsLab then
		return { kTechId.Weapons1Upgrade, kTechId.None, kTechId.None, kTechId.None,
				kTechId.Armor1Upgrade, kTechId.None, kTechId.None, kTechId.None }
	end
	return { kStructureTechIdtoUpgradeTechId[self:GetTechId()] or kTechId.None, kTechId.None, kTechId.None, kTechId.None,
				kTechId.None, kTechId.None, kTechId.None, kTechId.None }
end

if Server then

	local kUpgradeTechIdtoStructureTechId = { }
	kUpgradeTechIdtoStructureTechId[kTechId.Weapons1Upgrade] = kTechId.Weapons1
	kUpgradeTechIdtoStructureTechId[kTechId.Weapons2Upgrade] = kTechId.Weapons2
	kUpgradeTechIdtoStructureTechId[kTechId.Weapons3Upgrade] = kTechId.Weapons3
	kUpgradeTechIdtoStructureTechId[kTechId.Armor1Upgrade] = kTechId.Armor1
	kUpgradeTechIdtoStructureTechId[kTechId.Armor2Upgrade] = kTechId.Armor2
	kUpgradeTechIdtoStructureTechId[kTechId.Armor3Upgrade] = kTechId.Armor3

	function ArmsLab:OnResearchComplete(researchId)
		local oldId = self:GetTechId()
		local newId = kUpgradeTechIdtoStructureTechId[researchId]
		if newId and self:UpgradeToTechId(newId) then
			local team = self:GetTeam()
			if team then
				team:OnTeamEntityUpdated(oldId, newId, self)
			end
		end
	end

	function ArmsLab:OnDestroy()

		local team = self:GetTeam()

		if team then
			team:OnTeamEntityDestroyed(self)
		end

		ScriptActor.OnDestroy(self)

	end
	
end

Shared.LinkClassToMap("ArmsLab", ArmsLab.kMapName, { })

class 'Armor1ArmsLab' (ArmsLab)
Armor1ArmsLab.kMapName = "armor1armslab"
Shared.LinkClassToMap("Armor1ArmsLab", Armor1ArmsLab.kMapName, { })

class 'Armor2ArmsLab' (ArmsLab)
Armor2ArmsLab.kMapName = "armor2armslab"
Shared.LinkClassToMap("Armor2ArmsLab", Armor2ArmsLab.kMapName, { })

class 'Armor3ArmsLab' (ArmsLab)
Armor3ArmsLab.kMapName = "armor3armslab"
Shared.LinkClassToMap("Armor3ArmsLab", Armor3ArmsLab.kMapName, { })

class 'Weapons1ArmsLab' (ArmsLab)
Weapons1ArmsLab.kMapName = "weapons1armslab"
Shared.LinkClassToMap("Weapons1ArmsLab", Weapons1ArmsLab.kMapName, { })

class 'Weapons2ArmsLab' (ArmsLab)
Weapons2ArmsLab.kMapName = "weapons2armslab"
Shared.LinkClassToMap("Weapons2ArmsLab", Weapons2ArmsLab.kMapName, { })

class 'Weapons3ArmsLab' (ArmsLab)
Weapons3ArmsLab.kMapName = "weapons3armslab"
Shared.LinkClassToMap("Weapons3ArmsLab", Weapons3ArmsLab.kMapName, { })