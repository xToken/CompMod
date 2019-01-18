## Marine Changes vs Vanilla NS2

### Base Marine:
	- Added walk, uses new binding which in in options menu.
	- Base speed increased to 5.7 from 5.0
	- Slightly improved air control, can double jump uphil (More tweaks coming!)
	- Sprint removed.
	- Weight calculation adjusted, higher weights are required for larger impacts on movement speed
	
### Jetpack Marine:
	- Base flight speed increased to 10.5 from 9
	- Cost decreased from 15 to 10 pRes
	- Weight calculation adjusted, higher weights are required for larger impacts on movement speed/flight speed
	- Higher weights will no longer cause increased fuel usage
	- Max speed increased from 9 to 10
	- Max speed cannot be exceeded anymore
	- Uses fuel much more rapidly, but recharges a bit faster as well
	- Has better air control when not actively 'jetpacking'
	- Gravity has been lowered to allow more time to manuever between 'thrusts'
	
### Exo:
	- Speed increased to 6 from 5.75
	- Model size decreased by 10%
	- Cost decreased from 55 to 25 pRes (Minigun & Railgun)
	- Now purchased at the Robotics Factory
	- Base armor increased to 400
	- Armor upgrades now grant 40 extra armor per level, up from 30
	- Cannot be welded, have an auto-repair abiltiy on E
	- Dual Minigun & Dual Railgun cost increased from 30 to 35 pRes
	- Thrusters have been improved, and use shared energy pool
	- Can now self-repair when out of combat, at the cost of energy
	- Comm researchable upgrade grants a damage reduction shield which uses energy
	- Railgun exosuit uses less energy compared to Minigun exosuit
	
### Shotgun:
	- Cost decreased from 20 to 15 pRes
	- Pellets per shot lowered to 10, damage increased to 17 per pellet (Same overall damage).
	- Tightened and reworked spread
	- Base RoF increased by ~8%
	- Added damage falloff, starts at 6m
	- After 16m, damage will decreased to 1 per pellet
	- Tier 1 upgrade increases reload speed by 50%
	- Tier 2 upgrade increases fire rate by 8%
	
### MG:
	- Increased damage from 9 to 13
	- Damage type changed to do full damage to players, 50% damage to structures. (Previously it did 1.5x to players)
	- Lowered base clip size from 125 to 100
	- Tier 1 upgrade icnreases clip size from 100 to 125 weight from 0.4 to 0.25
	- Tier 2 upgrade increases reload speed by ~50%
	
### Minigun:
	- Damage lowered from 10 to 6
	- Can now shoot for longer before overheating
	- Bullet size now more closely matches MG
	
### Railgun:
	- Changed to a 'Railgun Shotgun'
	- Deals 22 damage per pellet, fires 4 pellets
	- Has 6 ammo each arm by default, regains 1 ammo every 2.25 seconds
	- Bullet size now matches shotgun
	- Has damage falloff ala the shotgun, starting at 10m and ending at 20m
	
### Grenade Launcher:
	- Damage lowered from 165 to 80
	- Damage type changed from 'GrenadeLauncher' to QuadStructural
	- Now benefits from weapon upgrades
	
### Welder:
	- Cost increased from 3 to 10 pRes
	- You will always respawn with a welder once purchased
	- Increased player welding rate from 20 to 30
	- Increased structure repair rate from 90 to 120
	- Welders do not drop on death now (you still always respawn with one, and can drop it for a teammate)
	- Attack 'cone' lowered from 2.0/2.0 to 0.5/0.8
	- Attack range lowered from 2.4 to 1.7
	- Damage type changed to normal
	
### Flamethrower
	- Cost decreased from 20 to 10 pRes
	- Lowered damage from 25 to 18
	- Decreased attack cone from 0.15 to 0.06
	- Increased initial range from 7 to 8
	- Upgraded range is 10m
	- Clip size increased from 50 to 100.
	- Max clips lowered from 4 to 2.
	- Changed damage type back to normal from structural
	- Increased burn damage from 0 to 10/s
	- Max burn duration unchanged at 20s
	- Fixed OnFire damage not applying when structures are still being damaged
	- Now benefits from weapon upgrades
	- Burns spores, umbra, drifter abilities, bilebomb and bilebomb DOT.
	- Removes parasite from friendly marines

### Pistol:
	- Changed damage type to Normal
	
### Axe:
	- Fixed no-reg issue and slightly adjusted animations
	- Second swing animation ~10% faster to make DPS similar to animation cancelling
	
### Mines:
	- Cost lowered from 10 to 5 pRes
	- Health increased from 30 to 80
	- Armor increased from 0 to 10
	- 'Arm' timer is 0.03 seconds, previously was 0.17
	- Can be destroyed before they fully deploy (~4 seconds) without exploding
	- Damage type changed to normal
	
### Grenades:
	- Cost increased from 2 to 10 pRes
	- Once purchased, you will always respawn with the last purchased grenade type.  You can change to the other types for 2 pRes.
	
### Pulse Grenade:
	- Removed 3m hit scan!
	- Now deals full damage to targets directly hit.
	- Damage increased from 110 to 120
	- Hit 'grace' is 0.15m
	- Targets hit no longer regenerate energy at a reduced rate, still attack at a reduced rate however.
	
### Cluster Grenade:
	- Now lights structures on fire for additional burning damage for 2s.
	- Damage type changed to structural
	
