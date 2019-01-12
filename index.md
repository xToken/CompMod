Some description/highlevel shtuffffffffff?

### [Alien Changes Overview](https://xtoken.github.io/CompMod/webpages/alien_overview)

### [Marine Changes Overview](https://xtoken.github.io/CompMod/webpages/marine_overview)

### [Other Misc. Changes Overview](https://xtoken.github.io/CompMod/webpages/misc_overview)

### [Alien Commander Guide](https://xtoken.github.io/CompMod/webpages/alien_comm_guide)

### [Marine Commander Guide](https://xtoken.github.io/CompMod/webpages/marine_comm_guide)

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
	- Onos charge max speed lowered from 13 to 12.5
	- Charging onos now takes 1.5 seconds to reach maximum speed
	- Charge now costs 34 energy/s, up from 30/s
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
### Recent Changelog: Build 15 (7-1-19)

### Marines:
	- Increased phase gate minimum phase time to 0.3 seconds
	- Slightly decreased railgun spread
	- Decreased jetpack acceleration and slightly increased fuel usage
	- Decreased railgun exo fuel usage rates
	- Reverted Gas grenades to Armor only damage, and 50 damage/second
	- Increased MG weight from 0.4 to 0.46 (Slightly lowers movespeed with MG)

### Aliens:
	- Increased Fade base health from 300 to 350
	- Drifter health increased from 150 to 250
	- Drifters will now be healed by the hive
	- Crag/Shift/Shade eHP increased from 1200 to 1400 when fully 'grown'
	- NutrientMist now gives 33% sustenance per use
	- Sustenance now increases & decays at a constant rate, takes 2 minutes to go from 100% to 0%
	- Structures now start at 0% sustenance instead of 50%
	- Armor now heals at double the rate of health again (Same as vanilla)
	- Echo now costs 3 tRes for all structures (except Hive which is 50)
	- Can now only echo Harvesters onto infestation
	- Cannot echo gorge tunnels anymore

### Onos:
	- Onos Charging sensitivity reduction removed
	- Lowered delay between charges from 1 to 0.25 seconds
	- Lowered time to accelerate to full charge speed from 0.5 to 0.25 seconds
	- Increased charge energy cost from 20 to 30/second
	- Increased base health from 850 to 900
	- Gore now deals 75 damage
	- Gore damage type changed to QuadStructural

### Bug Fixes:
	- Fixed crush HUD icons overwritting movement icons
	- Fixed purchasing second/third upgrades costing the same as purchasing all 2/3 at once, instead of just the cost of the new upgrade
	- Fixed 'Producing' text showing in spectating during construction
	- Fixed another occurence of lingering infestation :<

### Misc:
	- Spectators can now see maturity levels on alien structures
	- Updated tech maps for both teams
	- Updated and added alert messages for tech researches
	
***