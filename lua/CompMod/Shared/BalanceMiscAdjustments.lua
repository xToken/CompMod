//BalanceMisc.lua changes

kCystMaturationTime = 60 			// Comp Mod change, decreased from 180.
kPhaseGateDepartureRate = 0.5	   	// Comp Mod change, added this value to control phase gate departures.
kCorrodeDamagePlayerArmorScalar = 0.12	// Comp Mod change, lowered from 0.23.
kJetpackingAccel = 0.8				// Comp Mod change, increased from 0.7.
kJetpackUseFuelRate = .21			// Comp Mod change, decreased from 0.23.
kJetpackReplenishFuelRate = .11		// Comp Mod change, decreased from 0.24.
kPulseGrenadeAutoDetonateRange = 1  // Comp Mod change, decreased from 3.
kWeaponStayTime = 25    			// Comp Mod change, decreased from 30.
kStructureLightHealthPerArmor = 9	// Comp Mod change, increased from 4 to 9.
kStructureLightArmorUseFraction = 0.9	// Comp Mod change, increased from .7
kFadeAirFriction = 0.14				// Comp Mod change, removed celerity air friction decreases, changed default to match - down from 0.17.
kHallucinationCloudCooldown = 5		// Comp Mod change, increased from 3 seconds.
kChargeEnergyCost = 30 				// Comp Mod change, decreased from 38.
kGrenadeAnimationSpeedIncrease = 2.75	// Comp Mod change, added this.

kAlienHealRateTimeLimit = 1			// Comp Mod change, added alien healing rate limit.
kAlienHealRateLimit = 100			// Comp Mod change, added alien healing rate limit.
kAlienHealRatePercentLimit = .1		// Comp Mod change, added alien healing rate limit.
kAlienHealRateOverLimitReduction = 1	// Comp Mod change, added alien healing rate limit.

kResBlockTimer = 60					// Comp Mod change, will adjust res accordingly on team switch within this window of gamestart.

//Onos Charge secondary global.
Onos.kChargeEnergyCost = kChargeEnergyCost // Really? Move a global into a global?