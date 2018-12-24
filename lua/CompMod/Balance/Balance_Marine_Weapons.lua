-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Balance\Balance_Marine_Weapons.lua
-- - Dragon

-- pRes Costs
kWelderCost = 10							-- Increased from 3
kShotgunCost = 15							-- Decreased from 20
kHeavyMachineGunCost = 20					-- Default is 20
kGrenadeLauncherCost = 20					-- Default is 20
kFlamethrowerCost = 10						-- Decreased from 20
kDualExosuitCost = 30						-- Decreased from 55
kDualRailgunExosuitCost = 30				-- Decreased from 55
kJetpackCost = 10							-- Decreased from 15

-- Weights
kPistolWeight = 0.05
kRifleWeight = 0.175
kGrenadeLauncherWeight = 0.3
kFlamethrowerWeight = 0.2
kShotgunWeight = 0.225
kHeavyMachineGunWeight = 0.4
kHeavyMachineGunUpgradedWeight = 0.25
kHandGrenadeWeight = 0.05
kLayMineWeight = 0.075
kWelderWeight = 0.05
kClawWeight = 0.01							-- Default is 0.01
kMinigunWeight = 0.06						-- Default is 0.06
kRailgunWeight = 0.045						-- Default is 0.045

kClusterGrenadeCost = 10					-- Increased from 2
kGasGrenadeCost = 10						-- Increased from 2
kPulseGrenadeCost = 10						-- Increased from 2
kMineCost = 5								-- Increased from 2
kMarineReBuyGrenadesCost = 2

-- SHOTGUN
kShotgunBulletsPerShot = 10					-- Decreased from 17
kShotgunSpreadDistance = 4					-- Decreased from 8.5 (See other adjustments in Shotgun.lua)
kShotgunDamage = 17							-- Increased from 10
kShotgunMaxRange = 16						-- Added max range (Damage drops to 1)
kShotgunDropOffStartRange = 6				-- Min range where damage falloff begins
kShotgunBaseROF	= 1.08						-- Increased SG base rate of fire
kShotgunUpgradedROF	= 1.16					-- Increased SG base rate of fire from upgrades
kShotgunFireRate = 0.70						-- To prevent fire rate cap from triggering
kShotgunClipSize = 6						-- Default is 6
kShotgunUpgradedReloadSpeed = 1.2

-- MG
kHeavyMachineGunDamage = 14					-- Default is 9 (*)
kHeavyMachineGunStructureDamageScalar = 0.5
kHeavyMachineGunStructureUpgradedDamageScalar = 0.5
kHeavyMachineGunClipSize = 100				-- Default is 125
kHeavyMachineGunUpgradedClipSize = 125
kHeavyMachineGunSpread = Math.Radians(4)	-- Default is 4
kHeavyMachineGunReloadSpeed = 0.39611550146364	-- Dont ask.....
kHeavyMachineGunUpgReloadSpeed = 0.7

-- PISTOL
kPistolDamage = 20							-- Decreased from 25
kPistolDamageType = kDamageType.Normal		-- Default is Light

-- FLAMETHROWER
kFlamethrowerDamage = 16					-- Increased from 12
kFlamethrowerDamageRadius = 0.5				-- Decreased from 1.8 (NOT USED)
kFlamethrowerConeWidth = 0.05				-- Default is 0.3
kFlamethrowerClipSize = 25					-- Decreased from 50
kFlamethrowerRange = 5						-- Decreased from 9
kFlamethrowerUpgradedRange = 8
kFlameThrowerEnergyDamage = 1				-- Default is 1
kFlamethrowerDamageType = kDamageType.Normal-- Default is Flame
kBurnDamagePerSecond = 25
kFlamethrowerBurnDuration = 0.25
kFlamethrowerMaxBurnDuration = 15

-- SIGHHHHHHHHHHHHHHHHHHHH
kSprayDouseOnFireChance = 1.01

-- GL
kGrenadeLauncherGrenadeDamage = 80			-- Decreased from 165
kGrenadeLauncherClipSize = 4				-- Default is 4
kGrenadeLauncherGrenadeDamageRadius = 3.5	-- Decreased from 4.8
kGrenadeLifetime = 2.0						-- Default is 2
kGrenadeLauncherSpeed = 30					-- Increased from 25
kGrenadeLauncherSecondaryStructureMultiplier = 2

kGrenadeFragmentDamageRadius = 3
kGrenadeFragmentDamage = 20

-- MINIGUN
kMinigunDamage = 10							-- Default is 10
kMinigunDamageType = kDamageType.Normal		-- Default is Normal

-- RAILGUN
kRailgunDamage = 10							-- Default is 10
kRailgunChargeDamage = 140					-- Default is 140
kRailgunDamageType = kDamageType.Structural

-- MINES
kMineArmingTime = 0.03						-- Default is 0.17
kMinesPerPlayerLimit = 99
kNumMines = 2								-- Increased from 3

-- WELDER
kWelderStructureDamagePerSecond = 25
kWelderDamageType = kDamageType.Flame
kWelderDamagePerSecond = 30
kWelderFriendlyRange = 2.4
kWelderAttackRange = 1.7
kSelfWeldAmount = 5
kPlayerArmorWeldRate = 30					-- Default is 20
kStructureWeldRate = 120					-- Default is 90