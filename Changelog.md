# Changelog

### ProGMod R1 B6 (18-12-18)

##### Alien Changes:
- Gorge upgrades cost increased from 0 to 1
- Lerk upgrades cost increased from 0 to 3
- Fade cost increased from 20 to 25
- Fade upgrade cost increased from 0 to 5
- Onos cost increased from 25 to 40
- Onos upgrade cost increased from 0 to 8
- Onos base armor increased from 300 to 400

- Gorges can put out structures that are on fire 100% of the time.

- Focus attack speed cooldown now scales with Veil levels (Focus will be revisted soon!)

- Hydra RoF normalized to 1/s
- Hydra damage increased from 15 to 20

- Crag minimum healing decreased from 5 to 4
- Crag HealWave duration lowered from 10 to 6
- Crag HealWave cost lowered from 3 to 2

- Shift passive energize effect only provides 7 energy per second
- Shift has an active ability to provide energy at the original rate.
- Costs 2 tRes, lasts for 6s with 6s cooldown

- Shade ink cooldown/duration reverted to vanilla (16/6.3 seconds)

- Drifter 'abilities' moved back to drifter.
- MucousMembrane radius increased from 2 to 6
- Enzyme radius increased from 2 to 6
- HallucinationCloud radius increased from 1 to 6
- Max Hallucinations increased back to 34% of TeamSize (to match Vanilla)

- Harvester base health lowered from 2000 to 1800
- Harvester base armor lowered from 100 to 10
- Harvester max health lowered from 2200 to 2000
- Harvester max armor lowered from 250 to 200

##### Marine Changes:
- Arms Lab HP reverted to vanilla (1650/500)
- Arms Lab no longer requires Armory
- Only 1 Arms Lab required for each upgrade type (Weapons/Armor)
- If Arms Lab is lost, all upgrades need to be re-purchased
- Arms Lab cost lowered from 15 to 10

- Observatory no longer requires Armory

- Armory cost lowered from 15 to 10
- Mines research cost lowered from 15 to 10
- Jetpack research cost increased from 15 to 20
- Jetpack Upgrade 1 disabled, default jetpack is now at Upgrade 1 strength.

- Jetpack movement reverted to vanilla system for now, still has increased flight speed (from 9 to 11)

- Marines have slightly improved air control, can double jump uphil (More tweaks coming!)

- Welder deals Flame damage type (fixes attacking Webs)
- Welders do not drop on death now (you still always respawn with one, and can drop it for a teammate)

- Mines pRes cost lowered from 15 to 5
- Mines must be purchased each time, only come with 2
- Mine no longer have global limit per player
- Marines can re-buy grenades or switch to another grenade type for 2 pRes.  They will the continue to respawn with that grenade

- Flamethrower damage increased from 12 to 20
- Flamethrower damage cone and radius adjusted to require more precise aiming
- Flamethrower clip size lowered from 50 to 25
- Flamethrower range lowered from 9 to 6
- Flamethrower damage type changed from Flame to Normal
- Flamethrowers now set structures on fire again, which causes 30 additional damage per second

### ProGMod R1 B5 (15-12-18)
- Shotgun base RoF increased by ~8%
- MG base damage increased to 15

- Fixed grenades only costing 2 pRes
- Fixed marine weapons not costing any pRes

- Added walk ability back for Marines (uses shift)

- Only 1 hallucination will be created per use
- Hallucination lifetime decreased from 30 to 15 seconds

### ProGMod R1 B4 (15-12-18)

##### Global Changes:
- Starting tRes is now 50 per team
- Starting pRes is now 10 per team
- pRes income rate is 1 per minute per RT (0.1 per interval, 6 second interval).  Rate was 1.25 previously (0.125 per 6 second interval)

##### Marine Class Changes:
- Marine weight calculation adjusted, higher weights are required for larger impacts on movement speed
- Jetpack cost decreased from 15 to 5
- Jetpack flight speed increased from 9 to 13
- Jetpack initially performs as a 'jump-jet'
	- Base accel increased from 28 to 55
	- Base fuel use rate increased from .21 to 4
	- Replenish rate is .2
- Upgraded jetpack functions more like current vanilla jetpack
	- Acceleration is 30
	- Fuel usage is .35
	- Replenish rate is .25

