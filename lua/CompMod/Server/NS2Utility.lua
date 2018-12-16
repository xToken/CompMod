-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Server\NS2Utility.lua
-- - Dragon

-- Theres no callbacks here to notify the team... not sure why really
local oldCreateEntityForTeam = CreateEntityForTeam
function CreateEntityForTeam(techId, position, teamNumber, player)
	local newEnt = oldCreateEntityForTeam(techId, position, teamNumber, player)
	if newEnt then
		local gameRules = GetGamerules()
		if gameRules then
			-- Being extra careful here
			local team = gameRules:GetTeam(teamNumber)
			if team then
				team:OnTeamEntityCreated(newEnt)
			end
		end
	end
	return newEnt
end
