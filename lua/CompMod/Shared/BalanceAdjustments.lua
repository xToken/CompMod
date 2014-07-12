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

kNutrientMistCost = 2 				// Comp Mod change, increased from 1.

kMucousShieldCooldown = 5 			// Comp Mod change, added this.
kMucousShieldPercent = 0.15			// Comp Mod change, added this.
kMucousShieldDuration = 3			// Comp Mod change, added this.

kMarineInitialIndivRes = 20 		// Comp Mod change, aliens and marines start with different Pres values.
kAlienInitialIndivRes = 15			// Comp Mod change, aliens and marines start with different Pres values.

kLerkCost = 20						// Comp Mod change, lowered pres cost from 25.
kFadeCost = 35						// Comp Mod change, lowered pres cost from 40.
kOnosCost = 55						// Comp Mod change, lowered pres cost from 60.

kExosuitCost = 25					// Comp Mod change, lowered pres cost from 40.
kExosuitScale = 0.85				// Comp Mod change, scaled down exos a bit.

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

kMetabolizeEnergyCost = 25			// Comp Mod change, added metabolize.
kMetabolizeDelay = 2.0				// Comp Mod change, added metabolize.
kMetabolizeAnimationDelay = 0.65	// Comp Mod change, added metabolize.
kMetabolizeEnergyRegain = 35		// Comp Mod change, added metabolize.
kMetabolizeHealthRegain = 15		// Comp Mod change, added metabolize.

kSwipeDamageType = kDamageType.StructuresOnlyLight	// Comp Mod change, changed fade damage type.
kSwipeDamage = 75					// Comp Mod change, changed to maintain same damage.

kBoneShieldDamageReduction = 0.25	// Comp Mod change, bone shield blocks 75% of damage.
kGoreDamage = 90					// Comp Mod change, decreased from 100.
kGoreEnergyCost = 10				// Comp Mod change, decreased from 12.

//kSporesDustDamagePerSecond = 20		// Comp Mod change, unchanged.
kSporesDustFireDelay = 1			// Comp Mod change, increased from 0.36.
kSporesDustEnergyCost = 30			// Comp Mod change, increased from 8.
kSporesDustCloudRadius = 5			// Comp Mod change, increased from 2.5.
kSporesDustCloudLifetime = 5		// Comp Mod change, decreased from 8.
kSporesMaxCloudRange = 20			// Comp Mod change, added ranged spores.
kSporesTravelSpeed = 60				// Comp Mod change, ranged spores cloud speed.

kXenocideRange = 10					// Comp Mod change, decreased from 10.

kNanoShieldCost = 3					// Comp Mod change, decreased from 5.
kAdvancedArmoryUpgradeCost = 20		// Comp Mod change, decreased from 30.

kHeavyMachineGunTechResearchCost = 20	// Comp Mod change, added HMG research.
kHeavyMachineGunTechResearchTime = 30	// Comp Mod change, added HMG research.
kGrenadeLauncherTechResearchCost = 10	// Comp Mod change, added GL research.
kGrenadeLauncherTechResearchTime = 30	// Comp Mod change, added GL research.
kFlamethrowerTechResearchCost = 10	// Comp Mod change, added FT research.
kFlamethrowerTechResearchTime = 30	// Comp Mod change, added FT research.

kFlamethrowerCost = 10				// Comp Mod change, decreased from 25.

kFlamethrowerAttackCone = 0.10		// Comp Mod change, lowered from 0.17.
kBurnDamagePerSecond = 0			// Comp Mod change, lowered from 2.
kFlameThrowerEnergyDamage = 0		// Comp Mod change, lowered from 3. 
kOnFireEnergyRecuperationScalar = 0.5	// Comp Mod change, lowered from 1.
kFlamethrowerBurnDuration = 5		// Comp Mod change, lowered from 6.
kFlamethrowerClipSize = 40			// Comp Mod change, lowered from 50.
kFlamethrowerDamage = 15			// Comp Mod change, unchanged.
kFlamethrowerRange = 8				// Comp Mod change, lowered from 9.

kLayMineWeight = 0.10				// Comp Mod change, decreased from 0.19.

