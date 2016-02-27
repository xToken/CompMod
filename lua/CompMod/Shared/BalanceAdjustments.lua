// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\BalanceAdjustments.lua
// - Dragon

//kResearchBioMassOneCost = 15 			// Comp Mod change, unchanged.
//kResearchBioMassTwoCost = 20 			// Comp Mod change, unchanged.

kHarvesterCost = 12						// Comp Mod change, increased from 8.
//kShellCost = 15 						// Comp Mod change, unchanged.
kCragCost = 15 							// Comp Mod change, increased from 13.
//kSpurCost = 15 						// Comp Mod change, unchanged.
kShiftCost = 15 						// Comp Mod change, increased from 13.
//kVeilCost = 15 						// Comp Mod change, unchanged.
kShadeCost = 15 						// Comp Mod change, increased from 15.
kWhipCost = 15 							// Comp Mod change, increased from 15.

//kNutrientMistCost = 2 				// Comp Mod change, increased from 1.

//kMucousShieldCooldown = 5 			// Comp Mod change, unchanged.
//kMucousShieldPercent = 0.15			// Comp Mod change, unchanged.
//kMucousShieldDuration = 3				// Comp Mod change, unchanged.

//kMarineInitialIndivRes = 20 			// Comp Mod change, unchanged.
//kAlienInitialIndivRes = 15			// Comp Mod change, unchanged.

//kLerkCost = 20						// Comp Mod change, unchanged.
//kFadeCost = 35						// Comp Mod change, unchanged.
//kOnosCost = 55						// Comp Mod change, unchanged.

kDualExosuitCost = 35				// Comp Mod change, lowered pres cost from 60.
kDualRailgunExosuitCost = 35		// Comp Mod change, lowered pres cost from 60.
kExosuitTechResearchCost = 25		// Comp Mod change, increased from 20 tres.

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
kUmbraOnFireReduction = 0.50		// Comp Mod change, added this.

//kMetabolizeEnergyCost = 25			// Comp Mod change, unchanged.
//kMetabolizeDelay = 2.0				// Comp Mod change, unchanged.
//kMetabolizeAnimationDelay = 0.65		// Comp Mod change, unchanged.
//kMetabolizeEnergyRegain = 35			// Comp Mod change, unchanged.
//kMetabolizeHealthRegain = 15			// Comp Mod change, unchanged.

//kSwipeDamageType = kDamageType.StructuresOnlyLight	// Comp Mod change, unchanged.
//kSwipeDamage = 75										// Comp Mod change, unchanged.

//kBoneShieldDamageReduction = 0.25		// Comp Mod change, unchanged.
kGoreDamage = 90						// Comp Mod change, decreased from 100.
kGoreEnergyCost = 10					// Comp Mod change, decreased from 12.

//kSporesDustDamagePerSecond = 20		// Comp Mod change, unchanged.
kSporesDustFireDelay = 1			// Comp Mod change, increased from 0.36.
kSporesDustEnergyCost = 30			// Comp Mod change, increased from 8.
kSporesDustCloudRadius = 5			// Comp Mod change, increased from 2.5.
kSporesDustCloudLifetime = 5		// Comp Mod change, decreased from 8.
kSporesMaxCloudRange = 20			// Comp Mod change, added ranged spores.
kSporesTravelSpeed = 60				// Comp Mod change, ranged spores cloud speed.

kXenocideRange = 10					// Comp Mod change, decreased from 10.

kNanoShieldCost = 3					// Comp Mod change, decreased from 5.
//kAdvancedArmoryUpgradeCost = 20	// Comp Mod change, unchanged.
kPrototypeLabCost = 30				// Comp Mod change, lowered from 40.
kArmsLabCost = 20					// Comp Mod change, increased to 20.

kHeavyMachineGunTechResearchCost = 15	// Comp Mod change, increased from 15.
kHeavyMachineGunTechResearchTime = 60	// Comp Mod change, increased from 30.
kGrenadeLauncherTechResearchCost = 10	// Comp Mod change, added GL research.
kGrenadeLauncherTechResearchTime = 30	// Comp Mod change, added GL research.
kFlamethrowerTechResearchCost = 10		// Comp Mod change, added FT research.
kFlamethrowerTechResearchTime = 30		// Comp Mod change, added FT research.

//kGrenadeTechResearchCost = 10			// Comp Mod change, unchanged.
kGrenadeTechResearchTime = 30			// Comp Mod change, lowered from 45.

kFlamethrowerCost = 10				// Comp Mod change, decreased from 25.
kClusterGrenadeCost = 1				// Comp Mod change, lowered from 3.
kGasGrenadeCost = 1					// Comp Mod change, lowered from 3.
kPulseGrenadeCost = 1				// Comp Mod change, lowered from 3.
kMaxHandGrenades = 2				// Comp Mod change, 2 max grenades.
kPurchasedHandGrenades = 1			// Comp Mod change, 1 grenade from armory.

//kFlamethrowerAttackCone = 0.15		// Comp Mod change, lowered from 0.17.
//kBurnDamagePerSecond = 0			// Comp Mod change, lowered from 2.
//kFlameThrowerEnergyDamage = 0		// Comp Mod change, lowered from 3. 
//kOnFireEnergyRecuperationScalar = 0.5	// Comp Mod change, lowered from 1.
//kFlamethrowerBurnDuration = 5		// Comp Mod change, lowered from 6.
//kFlamethrowerClipSize = 30			// Comp Mod change, lowered from 50.
//kFlamethrowerDamage = 10			// Comp Mod change, lowered to 10.
//kFlamethrowerRange = 8				// Comp Mod change, lowered from 9.

