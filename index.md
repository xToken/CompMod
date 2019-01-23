Some description/highlevel shtuffffffffff?

### [Alien Changes Overview](https://xtoken.github.io/CompMod/webpages/alien_overview)

### [Marine Changes Overview](https://xtoken.github.io/CompMod/webpages/marine_overview)

### [Other Misc. Changes Overview](https://xtoken.github.io/CompMod/webpages/misc_overview)

### [Alien Commander Guide](https://xtoken.github.io/CompMod/webpages/alien_comm_guide)

### [Marine Commander Guide](https://xtoken.github.io/CompMod/webpages/marine_comm_guide)

### Recent Changelog: Build 23 (22-1-19)

### Aliens:
	- Skulk base speed increased from 7.5 to 7.75
	- Parasite Cloud duration increased from 10 to 15 seconds
	- Base Hive armor increased from 750 to 1000.  Mature Hive armor increased from 1400 to 1500
	- Flourishing effectiveness on Crag and Shift increased to 2x
	- Crag Heal Wave and Shift Active Energize disabled, same effectiveness now from passives when flourishing.
	- Building structures can no longer be misted (was just wasting the mist previously)
	
### Marines:
	- Lowered Marine air control from 15 to 13 (to decrease flying ninja marine dodges)
	- Grenade Launcher upgrade increased from 15 to 25 tRes
	- Shotgun base RoF increase lowered to 4% from 8% (Upgrade remains unchanged)
	- Flamethrower damage cone increased from 0.06 to 0.08
	- Grenade Launcher damage type changed to deal Triple damage to Structures (was Quad)
	- Grenade Launcher fragment damage radius changed to match GL damage radius
	- Minigun spread changed to match MG
	- Railgun damage falloff removed
	- MAC HP increased from 300 to 500
	- Corrected fixed time intervals when building marine structures, should make all build times slightly shorter (more accurate!)
	
### Fixes:
	- Fixed commander logout setting offset view angles instead of actual view angles.

***
### Recent Changelog: Build 22 (18-1-19)

### Aliens:
	- Decreased Leap research cost from 25 to 20 tRes
	- Decreased Xenocide research cost from 35 to 30 tRes
	- Decreased Umbra research cost from 25 to 20 tRes
	- Decreased Spores research cost from 35 to 30 tRes
	- Decreased Stab research cost from 35 to 30 tRes
	- Decreased Charge research cost from 25 to 20 tRes
	- Decreased Stomp research cost from 35 to 30 tRes
	- Decreased cost of Parasite Cloud from 3 to 2 tRes
	- Decreased duration of nutrient mist from 10 to 5 seconds
	- Decreased maximum amount of stacked nutrient mist from 30s to 15s
	- Added UI elements to better show sustenance levels and stacks of mist
	- Sustenance will now decrease from 100% to 0% in 90s, was 120s previously
	- Crag Heal Wave and Shift Energize now require flourishing structures
	- Lowered harvester base health from 1800/200 to 1600/100.
	- Onos charge energy consumption increased from 29 to 30.
	- Onos charge energy usage is now based on charge fraction
	
### Marines:
	- Shrunk size of flamethrower cinematic to better match cone size
	- Weight of flamethrower decreased from 0.2 to 0.125
	- Flamethrower clip size increased from 35 to 100
	- Flamethrower max clips decreased from 4 to 2
	- Flamethrower cone size increased from 0.05 to 0.06
	- Flamethrower burning damage decreased from 25 to 10/s
	- Flamethrower max burning time increased from 15 to 20s
	- Flamethrower deals double damage to Clogs
	- Exosuit costs lowered from 30 to 25 pRes
	- MG weight lowered from 0.46 to 0.27
	- MG Upgrade 1 now only increases clip size
	- MG Upgrade 2 now increases reload speed by ~50%
	- SG Upgrade 1 increases reload speed by 50%, up from 30%
	- Railgun spread reworked to be very similar to shotgun
	- Railgun base damage increased from 20 to 22 per pellet (88 per shot)
	- Jetpack upgrade fuel rate usage lowered further, fuel regain rate increased.
	- Slightly increased axing webs range
	
