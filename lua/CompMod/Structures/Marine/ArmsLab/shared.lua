-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Marine\ArmsLab\shared.lua
-- - Dragon

function ArmsLab:GetTechButtons(techId)
	return { kTechId.Weapons1, kTechId.Weapons2, kTechId.Weapons3, kTechId.None,
				kTechId.Armor1, kTechId.Armor2, kTechId.Armor3, kTechId.None }
end

--[[
function ArmsLab:GetTechAllowed(techId, techNode, player)

    local allowed, canAfford = ScriptActor.GetTechAllowed(self, techId, techNode, player) 
    local techTree = GetTechTree(player:GetTeamNumber())

    if allowed and techTree then

    	if techId == kTechId.Weapons2 or techId == kTechId.Armor2 then
    		allowed = techTree:GetHasTech(kTechId.AdvancedArmory)
    	end
    	if techId == kTechId.Weapons3 or techId == kTechId.Armor3 then
    		allowed = techTree:GetHasTech(kTechId.AdvancedArmory) and techTree:GetHasTech(kTechId.PrototypeLab)
    	end

    end

    return allowed, canAfford
end
]]--