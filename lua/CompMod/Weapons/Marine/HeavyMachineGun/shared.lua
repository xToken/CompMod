-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Marine\HeavyMachineGun\shared.lua
-- - Dragon

local networkVars =
{
    mg_upg1 = "boolean",
	mg_upg2 = "boolean",
}

local originalHeavyMachineGunOnInitialized
originalHeavyMachineGunOnInitialized = Class_ReplaceMethod("HeavyMachineGun", "OnInitialized",
	function(self)
		originalHeavyMachineGunOnInitialized(self)
		self.mg_upg1 = false
		self.mg_upg2 = false
		
		if Server then
			self:AddTimedCallback(HeavyMachineGun.OnTechOrResearchUpdated, 0.1)
		end
		
	end
)

function HeavyMachineGun:GetCatalystSpeedBase()
    return self.mg_upg2 and kHeavyMachineGunUpgReloadSpeed or kHeavyMachineGunReloadSpeed
end

function HeavyMachineGun:GetClipSize()
    return self.mg_upg1 and kHeavyMachineGunUpgradedClipSize or kHeavyMachineGunClipSize
end

function HeavyMachineGun:GetWeight()
    return kHeavyMachineGunWeight
end

function HeavyMachineGun:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.MGUpgrade1) then
		local fullClip = self.clip == self:GetClipSize()
		self.mg_upg1 = true
		if fullClip then
			-- Automagically fill the gun with moar bullets!
			self.clip = self:GetClipSize()
		end
	else
		self.mg_upg1 = false
		if self.clip > self:GetClipSize() then
			-- Automagically delete the bullets!
			self.clip = self:GetClipSize()
		end
	end
	if GetHasTech(self, kTechId.MGUpgrade2) then
		self.mg_upg2 = true
	else
		self.mg_upg2 = false
	end
end

function HeavyMachineGun:GetUpgradeTier()
	if self.mg_upg2 then
		return kTechId.MGUpgrade2, 2
	elseif self.mg_upg1 then
		return kTechId.MGUpgrade1, 1
	end
    return kTechId.None, 0
end

Shared.LinkClassToMap("HeavyMachineGun", HeavyMachineGun.kMapName, networkVars)