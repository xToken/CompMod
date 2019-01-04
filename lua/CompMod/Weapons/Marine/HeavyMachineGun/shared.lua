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

function HeavyMachineGun:GetReloadSpeed()
	return self.mg_upg2 and kHeavyMachineGunUpgReloadSpeed or kHeavyMachineGunReloadSpeed
end

function HeavyMachineGun:GetClipSize()
    return self.mg_upg2 and kHeavyMachineGunUpgradedClipSize or kHeavyMachineGunClipSize
end

function HeavyMachineGun:GetWeight()
    return self.mg_upg1 and kHeavyMachineGunUpgradedWeight or kHeavyMachineGunWeight
end

function HeavyMachineGun:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.MGUpgrade1) then
		self.mg_upg1 = true
		local player = self:GetParent()
		if player then
			player:TriggerWeaponWeightUpdate()
		end
	else
		self.mg_upg1 = false
		local player = self:GetParent()
		if player then
			player:TriggerWeaponWeightUpdate()
		end
	end
	if GetHasTech(self, kTechId.MGUpgrade2) then
		local fullClip = self.clip == self:GetClipSize()
		self.mg_upg2 = true
		if fullClip then
			-- Automagically fill the gun with moar bullets!
			self.clip = self:GetClipSize()
		end
	else
		self.mg_upg2 = false
		if self.clip > self:GetClipSize() then
			-- Automagically delete the bullets!
			self.clip = self:GetClipSize()
		end
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

function HeavyMachineGun:OnUpdateAnimationInput(modelMixin)

    PROFILE("HeavyMachineGun:OnUpdateAnimationInput")
    
    ClipWeapon.OnUpdateAnimationInput(self, modelMixin)
    
    modelMixin:SetAnimationInput("reload_speed", self:GetReloadSpeed())

end

Shared.LinkClassToMap("HeavyMachineGun", HeavyMachineGun.kMapName, networkVars)