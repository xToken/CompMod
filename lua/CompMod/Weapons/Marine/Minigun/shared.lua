-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Marine\Minigun\shared.lua
-- - Dragon

local networkVars =
{
    minigun_upg1 = "boolean",
	minigun_upg2 = "boolean",
}

local originalMinigunOnInitialized
originalMinigunOnInitialized = Class_ReplaceMethod("Minigun", "OnInitialized",
	function(self)
		originalMinigunOnInitialized(self)
		self.minigun_upg1 = false
		self.minigun_upg2 = false
		
		if Server then
			self:AddTimedCallback(Minigun.OnTechOrResearchUpdated, 0.1)
		end
		
	end
)

function Minigun:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.MinigunUpgrade1) then
		self.minigun_upg1 = true
	else
		self.minigun_upg1 = false
	end
	if GetHasTech(self, kTechId.MinigunUpgrade2) then
		self.minigun_upg2 = true
	else
		self.minigun_upg2 = false
	end
end

function Minigun:GetUpgradeTier()
	if self.minigun_upg2 then
		return kTechId.MinigunUpgrade2, 2
	elseif self.minigun_upg1 then
		return kTechId.MinigunUpgrade1, 1
	end
    return kTechId.None, 0
end

Shared.LinkClassToMap("Minigun", Minigun.kMapName, networkVars)