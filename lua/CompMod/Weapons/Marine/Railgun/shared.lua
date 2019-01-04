-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Marine\Railgun\shared.lua
-- - Dragon

local networkVars =
{
    railgun_upg1 = "boolean",
	railgun_upg2 = "boolean",
}

local originalRailgunOnInitialized
originalRailgunOnInitialized = Class_ReplaceMethod("Railgun", "OnInitialized",
	function(self)
		originalRailgunOnInitialized(self)
		self.railgun_upg1 = false
		self.railgun_upg2 = false
		
		if Server then
			self:AddTimedCallback(Railgun.OnTechOrResearchUpdated, 0.1)
		end
		
	end
)

function Railgun:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.RailgunUpgrade1) then
		self.railgun_upg1 = true
	else
		self.railgun_upg1 = false
	end
end

function Railgun:GetUpgradeTier()
	if self.railgun_upg2 then
		return kTechId.None, 2
	elseif self.railgun_upg1 then
		return kTechId.RailgunUpgrade1, 1
	end
    return kTechId.None, 0
end

Shared.LinkClassToMap("Railgun", Railgun.kMapName, networkVars)