### Misc:
	- Commander healthbars toggle is now remembered
	- Commander healthbars default to on.
	- Re-added spawn angles fix
	- Added various tech tree icons
	- Added base system for supply rework, currently disabled
	
***
### Recent Changelog: Build 21 (12-1-19)

### Aliens:
	- Dropping structures from the global menu will now queue orders onto nearby drifters already building structures, or the closest drifter.
	
### Misc:
	- Shrunk size of techmap icons a bit
	- Added helper text to last 2 icons for Robotics Factory (They are the exosuit purchases, not ARC upgrades :D)
	- Fixed spectator assert bug with maturity icons

***
### Recent Changelog: Build 20 (12-1-19)

### Marines:
	- Catpack duration lowered from 8 to 5
	- Catpack weapon reload speed increase removed
	- Catpacks are now available once the advanced armory is researched
	- Medpack pickup delay removed
	- Jetpack research cost increased from 20 to 40 tRes
	- Jetpack movement adjusted again, slightly lower thrust/fuel usage, lower max speed from 12 to 10
	- Jetpack 'gravity' lowered from -16 to -13
	- Exosuit (Railgun/Minigun) cost reduced to 30 pRes
	- Railgun ammo renegeration rate lowered from 2.5 to 2.25s
	- Railgun spread reduced further
	- Railgun damage falloff minimum increased from 8 to 10m
	- Flamethrower clip size increased from 25 to 35
	- Flamethrower now burns spores, umbra, drifter abilities and bilebomb again
	- Shotgun level 1 reload speed increased from 20% to 30%
	- Marine weapon upgrades (SG/MG lvl 1) moved to normal armory
	- Marine weapon upgrades (SG/MG lvl 2 and GL lvl 1) moved to advanced armory

### Aliens:
	- Skulk max carapace armor lowered from 35 to 25
	- Lerk base armor lowered from 30/90 to 20/80
	- Fade base health lowered from 350 to 300
	- Fade armor increased from 70/160 to 80/170
	- Fade can use blink to chain 'jumps' to bypass ground friction and maintain higher speeds
	- Onos health lowered from 900 to 800.
	- Onos armor increased from 400/750 to 450/750
	- Regeneration lowered from 4/8/12% to 3/6/9% every 2 seconds
	- Fade adrenaline regeneration rate decreased from 150% to 120%
	- Onos adrenaline regeneration rate decreased from 120% to 75%
	- Onos gore/smash damage type changed to structural from quadstructural
	- Onos smash animation speed up by 30%
	- Onos charge max speed unchanged at 13
	- Charging onos now takes 1.5 seconds to reach maximum speed
	- Charge now costs 29 energy/s, down from 30/s
	- Onos model shrunk by 15%
	- Skulk ground speed lowered from 8.0 to 7.5
	- Skulk walljump speed lowered from 11.5 to 11
	- Skulk celerity walljump bonus increased from 1.2 to 1.5
	- Drifter eggs can now be placed anywhere, take 5 seconds to build
	- Cysts can be built anywhere, cost 5tRes.  They have 650 HP, and provide a small AOE of infestation
	- Crag min/max heal amounts changed from 5/50 to 8/30
	- Parasite Cloud now lasts for 10 seconds (up from 6), and can travel up to 40m
	- The drifter will now move until it has LOS on the target area before casting the parasite cloud
	- Sustenance now starts decreasing immediately on structures after the mist has expired
	- Re-organized Alien Commander buttons to mirror vanilla locations
	- Shell, Spur and Veil now only take 1 mist to real full sustenance
	
### Bug Fixes:
	- Fixed marine structures sometimes showing maturity bars
	- Fixed door sounds not triggering when other players opened the door.  Door sounds are no longer predicted by the client
	- Fixed structures not losing sustenance when they reached 100%
	
***