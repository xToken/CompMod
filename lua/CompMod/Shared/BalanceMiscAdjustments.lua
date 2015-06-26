// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\BalanceMiscAdjustments.lua
// - Dragon

kCystMaturationTime = 90 				// Comp Mod change, decreased from 180.
kPhaseGateDepartureRate = 0.5	   		// Comp Mod change, added this value to control phase gate departures.
kCorrodeDamagePlayerArmorScalar = 0.12	// Comp Mod change, lowered from 0.23.
//kJetpackingAccel = 0.8				// Comp Mod change, unchanged.
//kJetpackUseFuelRate = .21				// Comp Mod change, unchanged.
//kJetpackReplenishFuelRate = .11		// Comp Mod change, unchanged.
kPulseGrenadeAutoDetonateRange = 1  	// Comp Mod change, decreased from 3.
//kWeaponStayTime = 25    				// Comp Mod change, decreased from 30.
//kStructureLightHealthPerArmor = 9		// Comp Mod change, increased from 4 to 9.
//kStructureLightArmorUseFraction = 0.9	// Comp Mod change, increased from .7
kFadeAirFriction = 0.14					// Comp Mod change, removed celerity air friction decreases, changed default to match - down from 0.17.
kHallucinationCloudCooldown = 5			// Comp Mod change, increased from 3 seconds.
//kChargeEnergyCost = 30 				// Comp Mod change, unchanged.
kReplaceUpgradeGestationTime = 4		// Comp Mod change, added this.
//kGrenadeAnimationSpeedIncrease = 2.75	// Comp Mod change, added this.
kTunnelEntranceMaturationTime = 120		// Comp Mod change, lowered this from 135 seconds.
kNumWebsPerGorge = 4					// Comp Mod change, lowered this from 10.
kWebHardenTime = 1.5					// Comp Mod change, added this.

kAlienHealRateTimeLimit = 2				// Comp Mod change, added alien healing rate limit.  This is the window in which heals are monitored and limited.
//kAlienHealRateLimit = 1000			// Comp Mod change, added alien healing rate limit.  This is a purely numerical limit, not used atm.
kAlienHealRatePercentLimit = .16		// Comp Mod change, added alien healing rate limit.  This is the limit currently in-place.
kAlienHealRateOverLimitReduction = 0.2	// Comp Mod change, added alien healing rate limit.  This is what the healing is scaled against when limited.
//kOnFireHealingScalar = 0.5			// Comp Mod change, unchanged.

Marine.kRunMaxSpeed = 5.75				// Comp Mod change, decreased from 6.
kMarineMaxSlowWalkSpeed = 2.5			// Comp Mod change, added this.
kLerkWallGripMaxSpeed = 2				// Comp Mod change, maximum speed for WallGrip.
kLerkAirFrictionMinSpeed = 7			// Comp Mod change, added increasing air friction.	Minimum speed to still have below bleeds applied.
kLerkAirFrictionBleedAmount = 0.2		// Comp Mod change, added increasing air friction.	Max amount of increased air friction to apply.
kLerkGlideAccelBleedTime = 1.0			// Comp Mod change, added increasing air friction.  Glide accel is lowered over this period of time after last flap.
kLerkGlideAccelBleedAmount = 4			// Comp Mod change, added increasing air friction.	Max amount of glide accel to bleed.

Grenade.kMinLifeTime = 0				// Comp Mod change, lowered from 0.15

kARCSpeedBoostCost = 2					// Comp Mod change, added ARC Speed Boost.
kARCSpeedBoostDuration = 6				// Comp Mod change, added ARC Speed Boost.
kARCSpeedBoostIncrease = 1.2			// Comp Mod change, added ARC Speed Boost.
kARCSpeedBoostTurnRate = math.pi * 1.2	// Comp Mod change, added ARC Speed Boost.
kARCSpeedBoostCooldown = 12				// Comp Mod change, added ARC Speed Boost.

//Onos Charge secondary global.
//Onos.kChargeEnergyCost = kChargeEnergyCost // Really? Move a global into a global?