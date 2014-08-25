//BalanceMisc.lua changes

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

kAlienHealRateTimeLimit = 2				// Comp Mod change, added alien healing rate limit.  This is the window in which heals are monitored and limited.
//kAlienHealRateLimit = 1000			// Comp Mod change, added alien healing rate limit.  This is a purely numerical limit, not used atm.
kAlienHealRatePercentLimit = .16		// Comp Mod change, added alien healing rate limit.  This is the limit currently in-place.
kAlienHealRateOverLimitReduction = 0.2	// Comp Mod change, added alien healing rate limit.  This is what the healing is scaled against when limited.
//kOnFireHealingScalar = 0.5			// Comp Mod change, unchanged.

Marine.kRunMaxSpeed = 5.75				// Comp Mod change, decreased from 6.
kLerkFlySoundUpdateRate = 0.1			// Comp Mod change, how often lerk glide sound updates.
kLerkFlySoundMinSpeed = 6				// Comp Mod change, minimum speed for sound.
kLerkAirBrakeSpeedDecrease = 8			// Comp Mod change, added lerk air brake.
kLerkWallGripMaxSpeed = 2				// Comp Mod change, maximum speed for WallGrip.

Grenade.kMinLifeTime = 0				// Comp Mod change, lowered from 0.15

//Onos Charge secondary global.
//Onos.kChargeEnergyCost = kChargeEnergyCost // Really? Move a global into a global?