- Exo model size decreased by 10%

##### Alien Lifeform Changes:
- Skulks will respawn with their last evolved upgrades.
- Skulk bite cone width lowered from 1.2 to 1 (For reference, Onos Gore also is 1.0)

- Gorge cost increased from 8 to 10
- Lerk cost decreased from 21 to 15
- Fade cost decreased from 37 to 20
- Onos cost decreased from 62 to 25
- Gorge upgrade cost decreased from 1 to 0
- Lerk upgrade cost decreased from 3 to 0
- Fade upgrade cost decreased from 5 to 0
- Onos upgrade cost decreased from 8 to 0

- Skulk carapace armor increased from 30 to 40

- Gorge health increased from 160 to 250
- Gorge base armor decreased from 75 to 30
- Gorge carapace armor decreased from 100 to 90

- Lerk health increased from 150 to 200
- Lerk base armor decreased from 45 to 20
- Lerk carapace armor increased from 60 to 80

- Fade health increased from 250 to 300
- Fade base armor unchanged
- Fade carapace armor increased from 120 to 200

- Onos health decreased from 900 to 800
- Onos base armor decreased from 450 to 300
- Onos carapace armor increased from 650 to 750

- Drifter armor decreased from 20 to 0 

- Drifter height lowered from 1.2 to 1

##### Marine Weapon Changes:
- You will always respawn with utility upgrades (Welders, Grenades, Mines).
*Nades and Mines share the same utility slot and you can only spawn with 1 type at a time

- Welder cost increased from 3 to 10
- Grenades (Pulse, Gas, Cluster) cost increased from 2 to 10

- Mines cost increased from 10 to 15
- You now start with 3 Mines
- You can only have 3 active mines.  Newly placed mines will delete oldest if over the cap.
- Mine health increased from 30 to 80
- Mine armor increased from 0 to 10
- Mines now 'Arm' in 0.03 seconds, exploding almost instantly
- Mines can be destroyed before they fully deploy (~4 seconds) without exploding

- Shotgun cost decreased from 20 to 15

- Flamethrower cost decreased from 20 to 10
- Flamethrower now benefits from weapon upgrades

- MG damage increased from 9 to 13
- MG damage type changed to do full damage to players, 50% damage to structures. (Previously it did bonus damage to players)

- GL damage lowered from 165 to 80 (Double vs structure)
- GL does double damage to Flammable structures
- GL now benefits from weapon upgrades

- Weight has been adjusted, weapon weights listed below:
	- Pistol Weight = 0.05
	- Rifle Weight = 0.175
	- Grenade Launcher Weight = 0.3
	- Flamethrower Weight = 0.2
	- Shotgun Weight = 0.225
	- MG Weight = 0.4
	- MG Upgraded Weight = 0.25
	- Hand Grenades Weight = 0.05
	- LayMine Weight = 0.075
	- Welder Weight = 0.05
	
- Exos are now purchased from Robotics Factories

##### Alien Ability Changes:
- Spikes minimum damage decreased from 7 to 5
- Spike damage falloff maximum range decreased from 9 to 7

- Lerk poison effect on bite removed.

- Gorge Tunnel pRes cost increased from 3 to 4
- Gorge Tunnel build time increased from 18.5 to 25

- Hydra cost decreased from 3 to 0
- Hydra build time decreased from 13 to 10
- Hydra health increased from 350 base, 450 matured to 450 base, 650 matured
- Hydra armor increased from 10 base, 50 matured to 50 base, 100 matured
- Hydra model scaled up by 40%

- Babbler cost decreased from 1 to 0
- Babbler egg build time increased from 8 to 15
- Babblers per egg decreased from 6 to 5

- Regeneration always works in combat, up to 12% health per tick

##### Marine Team Changes:
- Mine research cost increased from 10 to 15
- Mine research time increased from 20 to 45

- Grenade research time increased from 10 to 15
- CatPack research requires prototype lab
- Jetpack research cost decreased from 25 to 15

- Welder attack range slightly lowered.
- Welder damage type changed from flame to structural

- Exosuit cost decreased from 55 to 30 (Minigun & Railgun)

- Flamethrower Upgrade 1 added:
	- Cost: 15 tRes
	- Research Time: 60 seconds
	- Requires: Armory
	- Grants: Increases range from 7 to 10
	
