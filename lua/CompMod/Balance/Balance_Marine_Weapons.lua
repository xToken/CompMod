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
kDualExosuitCost = 25						-- Decreased from 55
kDualRailgunExosuitCost = 25				-- Decreased from 55
kJetpackCost = 10							-- Decreased from 15

-- Weights
kPistolWeight = 0.05
kRifleWeight = 0.175
kGrenadeLauncherWeight = 0.3
kFlamethrowerWeight = 0.125
kShotgunWeight = 0.225
kHeavyMachineGunWeight = 0.27
--kHeavyMachineGunUpgradedWeight = 0.25
kHandGrenadeWeight = 0.05
kLayMineWeight = 0.075
kWelderWeight = 0.05
kClawWeight = 0.01							-- Default is 0.01
kMinigunWeight = 0.06						-- Default is 0.06
kRailgunWeight = 0.045						-- Default is 0.045

kClusterGrenadeCost = 10					-- Increased from 2
kGasGrenadeCost = 10						-- Increased from 2
kPulseGrenadeCost = 10						-- Increased from 2
kMineCost = 5								-- Decreased from 10
kMarineReBuyGrenadesCost = 2

-- SHOTGUN
kShotgunBulletsPerShot = 10					-- Decreased from 17
kShotgunSpreadDistance = 4					-- Decreased from 8.5 (See other adjustments in Shotgun.lua)
kShotgunDamage = 17							-- Increased from 10
kShotgunMaxRange = 16						-- Added max range (Damage drops to 1)
kShotgunDropOffStartRange = 6				-- Min range where damage falloff begins
kShotgunBaseROF	= 1.04						-- Increased SG base rate of fire
kShotgunUpgradedROF	= 1.16					-- Increased SG base rate of fire from upgrades
kShotgunFireRate = 0.70						-- To prevent fire rate cap from triggering
kShotgunClipSize = 6						-- Default is 6
kShotgunUpgradedReloadSpeed = 1.5

-- MG
kHeavyMachineGunDamage = 13					-- Default is 9 (*)
kHeavyMachineGunClipSize = 100				-- Default is 125
kHeavyMachineGunUpgradedClipSize = 125
kHeavyMachineGunSpread = Math.Radians(3.1)	-- Default is 4
kHeavyMachineGunReloadSpeed = 1				-- Dont ask.....
kHeavyMachineGunUpgReloadSpeed = 1.5
kHeavyMachineGunDamageType = kDamageType.HalfStructural

-- PISTOL
kPistolDamage = 20							-- Decreased from 25
kPistolDamageType = kDamageType.Normal		-- Default is Light

-- FLAMETHROWER
kFlamethrowerDamage = 18					-- Increased from 12
kFlamethrowerDamageRadius = 0.5				-- Decreased from 1.8 (NOT USED)
kFlamethrowerConeWidth = 0.08				-- Default is 0.3
kFlamethrowerClipSize = 100					-- Increased from 50
kFlamethrowerRange = 8						-- Decreased from 9
kFlamethrowerUpgradedRange = 10
kFlameThrowerEnergyDamage = 1				-- Default is 1
kFlamethrowerDamageType = kDamageType.Normal-- Default is Flame
kBurnDamagePerSecond = 10
kFlamethrowerBurnDuration = 0.25
kFlamethrowerMaxBurnDuration = 20
--kFlamethrowerDamagePerSecond = 25

-- SIGHHHHHHHHHHHHHHHHHHHH
kSprayDouseOnFireChance = 1.01

-- GL
kGrenadeLauncherGrenadeDamage = 80			-- Decreased from 165
kGrenadeLauncherClipSize = 4				-- Default is 4
kGrenadeLauncherGrenadeDamageRadius = 3.5	-- Decreased from 4.8
kGrenadeLifetime = 2.0						-- Default is 2
kGrenadeLauncherSpeed = 30					-- Increased from 25
kGrenadeLauncherGrenadeDamageType = kDamageType.TripleStructural

kGrenadeFragmentDamageRadius = 3.5
kGrenadeFragmentDamage = 20

-- CLUSTER GRENADES
kClusterGrenadeDamageType = kDamageType.Structural
kClusterGrenadeBurnTime = 2.0

-- PULSE GRENADES
kPulseGrenadeDamageRadius = 6
kPulseGrenadeDamage = 120

-- GAS GRENADES
kNerveGasDamagePerSecond = 50
kNerveGasDamageType = kDamageType.NerveGas

-- MINIGUN
kMinigunDamage = 6							-- This sounds really weak, but its actually only a little less DPS vs MG
kMinigunDamageType = kDamageType.Normal
kMinigunHeatUpRate = 0.175
kMinigunCoolDownRate = 0.25
kMinigunBulletSize = 0.02
kMinigunSpread = Math.Radians(3.1)

-- RAILGUN
kRailgunDamage = 22							-- Default is 10
kRailgunBulletsPerShot = 4
kRailgunDamageType = kDamageType.Normal
kRailgunBulletSize = 0.016
kRailgunMaxAmmo = 6
kRailgunRegenAmmoRate = 2.25
kRailgunMaxRange = 20
kRailgunDropOffStartRange = 10
kRailgunSpreadDistance = 4

-- MINES
kMineDamage = 110
kMineDamageType = kDamageType.Normal
kMineArmingTime = 0.03						-- Default is 0.17
kMinesPerPlayerLimit = 99
kNumMines = 2								-- Increased from 3

-- WELDER
kWelderStructureDamagePerSecond = 25
kWelderDamageType = kDamageType.Normal
kWelderDamagePerSecond = 30
kWelderFriendlyRange = 2.4
kWelderAttackRange = 1.7
kSelfWeldAmount = 5
kPlayerArmorWeldRate = 30					-- Default is 20
kExoArmorWeldRate = 25
kStructureWeldRate = 120					-- Default is 90

-- EXO
kExoShieldMinFuel = 0.99
kExoShieldDamageReductionScalar = 0.75
kExoShieldFuelUsageRate = 2

kExoRepairMinFuel = 0.1
kExoRepairPerSecond = 15
kExoRepairFuelUsageRate = 25
kExoRepairInterval = 0.5

kExoFuelRechargeRate = 10
kMinigunFuelUsageScalar = 1
kRailgunFuelUsageScalar = 1.5