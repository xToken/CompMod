//Dont want to always replace random files, so this.

Script.Load("lua/EvolutionChamber.lua")
Script.Load("lua/FunctionReplaces_Shared.lua")

//Balance.lua changes

kResearchBioMassOneCost = 15 		// Comp Mod change, decreased from 20
kResearchBioMassTwoCost = 20 		// Comp Mod change, decreased from 30
kShellCost = 15 					// Comp Mod change, decreased from 20
kCragCost = 13 						// Comp Mod change, increased from 10
kSpurCost = 15 						// Comp Mod change, decreased from 20
kShiftCost = 13 					// Comp Mod change, increased from 10
kVeilCost = 15 						// Comp Mod change, decreased from 20
kShadeCost = 13 					// Comp Mod change, increased from 10
kWhipCost = 13 						// Comp Mod change, increased from 10
kStartBlinkEnergyCost = 14 			// Comp Mod change, unchanged.
kUpgradeSkulkResearchCost = 15 		// Comp Mod change, decreased from 20
kUpgradeGorgeResearchCost = 20 		// Comp Mod change, decreased from 30
kUpgradeLerkResearchCost = 25 		// Comp Mod change, decreased from 35
kUpgradeFadeResearchCost = 25 		// Comp Mod change, decreased from 35
kUpgradeOnosResearchCost = 30 		// Comp Mod change, decreased from 35
kNutrientMistCost = 2 				// Comp Mod change, increased from 1.
kMarineInitialIndivRes = 20 		// Comp Mod change, aliens and marines start with different Pres values.
kAlienInitialIndivRes = 15			// Comp Mod change, aliens and marines start with different Pres values.
kLerkCost = 20						// Comp Mod change, lowered pres cost from 25.
kFadeCost = 35						// Comp Mod change, lowered pres cost from 40.
kOnosCost = 55						// Comp Mod change, lowered pres cost from 60.
kGorgeTunnelCost = 3				// Comp Mod change, lowered tunnels cost and HP.
kNumBabblerEggsPerGorge = 2			// Comp Mod change, adjusted babblers per egg and cost, down from 3.
kNumBabblersPerEgg = 5				// Comp Mod change, adjusted babblers per egg and cost, up from 3.
kHydraCost = 2						// Comp Mod change, lowered hydra cost from 3.
kWebBuildCost = 0					// Comp Mod change, lowered web cost from 1.
kUmbraDuration = 4					// Comp Mod change, lowered duration to 4 from 5.
kUmbraRadius = 4					// Comp Mod change, lowered radius from 6 to 4.
kUmbraShotgunModifier = 0.75		// Comp Mod change, decreased reduction from .36 to .25.
kUmbraBulletModifier = 0.75			// Comp Mod change, unchanged.
kUmbraMinigunModifier = 0.75		// Comp Mod change, decreased reduction from .3 to .25.
kUmbraRailgunModifier = 0.75		// Comp Mod change, decreased reduction from .32 to .25.
////////////////////////////////// TEST THE UMBRA CHANGE - might be cached into local causing this to NOT work.
kMetabolizeEnergyCost = 25			// Comp Mod change, added metabolize.
kMetabolizeDelay = 2.0				// Comp Mod change, added metabolize.
kMetabolizeEnergyRegain = 35		// Comp Mod change, added metabolize.
kMetabolizeHealthRegain = 10		// Comp Mod change, added metabolize.
kSwipeDamageType = kDamageType.StructuresOnlyLight	// Comp Mod change, changed fade damage type.
kSwipeDamage = 75					// Comp Mod change, changed to maintain same damage.
SwipeBlink.kDamage = kSwipeDamage	// Really? Move a global into a Global?
kBoneShieldDamageReduction = 0.25	// Comp Mod change, bone shield blocks 75% of damage.
kGoreDamage = 90					// Comp Mod change, decreased from 100.
kGoreEnergyCost = 10				// Comp Mod change, decreased from 12.
kNanoShieldCost = 3					// Comp Mod change, decreased from 5.
kAdvancedArmoryUpgradeCost = 20		// Comp Mod change, decreased from 30.
kFlamethrowerCost = 20				// Comp Mod change, decreased from 25.
kLayMineWeight = 0.10				// Comp Mod change, decreased from 0.19.

// Comp Mod changes to alien tech tree below, cost and new additions.

