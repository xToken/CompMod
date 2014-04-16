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
// kStartBlinkEnergyCost = 11 		// Comp Mod change, reduced from 14.
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
kGorgeTunnelCost = 2				// Comp Mod change, lowered tunnels cost and HP.
kNumBabblerEggsPerGorge = 2			// Comp Mod change, adjusted babblers per egg and cost, down from 3.
kNumBabblersPerEgg = 5				// Comp Mod change, adjusted babblers per egg and cost, up from 3.
kHydraCost = 2						// Comp Mod change, lowered hydra cost from 3.
kWebBuildCost = 0					// Comp Mod change, lowered web cost from 1.
kUmbraDuration = 4					// Comp Mod change, lowered duration to 4 from 5.
kUmbraRadius = 4					// Comp Mod change, lowered radius from 6 to 4.
kMetabolizeEnergyCost = 25			// Comp Mod change, added metabolize.
kMetabolizeDelay = 2.0				// Comp Mod change, added metabolize.
kMetabolizeEnergyRegain = 35		// Comp Mod change, added metabolize.
kMetabolizeHealthRegain = 20		// Comp Mod change, added metabolize.
kSwipeDamageType = kDamageType.StructuresOnlyLight	// Comp Mod change, changed fade damage type.
kSwipeDamage = 75					// Comp Mod change, changed to maintain same damage.
SwipeBlink.kDamage = kSwipeDamage	// Really? Move a global into a Global?
kBoneShieldDamageReduction = 0.25	// Comp Mod change, bone shield blocks 75% of damage.
kGoreDamage = 90					// Comp Mod change, decreased from 100.
kNanoShieldCost = 3					// Comp Mod change, decreased from 5.
kAdvancedArmoryUpgradeCost = 20		// Comp Mod change, decreased from 30.
kFlamethrowerCost = 20				// Comp Mod change, decreased from 25.
kLayMineWeight = 0.10				// Comp Mod change, decreased from 0.19.

// Comp Mod changes to alien tech tree below, cost and new additions.
kLeapResearchCost = 15
kXenocideResearchCost = 25
kBabblersResearchCost = 5
kBabblersResearchTime = 60
kGorgeTunnelResearchCost = 15
kBileBombResearchCost = 15
kWebResearchCost = 10
kWebResearchTime = 60
kUmbraResearchCost = 20
kSporesResearchCost = 20
kShadowStepResearchCost = 15
kVortexResearchCost = 15
kMetabolizeEnergyResearchCost = 15
kMetabolizeEnergyResearchTime = 40
kMetabolizeHealthResearchCost = 15
kMetabolizeHealthResearchTime = 45
kStabResearchCost = 25
kChargeResearchCost = 15
kStompResearchCost = 25
kBoneShieldResearchCost = 20

//BalanceHealth.lua changes

kObservatoryHealth = 700			// Comp Mod change, lowered from 1700.
kObservatoryArmor = 500				// Comp Mod change, increased from 0.
kPhaseGateHealth = 2000				// Comp Mod change, lowered from 3100.
kPhaseGateArmor = 550				// Comp Mod change, increased from 0.
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
kBoneWallHealth = 100
kBoneWallArmor = 0
kBoneWallHealthPerBioMass = 100

kAlienRegenerationPercentage = 0.08	// Comp Mod change, increased from 4%
kAlienMinRegeneration = 6			// Comp Mod change, currently unchanged.
kAlienMaxRegeneration = 80			// Comp Mod change, increased from 40.

//BalanceMisc.lua changes

kCystMaturationTime = 60 			// Comp Mod change, decreased from 180.
kPhaseGateDepartureRate = 0.5   	// Comp Mod change, added this value to control phase gate departures.
kCorrodeDamagePlayerArmorScalar = 0.12	// Comp Mod change, lowered from 0.23.
kJetpackingAccel = 0.78				// Comp Mod change, increased from 0.7.
kJetpackUseFuelRate = .21			// Comp Mod change, decreased from 0.23.
kJetpackReplenishFuelRate = .11		// Comp Mod change, decreased from 0.24.
kPulseGrenadeAutoDetonateRange = 1  // Comp Mod change, decreased from 3.
kWeaponStayTime = 25    			// Comp Mod change, decreased from 30.
kStructureLightHealthPerArmor = 9	// Comp Mod change, increased from 4 to 9.
kStructureLightArmorUseFraction = 0.9	// Comp Mod change, increased from .7
kFadeAirFriction = 0.14				// Comp Mod change, removed celerity air friction decreases, changed default to match - down from 0.17