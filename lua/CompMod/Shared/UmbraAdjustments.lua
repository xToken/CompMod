// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\UmbraAdjustments.lua
// - Dragon

local kUmbraModifier = { }
kUmbraModifier["Shotgun"] = kUmbraShotgunModifier
kUmbraModifier["Rifle"] = kUmbraBulletModifier
kUmbraModifier["Pistol"] = kUmbraBulletModifier
kUmbraModifier["Sentry"] = kUmbraBulletModifier
kUmbraModifier["HeavyMachineGun"] = kUmbraBulletModifier
kUmbraModifier["Minigun"] = kUmbraMinigunModifier
kUmbraModifier["Railgun"] = kUmbraRailgunModifier

function UmbraMixin:ModifyDamageTaken(damageTable, attacker, doer, damageType)

    if self:GetHasUmbra() then
    
        local modifier = 1
        if doer then
			local umbraDR = kUmbraModifier[doer:GetClassName()] or 1
			if HasMixin(self, "Fire") and self:GetIsOnFire() then
				modifier = 1 - ((1 - umbraDR) * kUmbraOnFireReduction)
			else
				modifier = umbraDR
			end
        end
    
        damageTable.damage = damageTable.damage * modifier
        
    end
    

end