kLeapResearchCost = 15				// Comp Mod change, decreased from 20.
kLeapResearchTime = 40				// Comp Mod change, unchanged.
kXenocideResearchCost = 25			// Comp Mod change, increased from 15.
kXenocideResearchTime = 60			// Comp Mod change, unchanged.

kBabblersResearchCost = 10			// Comp Mod change, added this.
kBabblersResearchTime = 45			// Comp Mod change, added this.
kBileBombResearchCost = 15			// Comp Mod change, unchanged.
kBileBombResearchTime = 40			// Comp Mod change, unchanged.
kWebResearchCost = 10				// Comp Mod change, decreased from 15.
kWebResearchTime = 60				// Comp Mod change, unchanged.

kUmbraResearchCost = 20				// Comp Mod change, unchanged.
kUmbraResearchTime = 45				// Comp Mod change, unchanged.
kSporesResearchCost = 20			// Comp Mod change, unchanged.
kSporesResearchTime = 60			// Comp Mod change, unchanged.

kMetabolizeEnergyResearchCost = 15	// Comp Mod change, added this.
kMetabolizeEnergyResearchTime = 40	// Comp Mod change, added this.
kMetabolizeHealthResearchCost = 20	// Comp Mod change, added this.
kMetabolizeHealthResearchTime = 45	// Comp Mod change, added this.
kStabResearchCost = 25				// Comp Mod change, increased from 25.
kStabResearchTime = 60				// Comp Mod change, unchanged.

kChargeResearchCost = 15			// Comp Mod change, increased from 10.
kChargeResearchTime = 40			// Comp Mod change, unchanged.
kBoneShieldResearchCost = 20		// Comp Mod change, increased from 15.
kBoneShieldResearchTime = 40		// Comp Mod change, decreased from 60.
kStompResearchCost = 25				// Comp Mod change, increased from 20.
kStompResearchTime = 60				// Comp Mod change, unchanged.

//BalanceHealth.lua changes

kObservatoryHealth = 700			// Comp Mod change, lowered from 1700.
kObservatoryArmor = 500				// Comp Mod change, increased from 0.
kPhaseGateHealth = 1500				// Comp Mod change, lowered from 3100.
kPhaseGateArmor = 800				// Comp Mod change, increased from 0.
kInfantryPortalHealth = 1525		// Comp Mod change, lowered from 2250.
kInfantryPortalArmor = 500			// Comp Mod change, increased from 125.
kArmsLabHealth = 1650				// Comp Mod change, lowered from 2200.
kArmsLabArmor = 500					// Comp Mod change, increased from 225.
kPrototypeLabHealth = 3000			// Comp Mod change, decreased from 3200.
kPrototypeLabArmor = 500			// Comp Mod change, increased from 400 and fixed bug preventing this from applying.

kMatureCystHealth = 450 			// Comp Mod change, lowered Cyst HP from 550.
kTunnelEntranceHealth = 900			// Comp Mod change, lowered tunnels cost and HP.
kTunnelEntranceArmor = 0			// Comp Mod change, lowered tunnels cost and HP.
kMatureTunnelEntranceHealth = 1000	// Comp Mod change, lowered tunnels cost and HP.
kMatureTunnelEntranceArmor = 125	// Comp Mod change, lowered tunnels cost and HP.
kBoneWallHealth = 100				// Comp Mod change, lowered from 300.
kBoneWallArmor = 0					// Comp Mod change, lowered from 300.
kBoneWallHealthPerBioMass = 100		// Comp Mod change, added this value.
kBabblerHealth = 5					// Comp Mod change, decreased from 10.
kBabblerArmor = 0					// Comp Mod change, unchanged.

kAlienRegenerationPercentage = 0.07	// Comp Mod change, increased from 4%
kAlienMinRegeneration = 6			// Comp Mod change, currently unchanged.
kAlienMaxRegeneration = 80			// Comp Mod change, increased from 40.

//BalanceMisc.lua changes

kCystMaturationTime = 60 			// Comp Mod change, decreased from 180.
kPhaseGateDepartureRate = 0.5   	// Comp Mod change, added this value to control phase gate departures.
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
Onos.kChargeEnergyCost = kChargeEnergyCost // Really? Move a global into a global?
kAlienHealRateTimeLimit = 1			// Comp Mod change, added alien healing rate limit.
kAlienHealRateLimit = 100			// Comp Mod change, added alien healing rate limit.
kAlienHealRatePercentLimit = .1		// Comp Mod change, added alien healing rate limit.
kAlienHealRateOverLimitReduction = 1	// Comp Mod change, added alien healing rate limit.
