-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\ArmsLab.lua
-- - Dragon

function ArmsLab:GetTechButtons(techId)
	return { kTechId.Weapons1, kTechId.Weapons2, kTechId.Weapons3, kTechId.None,
				kTechId.Armor1, kTechId.Armor2, kTechId.Armor3, kTechId.None }
end

if Server then

	function ArmsLab:OnResearchComplete(researchId)

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