kHeavyMachineGunDamage = 7.5			// Comp Mod change, added HMG.
kHeavyMachineGunDamageType = kDamageType.Puncture	// Comp Mod change, added HMG.
kHeavyMachineGunClipSize = 80		// Comp Mod change, added HMG.
kHeavyMachineGunWeight = 0.21		// Comp Mod change, added HMG.
kHeavyMachineGunCost = 20			// Comp Mod change, added HMG.
kHeavyMachineGunDropCost = 25		// Comp Mod change, added HMG.
kHeavyMachineGunPointValue = 7		// Comp Mod change, added HMG.
kHeavyMachineGunSpread = Math.Radians(3.8)	// Comp Mod, added this for HMG.

kMinigunDamage = 10
kMinigunDamageType = kDamageType.Heavy
kMinigunSpread = Math.Radians(5)	// Comp Mod, added this for minigun, decreased from 5.

kRailgunDamage = 75
kRailgunChargeDamage = 0
kRailgunDamageType = kDamageType.Structural
kRailgunCooldown = 1
kRailgunBulletSize = 0.1			

kCystBuildTime = 4					// Comp Mod change, decreased from 5.

Rupture.kDuration = 2.5				// Comp Mod change, lowered from 3.

// Comp Mod changes to alien tech tree below, cost and new additions.

kLeapResearchCost = 15				// Comp Mod change, decreased from 20.
//kLeapResearchTime = 40				// Comp Mod change, unchanged.
kXenocideResearchCost = 25			// Comp Mod change, increased from 15.
//kXenocideResearchTime = 60			// Comp Mod change, unchanged.

kBabblersResearchCost = 10			// Comp Mod change, added this.
kBabblersResearchTime = 45			// Comp Mod change, added this.
//kBileBombResearchCost = 15			// Comp Mod change, unchanged.
//kBileBombResearchTime = 40			// Comp Mod change, unchanged.
kWebResearchCost = 10				// Comp Mod change, decreased from 15.
//kWebResearchTime = 60				// Comp Mod change, unchanged.

//kUmbraResearchCost = 20				// Comp Mod change, unchanged.
//kUmbraResearchTime = 45				// Comp Mod change, unchanged.
//kSporesResearchCost = 20			// Comp Mod change, unchanged.
//kSporesResearchTime = 60			// Comp Mod change, unchanged.

kMetabolizeEnergyResearchCost = 20	// Comp Mod change, added this.
kMetabolizeEnergyResearchTime = 40	// Comp Mod change, added this.
kMetabolizeHealthResearchCost = 20	// Comp Mod change, added this.
kMetabolizeHealthResearchTime = 45	// Comp Mod change, added this.
kStabResearchCost = 25				// Comp Mod change, increased from 25.
//kStabResearchTime = 60				// Comp Mod change, unchanged.

kChargeResearchCost = 15			// Comp Mod change, increased from 10.
//kChargeResearchTime = 40			// Comp Mod change, unchanged.
kBoneShieldResearchCost = 20		// Comp Mod change, increased from 15.
kBoneShieldResearchTime = 40		// Comp Mod change, decreased from 60.
kStompResearchCost = 25				// Comp Mod change, increased from 20.
//kStompResearchTime = 60				// Comp Mod change, unchanged.

//Apply Umbra Changes
local kUmbraModifier = GetUpValue( UmbraMixin.ModifyDamageTaken,   "kUmbraModifier", { LocateRecurse = true } )
kUmbraModifier["Shotgun"] = kUmbraShotgunModifier
kUmbraModifier["Rifle"] = kUmbraBulletModifier
kUmbraModifier["Pistol"] = kUmbraBulletModifier
kUmbraModifier["Sentry"] = kUmbraBulletModifier
kUmbraModifier["HeavyMachineGun"] = kUmbraBulletModifier
kUmbraModifier["Minigun"] = kUmbraMinigunModifier
kUmbraModifier["Railgun"] = kUmbraRailgunModifier

//Fade swipe damage.
SwipeBlink.kDamage = kSwipeDamage	// Really? Move a global into a Global?