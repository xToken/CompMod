-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\FileHooks\Post\BalanceHealth.lua
-- - Dragon

kMarineHealth = 100							-- Vanilla is 100
kMarineArmor = 30							-- Vanilla is 30

kJetpackHealth = 100						-- Vanilla is 100
kJetpackArmor = 30							-- Vanilla is 30

kExosuitHealth = 100						-- Vanilla is 100
kExosuitArmor = 400							-- Vanilla is 320

kArmorPerUpgradeLevel = 20					-- Vanilla is 20
kExosuitArmorPerUpgradeLevel = 40			-- Vanilla is 30
kNanoArmorHealPerSecond = 5					-- Was 0.5
kNanoArmorHealInterval = 1

kSkulkHealth = 75							-- Vanilla is 75
kSkulkArmor = 10							-- Vanilla is 10
kSkulkArmorFullyUpgradedAmount = 25			-- Vanilla is 30
kSkulkHealthPerBioMass = 0					-- Vanilla is 3

kGorgeHealth = 250							-- Vanilla is 160
kGorgeArmor = 30							-- Vanilla is 75
kGorgeArmorFullyUpgradedAmount = 90			-- Vanilla is 100
kGorgeHealthPerBioMass = 0					-- Vanilla is 2

kLerkHealth = 200							-- Vanilla is 150
kLerkArmor = 20								-- Vanilla is 45
kLerkArmorFullyUpgradedAmount = 80			-- Vanilla is 60
kLerkHealthPerBioMass = 0					-- Vanilla is 2

kFadeHealth = 300							-- Vanilla is 250
kFadeArmor = 80								-- Vanilla is 80
kFadeArmorFullyUpgradedAmount = 170			-- Vanilla is 120
kFadeHealthPerBioMass = 0					-- Vanilla is 5

kOnosHealth = 800							-- Vanilla is 900
kOnosArmor = 450							-- Vanilla is 450
kOnosArmorFullyUpgradedAmount = 750			-- Vanilla is 650
kOnosHealtPerBioMass = 0					-- Vanilla is 30

kAlienRegenerationPercentage = 0.09			-- Vanilla is 0.08
kAlienMinRegeneration = 5					-- Vanilla is 6
kAlienMaxRegeneration = 120					-- Vanilla is 80

kMineHealth = 80							-- Vanilla is 20
kMineArmor = 10								-- Vanilla is 5

kArmsLabHealth = 1650						-- Vanilla is 1650
kArmsLabArmor = 500							-- Vanilla is 500

kDrifterHealth = 250						-- Vanilla is 300
kDrifterArmor = 0							-- Vanilla is 20

kHarvesterHealth = 1600						-- Vanilla is 2000
kHarvesterArmor = 100						-- Vanilla is 200
kMatureHarvesterHealth = 2200				-- Vanilla is 2300
kMatureHarvesterArmor = 300					-- Vanilla is 320

kHiveHealth = 4000							-- Vanilla is 4000
kHiveArmor = 1000							-- Vanilla is 750
kMatureHiveHealth = 6000					-- Vanilla is 6000
kMatureHiveArmor = 1500						-- Vanilla is 1400

kCragHealth = 400							-- Vanilla is 600
kCragArmor = 100							-- Vanilla is 200
kMatureCragHealth = 1000					-- Vanilla is 700
kMatureCragArmor = 200						-- Vanilla is 340

kShiftHealth = 450							-- Vanilla is 750
kShiftArmor = 75							-- Vanilla is 75
kMatureShiftHealth = 1100					-- Vanilla is 1100
kMatureShiftArmor = 150						-- Vanilla is 150

kShadeHealth = 500							-- Vanilla is 750
kShadeArmor = 50							-- Vanilla is 0
kMatureShadeHealth = 1200					-- Vanilla is 1500
kMatureShadeArmor = 100						-- Vanilla is 0

kShellHealth = 600							-- Vanilla is 600
kShellArmor = 150							-- Vanilla is 150
kMatureShellHealth = 700					-- Vanilla is 700
kMatureShellArmor = 200						-- Vanilla is 200
  
kWhipHealth = 650							-- Vanilla is 650
kWhipArmor = 175							-- Vanilla is 175
kMatureWhipHealth = 720						-- Vanilla is 720
kMatureWhipArmor = 240						-- Vanilla is 240
        
kSpurHealth = 800							-- Vanilla is 800
kSpurArmor = 50								-- Vanilla is 50
kMatureSpurHealth = 900						-- Vanilla is 900
kMatureSpurArmor = 100						-- Vanilla is 100

kVeilHealth = 900							-- Vanilla is 900
kVeilArmor = 0								-- Vanilla is 0
kMatureVeilHealth = 1100					-- Vanilla is 1100
kMatureVeilArmor = 0						-- Vanilla is 0

kCystHealth = 200
kCystArmor = 0
kMatureCystHealth = 650
kMatureCystArmor = 0

kMACHealth = 500							-- Vanilla is 300
kMACArmor = 0								-- Vanilla is 50

kHydraHealth = 650							-- Vanilla is 350
kHydraArmor = 100							-- Vanilla is 10

kMatureHydraHealth = 650					-- Vanilla is 450
kMatureHydraArmor = 100						-- Vanilla is 50

kBabblerHealth = 11							-- Vanilla is 10

kWebHealth = 40								-- Vanilla is 80

kInfestedPowerPointHealth = 2000
kInfestedPowerPointArmor = 500
kInfestedPowerPointValue = 10

kPowerPointHealth = 2000
kPowerPointArmor = 1000

kArmorHealScalar = 1						-- Vanilla is 1

kMaturityGracePeriod = 0					-- How long after the last mist before maturity starts decreasing
kMaturityStarvingThreshold = 0.3			-- Below this is 'staving'
kMaturityFlourishingThreshold = 0.85		-- Above this is 'mature'
kMaturityMinEffectivenessThreshold = 0.25	-- Minimum of this amount of effectiveness
kMaturityMaxEffectivenessThreshold = 0.85	-- After this, effectiveness no longer increases
kMaturityFlourishingEffectiveness = 2
kMaturityStartingLevel = 0

kMaturityBaseStarvationRate = -1/90			-- This is the base rate that maturity is lost at.
kMaturityBaseGainRate = 1/15				-- This is the base rate that maturity is gained at.