-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Server\JetpackMarine.lua
-- - Dragon

function JetpackMarine:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.NanoArmor) then
		self.nanoArmor = true
	else
		self.nanoArmor = false
	end
end