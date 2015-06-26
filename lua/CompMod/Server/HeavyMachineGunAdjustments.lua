// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Server\HeavyMachineGunAdjustments.lua
// - Dragon

local kHitSoundEnabledForWeapon = GetUpValue( HitSound_IsEnabledForWeapon,   "kHitSoundEnabledForWeapon" )
table.insert(kHitSoundEnabledForWeapon, kTechId.HeavyMachineGun)
kHitSoundEnabledForWeapon[kTechId.HeavyMachineGun] = true

/*function Marine:InitWeapons()

    Player.InitWeapons(self)
    
    self:GiveItem(HeavyMachineGun.kMapName)
    self:GiveItem(Pistol.kMapName)
    self:GiveItem(Axe.kMapName)
    self:GiveItem(Builder.kMapName)
    
    self:SetQuickSwitchTarget(Pistol.kMapName)
    self:SetActiveWeapon(HeavyMachineGun.kMapName)

end*/