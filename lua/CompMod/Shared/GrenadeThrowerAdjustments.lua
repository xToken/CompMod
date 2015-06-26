// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\GrenadeThrowerAdjustments.lua
// - Dragon

local oldGrenadeThrowerOnCreate
oldGrenadeThrowerOnCreate = Class_ReplaceMethod("GrenadeThrower", "OnCreate",
	function(self)
		oldGrenadeThrowerOnCreate(self)
		self.grenadesLeft = kPurchasedHandGrenades
		InitMixin(self, PickupableWeaponMixin)
		InitMixin(self, LiveMixin)
    end
)

function GrenadeThrower:ModifyDamageTaken(damageTable, attacker, doer, damageType)
    if damageType ~= kDamageType.Corrode then
        damageTable.damage = 0
    end
end

function GrenadeThrower:GetCanTakeDamageOverride()
    return self:GetParent() == nil
end

function GrenadeThrower:AddGrenades(amount)
	self.grenadesLeft = Clamp(self.grenadesLeft + amount, 0, kMaxHandGrenades)
end

function GrenadeThrower:GetRemainingGrenades()
	return self.grenadesLeft
end

if Server then

    function GrenadeThrower:OnKill()
        DestroyEntity(self)
    end
    
    function GrenadeThrower:GetSendDeathMessageOverride()
        return false
    end    
    
end

local networkVars = { }

AddMixinNetworkVars(LiveMixin, networkVars)

Shared.LinkClassToMap("GrenadeThrower", GrenadeThrower.kMapName, networkVars)

//Maybe?
function GasGrenadeThrower:GetIsDroppable()
    return true
end

function ClusterGrenadeThrower:GetIsDroppable()
    return true
end

function PulseGrenadeThrower:GetIsDroppable()
    return true
end