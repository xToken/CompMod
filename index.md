Some description/highlevel shtuffffffffff?

### [Alien Changes Overview](https://xtoken.github.io/CompMod/webpages/alien_overview)

### [Marine Changes Overview](https://xtoken.github.io/CompMod/webpages/marine_overview)

### [Other Misc. Changes Overview](https://xtoken.github.io/CompMod/webpages/misc_overview)

### [Alien Commander Guide](https://xtoken.github.io/CompMod/webpages/alien_comm_guide)

### [Marine Commander Guide](https://xtoken.github.io/CompMod/webpages/marine_comm_guide)

### Recent Changelog: Build 30 (27-4-19)

### Global:
	- Updated to work with B327
	- Khamm tunnels are implemented, can be placed without drifter currently (may change!), need infestation

### Recent Changelog: Build 26 (10-2-19)

### Global:
	- Added progchangelog console command to show this changelog ingame!

***
### Recent Changelog: Build 25 (5-2-19)

### Global:
	- Supply system enabled, each team starts with 1 pre-built powernode/infestednode
	- Each captured node grants 20 additional supply
	- Most structures have had their supply costs rebalanced
	- Additional nodes cost 15 tRes each

### Aliens:
	- Added Onos rage mechanic:
		- Onos gains rage from hitting structures, players and taking damage
		- Gains the most rage from hitting structures
		- Each unique source grants extra rage
		- Takes 5 seconds for rage to deleplete back to 0
		- The onos gains various effects that scale with his rage amount
		- At full rage, onos gains:
			- 6% HP regen per second
			- 40% attack speed
			- 1m/s additional movement speed
			
	- Onos gore and smash base attack speeds lowered by about 20%
	- Onos now has a healing softcap, above 12.5% per second the effectiveness is reduced to 25%
	- Onos armor lowered from 450/750 to 300/600
	- Onos base movement speed lowered from 7.0 to 6.8
	- Onos charge speed lowered from 13 to 12
	- Hive tRes cost lowered from 50 to 40
	- Cyst tRes cost lowered from 5 to 3
	- Shade/Shift/Crag base eHP increased from 600 to 800
	- Bonewall health increased from 100 to 300
	- Eggs can no longer be misted
	- Unbuilt structures can now be misted
	- Disabled biomass HUD elements
	- Supply Costs:
		- Whip: 5
		- Crag: 3
		- Shift: 3
		- Shade: 3
		- Shell: 1
		- Spur: 1
		- Veil: 1
		- Cyst: 2
		
### Marines:
	- Lowered Marine movement speed from 5.7 to 5.6
	- Moved ARC Upgrade 1 to ARC Robotics Factory for consistency
	- Supply Costs:
		- MAC: 1
		- Armory: 2
		- ArmsLab: 1
		- PrototypeLab: 1
		- ARC: 2
		- Sentry: 5
		- RoboticsFactory: 1
		- InfantryPortal: 3
		- PhaseGate: 3
		- Observatory: 3
	
### Fixes:
	- Fixed insight upgrade icons showing red for Shell upgrades until veils were built.
	- Destroyed Cysts will now show in the killfeed
	
***