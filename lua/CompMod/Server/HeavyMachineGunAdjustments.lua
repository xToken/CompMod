//Dont want to always replace random files, so this.

local kHitSoundEnabledForWeapon = GetUpValue( HitSound_IsEnabledForWeapon,   "kHitSoundEnabledForWeapon" )
table.insert(kHitSoundEnabledForWeapon, kTechId.HeavyMachineGun)
kHitSoundEnabledForWeapon[kTechId.HeavyMachineGun] = true

function Marine:InitWeapons()

    Player.InitWeapons(self)
    
    self:GiveItem(HeavyMachineGun.kMapName)
    self:GiveItem(Pistol.kMapName)
    self:GiveItem(Axe.kMapName)
    self:GiveItem(Builder.kMapName)
    
    self:SetQuickSwitchTarget(Pistol.kMapName)
    self:SetActiveWeapon(HeavyMachineGun.kMapName)

end