//kLayMineWeight = 0.10					// Comp Mod change, unchanged.
//kWelderStructureDamagePerSecond = 50	// Comp Mod change, added this for adjusted welder.
//kWelderDamagePerSecond = 30			// Comp Mod change, unchanged.
//kWelderFriendlyRange = 2.4			// Comp Mod change, unchanged.
//kWelderAttackRange = 1.7				// Comp Mod change, added this.

kHeavyMachineGunDamage = 7.0		// Comp Mod change, added HMG.
kHeavyMachineGunDamageType = kDamageType.Puncture	// Comp Mod change, added HMG.
kHeavyMachineGunClipSize = 100		// Comp Mod change, added HMG.
kHeavyMachineGunWeight = 0.21		// Comp Mod change, added HMG.
kHeavyMachineGunCost = 20			// Comp Mod change, added HMG.
kHeavyMachineGunDropCost = 25		// Comp Mod change, added HMG.
kHeavyMachineGunPointValue = 7		// Comp Mod change, added HMG.
kHeavyMachineGunSpread = Math.Radians(3.8)	// Comp Mod, added this for HMG.

kMinigunDamage = 20						// Comp Mod change, decreased from 22.
kRailgunDamage = 30						// Comp Mod change, decreased from 33.
kRailgunChargeDamage = 130				// Comp Mod change, decreased from 140.

//kCystBuildTime = 4					// Comp Mod change, decreased from 5.
kCatPackDuration = 8					// Comp Mod change, decreased from 12.
kCatPackCooldown = 8					// Comp Mod change, added this.  Note - this includes the catpacks duration, so effectivly no CD currently.

Rupture.kDuration = 2.5					// Comp Mod change, lowered from 3.

kCystRedeployRange = 7					// Comp Mod change, increased from 6.
kMaxCystScalingDistance = 175			// Comp Mod change, cysts have less HP further from hive.
kMinCystScalingDistance = 25			// Comp Mod change, cysts have less HP further from hive.
kMinCystMatureHealth = 200				// Comp Mod change, cysts have less HP further from hive.

// Comp Mod changes to alien tech tree below, cost and new additions.

//kLeapResearchCost = 15				// Comp Mod change, unchanged.
//kLeapResearchTime = 40				// Comp Mod change, unchanged.
//kXenocideResearchCost = 25			// Comp Mod change, unchanged.
//kXenocideResearchTime = 60			// Comp Mod change, unchanged.

kBabblersResearchCost = 10				// Comp Mod change, added this.
kBabblersResearchTime = 45				// Comp Mod change, added this.
//kBileBombResearchCost = 15			// Comp Mod change, unchanged.
//kBileBombResearchTime = 40			// Comp Mod change, unchanged.
//kWebResearchCost = 10					// Comp Mod change, unchanged.
//kWebResearchTime = 60					// Comp Mod change, unchanged.

//kUmbraResearchCost = 20				// Comp Mod change, unchanged.
//kUmbraResearchTime = 45				// Comp Mod change, unchanged.
//kSporesResearchCost = 20				// Comp Mod change, unchanged.
//kSporesResearchTime = 60				// Comp Mod change, unchanged.

//kMetabolizeEnergyResearchCost = 20	// Comp Mod change, unchanged.
//kMetabolizeEnergyResearchTime = 40	// Comp Mod change, unchanged.
//kMetabolizeHealthResearchCost = 20	// Comp Mod change, unchanged.
//kMetabolizeHealthResearchTime = 45	// Comp Mod change, unchanged.
//kStabResearchCost = 25				// Comp Mod change, unchanged.
//kStabResearchTime = 60				// Comp Mod change, unchanged.

//kChargeResearchCost = 15				// Comp Mod change, unchanged.
//kChargeResearchTime = 40				// Comp Mod change, unchanged.
//kBoneShieldResearchCost = 20			// Comp Mod change, unchanged.
//kBoneShieldResearchTime = 40			// Comp Mod change, unchanged.
//kStompResearchCost = 25				// Comp Mod change, unchanged.
//kStompResearchTime = 60				// Comp Mod change, unchanged.

/*Apply Umbra Changes - Since also modding Umbra DR now, DONT do this.
local kUmbraModifier = GetUpValue( UmbraMixin.ModifyDamageTaken,   "kUmbraModifier" )
kUmbraModifier["Shotgun"] = kUmbraShotgunModifier
kUmbraModifier["Rifle"] = kUmbraBulletModifier
kUmbraModifier["Pistol"] = kUmbraBulletModifier
kUmbraModifier["Sentry"] = kUmbraBulletModifier
kUmbraModifier["HeavyMachineGun"] = kUmbraBulletModifier
kUmbraModifier["Minigun"] = kUmbraMinigunModifier
kUmbraModifier["Railgun"] = kUmbraRailgunModifier
*/

//Fade swipe damage.
//SwipeBlink.kDamage = kSwipeDamage		// Really? Move a global into a Global?

kEnergyRegenRate = 1					// Comp Mod change, added energy - 1/s.
kMarineStartingEnergy = 20				// Comp Mod change, added energy
kMarineStructureMaxEnergy = 40			// Comp Mod change, added energy