- Shotgun Upgrade 1 added:
	- Cost: 15 tRes
	- Research Time: 60 seconds
	- Requires: Advanced Armory
	- Grants: Increases damage falloff minimum range from 4 to 6.5
	
- Shotgun Upgrade 2 added:
	- Cost: 30 tRes
	- Research Time: 120 seconds
	- Requires: Prototype Lab
	- Grants: Increases RoF by ~10%, increases reload speed by 20%
	
- MG Upgrade 1 added:
	- Cost: 15 tRes
	- Research Time: 60 seconds
	- Requires: Advanced Armory
	- Grants: Decreases weapon weight from 0.4 to 0.25
	
- MG Upgrade 2 added:
	- Cost: 30 tRes
	- Research Time: 120 seconds
	- Requires: Prototype Lab
	- Grants: Increases clip size from 75 to 100, increases reload speed by 40%
	
- GL Upgrade 1 added:
	- Cost: 15 tRes
	- Research Time: 60 seconds
	- Requires: Advanced Armory
	- Grants: Adds a fragmentation effect, 4 fragments are triggered when a grenade explodes dealing 20 additional damage each
	
- Jetpack Upgrade 1 added:
	- Cost: 30 tRes
	- Research Time: 120 seconds
	- Requires: Prototype Lab
	- Grants: Increases fuel regeneration rate, decreases fuel usage rate.  Slightly lowers accel, but overall allows much longer flight

- ARC Upgrade 1 added:
	- Cost: 15 tRes
	- Research Time: 60 seconds
	- Requires: Robotics Factory
	- Grants: Increases movement speed from 2.0 to 3.0, and from 0.8 to 1.8 when in combat/on infestation
	
- ARC Upgrade 2 added:
	- Cost: 30 tRes
	- Research Time: 120 seconds
	- Requires: ARC Robotics Factory
	- Grants: Increases damage from 450 to 550.
	
- Nano Armor Upgrade added:
	- Cost: 30 tRes
	- Research Time: 120 seconds
	- Requires: Prototype Lab
	- Grants: Heals 1 armor per second when out of combat.

- Weapons 2 & Armor 2 now require Advanced Armory
- Weapons 3 & Armor 3 now require Prototype Lab

- Arms Lab build time decreased from 17 to 12
- Arms Lab health decreased from 1650 to 1500
- Arms Lab armor decreased from 500 to 250
- Each Arms Lab can only be upgraded once, additional must be built to get all 3 levels of weapons & armor upgrades
- If an Arms Lab is lost, it must be re-built then re-upgraded!

- Armory cost increased from 10 to 15
- Observatory cost increased from 10 to 15

- MAC cost increased from 5 to 8
- MAC armor decreased from 50 to 0

- Shotgun drop cost increased from 20 to 25
- Shotgun drop requires prototype lab
- MG drop cost increased from 20 to 25
- MG drop requires prototype lab
- GL drop cost increased from 20 to 25
- GL drop requires prototype lab
- Flamethrower drop cost decreased from 20 to 15
- Flamethrower drop requires Advanced Armory
- Welder drop cost increased from 5 to 15
- Welder drop requires Armory
- Jetpack drop cost increased from 15 to 20
- Jetpack drop requires prototype lab
- Mines drop requires Advanced Armory

##### Alien Team Changes:
- Drifter abilities removed from drifter and are now directly castable anywhere by Khamm.
- Mucous Membrane radius decreased from 8 to 2
- Enzyme radius decreased from 6.5 to 2
- Hallucination Cloud radius decreased from 8 to 1

- Biomass is no longer researchable

- Harvester cost increased to 10
- Crag cost increased from 13 to 15
- Shift cost increased from 13 to 15
- Shade cost increased from 13 to 15
- Whip cost increased from 13 to 15

- Crag, Shift, Shade, Whip, Spur, Shell, Veil are all now 'flammable'.  They take extra damage from Flamethrowers and cluster grenades.

- Two Shells cost increased from 15 to 25
- Three Shells cost increased from 15 to 35
- Two Spurs cost increased from 15 to 25
- Three Spurs cost increased from 15 to 35
- Two Veils cost increased from 15 to 25
- Three Veils cost increased from 15 to 35

