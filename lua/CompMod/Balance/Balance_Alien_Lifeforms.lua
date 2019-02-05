-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Balance\Balance_Alien_Lifeforms.lua
-- - Dragon

kGorgeCost = 10								-- Decreased from 8
kLerkCost = 15								-- Decreased from 21
kFadeCost = 25								-- Decreased from 37
kOnosCost = 35								-- Decreased from 62

kSkulkUpgradeCost = 0						-- Default is 0
kGorgeUpgradeCost = 1						-- Default from 1
kLerkUpgradeCost = 2						-- Decreased from 3
kFadeUpgradeCost = 3						-- Decreased from 5
kOnosUpgradeCost = 4						-- Decreased from 8

kElectrifiedEnergyRecuperationScalar = 1	-- Increased from 0.7

kUpgradeGestationTime = 2					-- Default is 2
kUpgradeSwapGestateTime = 2					-- This is additional time spent gestating when swapping upgrades
kSkulkGestateTime = 3						-- Default is 3
kGorgeGestateTime = 7						-- Default is 7
kLerkGestateTime = 10						-- Default is 15
kFadeGestateTime = 13						-- Default is 25
kOnosGestateTime = 16						-- Default is 30

kSkulkAdrenalineRecuperationScalar = 0.4
kGorgeAdrenalineRecuperationScalar = 0.3
kLerkAdrenalineRecuperationScalar = 0.6
kFadeAdrenalineRecuperationScalar = 0.8
kOnosAdrenalineRecuperationScalar = 0.5

kCelerityAddSpeed = 1.8						-- Default is 1.5

kAlienCrushDamagePercentByLevel = 0.07		-- Default is 0.07

kParasiteDuration = 30						-- Default is 44

-- SPIT
kSpitDamage = 30
kSpitDamageType = kDamageType.Normal		-- Default is light
kSpitEnergyCost = 7

-- HEALSPRAY
kHealsprayDamageType = kDamageType.Biological

-- LERK HEALING ROOST
kHealingRoostHealthRegain = 5

-- SPIKES
kSpikeMaxDamage = 14						-- Increased from 7 with damage type rework
kSpikeMinDamage = 14						-- Increased from 7 with damage type rework
kLerkSpikeSpread = Math.Radians(3.1)
kSpikeDamageType = kDamageType.HalfStructural

-- SPORES
kSporesDamageType = kDamageType.Normal		-- Changed from GAS to normal
kSporesDustDamagePerSecond = 20				-- Increased from 15 to 20
kSporesDustFireDelay = 0.36
kSporesMaxRange = 17
kSporesDustEnergyCost = 27

-- STOMP
kStompEnergyCost = 30
kStompDamageType = kDamageType.Normal  		-- Changed from heavy to normal
kStompDamage = 40
kStompRange = 12

-- SWIPE
kSwipeDamageType = kDamageType.HalfStructural		-- Changed from structuresonlylight to normal
kSwipeDamage = 75
kSwipeEnergyCost = 7

-- GORE
kGoreDamage = 75
kGoreDamageType = kDamageType.Structural

-- RAGE
kOnosRageLifetime = 5
kOnosRageUniqueStructureHit = 0.08
kOnosRageUniqueHit = 0.04
kOnosRageUniqueDamage = 0.015
kOnosRageStructureHit = 0.04
kOnosRageOnHit = 0.020
kOnosRageDamage = 0.0075
kOnosRageGracePeriod = 3
kOnosRageSourceTimeout = 2

kOnosRageRegenerationRate = 0.06
kOnosRageRegenerationTime = 1
kOnosMaxRageAttackSpeedIncrease = 0.4
kOnosBonusRageSpeed = 1

kOnosHealRatePercentLimit = 0.125
kOnosHealRateOverLimitReduction = 0.25