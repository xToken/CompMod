-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Marine\ArmsLab\shared.lua
-- - Dragon

function ArmsLab:GetTechButtons(techId)
	return { kTechId.Weapons1, kTechId.Weapons2, kTechId.Weapons3, kTechId.None,
				kTechId.Armor1, kTechId.Armor2, kTechId.Armor3, kTechId.None }
end