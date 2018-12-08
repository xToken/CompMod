-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\BalanceAdjustments.lua
-- - Dragon

-- SHOTGUN
kShotgunBulletsPerShot = 10					-- Lowered from 17
kShotgunSpreadDistance = 7					-- Lowered from 8.5 (See other adjustments in ShotgunAdjustments)
kShotgunDamage = 17							-- Increased from 10
kShotgunMaxRange = 16						-- Added max range (Damage drops to 1)
kShotgunDropOffStartRange = 5				-- Min range where damage falloff begins
kShotgunBaseROF	= 1.1						-- Increased SG base rate of fire
kShotgunFireRate = 0.82						-- To prevent fire rate cap from triggering

-- SKULK
Skulk.kMaxSpeed = 8.0						-- Increased from 7.25
Skulk.kWallJumpMaxSpeed = 11				-- No Change
Skulk.kWallJumpMaxSpeedCelerityBonus = 1.2	-- No Change

-- GORGE
Gorge.kMaxGroundSpeed = 6.75				-- Increased from 6

-- LERK
kLerkMaxSpeed = 13.25						-- Increased from 13

-- FADE
kFadeMaxSpeed = 6.5							-- Increased from 6.2
kFadeBlinkSpeed = 14.5						-- Increased from 14

-- ONOS
Onos.kMaxSpeed = 7.0						-- Increased from 6.6
Onos.kChargeSpeed = 13.0					-- Increased from 12.5

-- Marine
Marine.kWalkMaxSpeed = 5.6					-- Increased from 5.0

-- JetpackMarine
kJetpackFlySpeed = 10						-- Increased from 9.0

-- EXOS
kExoMaxSpeed = 6.00							-- Increased from 5.75

-- Harvester Cost
kHarvesterCost = 10							-- Increased from 8

-- Extractor Build Time
kExtractorBuildTime = 15					-- Increased from 11