- Energize range decreased from 17 to 12

- Shade Cloak/Ink ranges decreased from 17 to 15

- Crag healing ranges decreased from 14 to 12
- Crag healing wave cost increased from 3 to 5
- Crag healing wave cooldown increased from 6 to 10
- Crag healing wave 

- Leap research cost increased from 15 to 20
- Leap research time increased from 40 to 60
- Leap research requires two hives

- Xenocide research cost increased from 25 to 35
- Xenocide research time increased from 60 to 120
- Xenocide research requires three hives

- GorgeTunnels research cost increased from 15 to 20
- GorgeTunnels research time increased from 40 to 60
- GorgeTunnels research required to build gorge tunnels.
- GorgeTunnels research requires one hive

- BileBomb research cost increased from 15 to 25
- BileBomb research time increased from 40 to 90
- BileBomb research requires two hives

- Umbra research cost increased from 20 to 25
- Umbra research time increased from 45 to 90
- Umbra research requires two hives

- Spores research cost increased from 20 to 35
- Spores research time increased from 60 to 120
- Spores research requires three hives

- MetabolizeEnergy research time increased from 40 to 60
- MetabolizeEnergy research requires one hive

- MetabolizeHealth research cost increased from 20 to 25
- MetabolizeHealth research time increased from 45 to 90
- MetabolizeHealth research requires two hives

- Stab research cost increased from 25 to 35
- Stab research time increased from 60 to 120
- Stab research requires three hives

- Charge research cost increased from 15 to 30
- Charge research time increased from 40 to 60
- Charge research requires one hive

- BoneShield research cost increased from 20 to 25
- BoneShield research time increased from 40 to 90
- BoneShield research requires two hives

- Stomp research cost increased from 25 to 35
- Stomp research time increased from 60 to 120
- Stomp research requires three hives

### ProGMod R1 B3 (8-12-18)

##### Alien Team Changes:
- Adjusted skulk wallhop to allow better chaining of jumps

### ProGMod R1 B2 (8-12-18)

##### Marine Team Changes:
- Removed power node impulse and render effects from field players
- Removed power nodes from minimap
- Removed power nodes unit status tooltips
- Extractor build time increased to 15 from 11
- Increased SG rate of fire by ~6.5%
- Shotgun damage falloff starting range increased to 5m from 4m
- Fixed issue preventing extractors from being placed right after harvester was killed

##### Alien Team Changes:
- Drifters now build 35% slower (Increases harvester build time from ~38 seconds to ~60 seconds)
- Harvester cost increased to 10
- Harvester base armor lowered by 100 (200 less effective health)
- Harvester health when fully matured lowered by 100, armor lowered by 70 (240 less effective health)

### ProGMod R1 B1 (7-12-18)

##### Alien Team Changes:
- Cysts removed from the game.
- Harvester, Crag, Shift, Shade, Shell, Spur, Veil can be placed anywhere and dont require infestation.
- Harvester, Crag, Shift, Shade, Shell, Spur, Veil dont autobuild when off infestation.
- Harvester, Crag, Shift, Shade, Shell, Spur, Veil provide infestation (10m).
- Hive spreads infestation further (25m up from 20m).

##### Marine Team Changes:
- Power nodes appear always unsocked, are invulnerable and always provide power.
- Marine base speed increased to 5.6 from 5.0
- Marine sprint removed.
- Jetpack speed increased to 10 from 9
- Exo speed increased to 6 from 5.75

##### Marine Weapon Changes:
- Shotgun pellets per shot lowered to 10, damage increased to 17 per pellet (Same overall damage).
- Shotgun spread adjusted to be a bit tighter overall.
- Shotgun damage falloff added, starts at 4m and ends at 16m.  After 16m only 1 damage per pellet is done.

##### Alien Lifeform Changes:
- Skulk speed increased to 8.0 from 7.25
- Gorge speed increased to 6.75 from 6.0
- Gorge air control increased to 18 from 6
- Gorge air friction lowered to .12-.15 from .2
- Lerk speed increased to 13.25 from 13
- Fade speed increased to 6.5 from 6.2
- Fade blink speed increased to 14.5 from 14
- Onos speed increased to 7.0 from 6.6
- Onos charge speed increased to 13 from 12.5