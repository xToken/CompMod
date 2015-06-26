// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\OnosAdjustments.lua
// - Dragon

// Comp Mod change, bone shield doesnt block all damage.
local kBlockDoers =
{
    "Minigun",
    "Pistol",
    "Rifle",
    "HeavyMachineGun",
    "Shotgun",
    "Axe",
    "Welder",
    "Sentry",
    "Claw"
}

local function GetHitsBoneShield(self, doer, hitPoint)

    if table.contains(kBlockDoers, doer:GetClassName()) then
    
        local viewDirection = GetNormalizedVectorXZ(self:GetViewCoords().zAxis)
        local zPosition = viewDirection:DotProduct(GetNormalizedVector(hitPoint - self:GetOrigin()))

        return zPosition > -0.1
    
    end
    
    return false

end

function Onos:ModifyDamageTaken(damageTable, attacker, doer, damageType, hitPoint)

    if hitPoint ~= nil and self:GetIsBoneShieldActive() and GetHitsBoneShield(self, doer, hitPoint) then
    
        damageTable.damage = damageTable.damage * kBoneShieldDamageReduction
        self:TriggerEffects("boneshield_blocked", {effecthostcoords = Coords.GetTranslation(hitPoint)} )
        
    end

end