### Weapon Weights:
	- Weight calculation is now non-linear and does not allow speeds beyond the 'max speed' when going under the default threshold
	- Weight has been adjusted, weapon weights listed below:
		- Pistol Weight = 0.05
		- Rifle Weight = 0.175
		- Grenade Launcher Weight = 0.3
		- Flamethrower Weight = 0.125
		- Shotgun Weight = 0.225
		- MG Weight = 0.27
		- Hand Grenades Weight = 0.05
		- LayMine Weight = 0.075
		- Welder Weight = 0.05
		
### Weapon Drops:
	- Shotgun drop cost increased from 20 to 25 tRes
	- Shotgun drop requires prototype lab
	- MG drop cost increased from 20 to 25 tRes
	- MG drop requires prototype lab
	- GL drop cost increased from 20 to 25 tRes
	- GL drop requires prototype lab
	- Flamethrower drop cost decreased from 20 to 15 tRes
	- Flamethrower drop requires Advanced Armory
	- Welder drop cost increased from 5 to 15 tRes
	- Welder drop requires Armory
	- Jetpack drop cost increased from 15 to 20 tRes
	- Jetpack drop requires prototype lab
	- Mines drop requires Advanced Armory
	
### Medpacks:
	- No longer have a pickup cooldown (Spam away!)
	
### Catpacks:
	- Duration lowered from 8 to 5
	- Weapon reload speed increase removed
	- Now unlock once the advanced armory is researched
	
### Extractors:
	- Build time increased to 15 from 11
	- Extractor now requires a Command Station (:D)
	- Armor reduced from 1050 to 850
	
### Weapons/Armor Upgrades:
	- Weapons 2 & Armor 2 now require Advanced Armory
	- Weapons 3 & Armor 3 now require Prototype Lab
	- Decreased Weapons1/Armor1 cost from 20 to 15 tRes
	- Increased Weapons3/Armor3 cost from 40 to 45 tRes
	
### Arms Lab:
	- Arms Lab no longer requires Armory
	- Arms Lab cost increased from 15 to 20 tRes
	
### Extrator:
	- Armor reduced from 1050 to 850
	
### Observatory:
	- No longer requires Armory
	- Cost increased from 10 to 15 tRes
	
### Phase Gate:
	- Now has a 0.3 second delay beforing phasing another player
	
### Robotics Factory:
	- Robotics Factory no longer requires Infantry Portal to be dropped first
	- Robotics Factory now requires a Command Station (:D)
	
### MAC:
	- MAC cost increased from 5 to 8 tRes
	- MAC armor decreased from 50 to 0
	
### ARC:
	- Damage type changed to structuresonly (No change in effectiveness)
	- Build time increased from 7 to 10 seconds
	
### ARC Robotics Factory:
	- ARC Robotics Factory upgrade cost increased from 5 to 15
	- ARC Robotics Factory upgrade time increased from 20 to 30
	
### Ghost Structures:
	- Only return 75% of the cost when poofed
	
### Jetpack Research:
	- Cost increased from 25 to 40 tRes
	- Research time lowered from 90 to 60
	
### Grenade Research:
	- Research time increased from 10 to 30
	
### Catpack Research:
	- Requires prototype lab
	
### Flamethrower Upgrade 1 added:
	- Cost: 10 tRes
	- Research Time: 30 seconds
	- Requires: Armory
	- Grants: Increases range from 8 to 10
	
### Shotgun Upgrade 1 added:
	- Cost: 15 tRes
	- Research Time: 30 seconds
	- Requires: Armory
	- Grants: Increases reload speed by 50%
	
### Shotgun Upgrade 2 added:
	- Cost: 30 tRes
	- Research Time: 60 seconds
	- Requires: Advanced Armory
	- Grants: Increases RoF by ~8%
	
### MG Upgrade 1 added:
	- Cost: 15 tRes
	- Research Time: 30 seconds
	- Requires: Armory
	- Grants: Increases clip size from 100 to 125
	
### MG Upgrade 2 added:
	- Cost: 30 tRes
	- Research Time: 60 seconds
	- Requires: Advanced Armory
	- Grants: Increases reload speed by 50%
	
### GL Upgrade 1 added:
	- Cost: 15 tRes
	- Research Time: 30 seconds
	- Requires: Advanced Armory
	- Grants: Adds a fragmentation effect, 4 fragments are triggered when a grenade explodes dealing 20 additional damage each
	
### ARC Upgrade 1 added:
	- Cost: 15 tRes
	- Research Time: 30 seconds
	- Requires: Robotics Factory
	- Grants: Increases movement speed from 2.0 to 3.0, and from 0.8 to 1.8 when in combat/on infestation
	
### ARC Upgrade 2 added:
	- Cost: 30 tRes
	- Research Time: 60 seconds
	- Requires: ARC Robotics Factory
	- Grants: Increases damage from 450 to 550.
	
### Jetpack Upgrade 1 added:
	- Cost: 30 tRes
	- Research Time: 90 seconds
	- Requires: Prototype Lab
	- Grants: Increased fuel recovery rate and reduced fuel usage rate
	
### Exo Upgrade 1 added:
	- Cost: 15 tRes
	- Research Time: 30 seconds
	- Requires: Prototype Lab
	- Grants: Grants shield ability that reduces damage but consumes energy
	
### Nano Armor Upgrade added:
	- Cost: 30 tRes
	- Research Time: 120 seconds
	- Requires: Prototype Lab
	- Grants: Heals 5 armor per second when out of combat.	
	
### Power Nodes:
	- Disabled
	
### Nano Shield:
	- Disabled
	
### Power Surge:
	- Disabled