## Alien Changes vs Vanilla NS2

### Skulk:
	- Maximum carapace armor decreased from 30 to 25
	- Adjusted wallhop to allow better chaining of jumps
	- Speed increased to 8.0 from 7.25
	- Decreased model width by 10% from the front
	- Decreased bite cone from 1.2 wide and 1.2 tall to 0.8 wide and 1.0 tall
	- Skulks will respawn with their last evolved upgrades in full effect
	- Automatically selected upgrades for Skulks is disabled
	- Ground speed increased from 7.25 to 7.75
	- Celerity walljump bonus increased from 1.2 to 1.5
	- Parasite:
		- Duration lowered from 44 to 30
	
### Gorge:
	- Health increased from 160 to 250
	- Base armor decreased from 75 to 30
	- Maximum carapace armor decreased from 100 to 90
	- Speed increased to 6.75 from 6.0
	- Air control increased to 18 from 6
	- Air friction lowered to .12-.15 from .2
	- Cost increased from 8 to 10 pRes
	- Upgrade cost unchanged at 1 pRes
	- Gorges can put out structures that are on fire 100% of the time.
	- Spit:
		- Damage type changed to Normal
	- Gorge Tunnel:
		 - Cost increased from 3 to 4 pRes
		 - Build time increased from 18.5 to 25
		 - Requires commander to research
	- Hydra:
		 - Cost decreased from 3 to 0
		 - Build time decreased from 13 to 10
		 - Health increased from 350 base to 650
		 - Armor increased from 10 base to 100
		 - Hydra no longer benefits from Maturation
		 - Model scaled up by 40%
		 - RoF normalized to 1/s
		 - Damage increased from 15 to 20
	- Babblers:
		 - Cost decreased from 1 to 0
		 - Egg build time increased from 8 to 15
		 - Babblers per egg decreased from 6 to 5
		 - Health increased from 10 to 11, removed damage limitation of 5 per hit.
	- Web:
		 - Decreased web health from 80 to 40
		 
### Lerk:
	- Health increased from 150 to 200
	- Base armor decreased from 45 to 20
	- Maximum carapace armor increased from 60 to 80
	- Cost decreased from 21 to 15 pRes
	- Flying speed increased to 13.25 from 13
	- Upgrade cost lowered from 3 to 2 pRes
	- Gestate time lowered from 15 to 10 seconds
	- Model rotation slightly restricted
	- Bite:
		 - Poison effect on bite removed.
	- Spikes:
		 - Spread reduced from 4 to 3.1
	- Spores:
		 - Damage type changed to Normal
		 - Damage increased from 15 to 20/s
	- Healing Roost:
		 - New ability, lerk heals passively for 5 HP/s when roosting
		 
### Fade:
	- Health increased from 250 to 300
	- Maximum carapace armor increased from 120 to 170
	- Base armor is unchanged at 80
	- Cost decreased from 37 to 25 pRes
	- Ground speed increased to 6.5 from 6.2
	- Blink speed increased to 14.5 from 14
	- Upgrade cost decreased from 5 to 3 pRes
	- Gestate time lowered from 25 to 13 seconds
	- Added slightly modified ceiling fix for crouching fades
	- Swipe:
		- Damage type changed from structuresonlylight to puncture (Deals half damage to structures)
	- Blink:
		- Blink can chain 'jumps' to bypass ground friction and maintain higher speeds
		
### Onos:
	- Base health lowered from 900 to 800
	- Base armor lowered from 450 to 300
	- Maximum carapace armor decreased from 650 to 600
	- Cost reduced from 40 to 35
	- Onos model shrunk by 15%
	- Disabled 'Stampede' effects, cannot charge through players and doesn't send marines flying.
	- Speed increased to 6.8 from 6.6
	- Cost decreased from 62 to 40 pRes
	- Upgrade cost decreased from 8 to 4 pRes
	- Gestate time lowered from 30 to 16 seconds
	- Has a healing softcap, above 12.5% per second the effectiveness is reduced to 25%
	- Rage System:
		- Gained from hitting structures, players and taking damage
		- Each unique source grants double on first event, every 2 seconds
		- Rage gain from hitting structures is 0.04
		- Rage gain from hitting players is 0.02
		- Rage gain from taking damage is 0.0075
		- Max rage is 1 (100%)
		- Rage will not decrease for 3 seconds after gaining rage
		- Rage will decrease by .2 per second
		- Attack speed, movement speed and passive regen scale with rage amount
		- At max rage onos gains:
			- 6% HP regen per second
			- 40% attack speed
			- 1m/s additional movement speed (base and while charging)
	- Gore:
		- Damage reduced to 75
		- Damage type unchanged as Structural
		- Base attack speed lowered by 20%
	- Smash:
		- Base attack speed lowered by 15%
	- Charge:
		 - No longer knocks marines back
		 - No longer allows you to charge through marines
		 - No longer reduces your mouse sensitivty while charging
		 - Lowered delay between charges from 1 to 0.25 seconds
		 - Time to accelerate to full charge speed increased from 0.5 to 1.5 seconds
		 - Increased charge energy cost from 20 to 30/second
		 - Energy usage is based on the charge amount, which increases over the 1.5s windup
		 - Speed lowered from 12.5 to 12
	- Stomp:
		 - Damage type changed to normal from heavy

### Traits:
	- Traits re-categorized under Offensive, Defensive & Movement
	- Traits categories must be researched first, each costs 20 tRes and takes 30 seconds
	- Once the trait category is research, the trait structure can be built (Veil, Shell, Spur)
	- Initially aliens start with only 1 trait slot, any trait type can be equipped in the slot
	- Additional trait slots can be researched by the commander for 25 & 35 tRes respectively
	- Swapping an upgrade now takes an additional 2 seconds of gestation time
	- Movement (Spurs):
		- Celerity: Increases speed by 0.6 per Spur
		- Adrenaline:
			- Below rates are for 3 Spurs
			- Skulk - additional 60% energy regen
			- Gorge - additional 45% energy regen
			- Lerk - additional 90% energy regen
			- Fade - additional 120% energy regen
			- Onos - additional 75% energy regen
	- Defensive (Shells):
		- Regeneration: Regeneration always works in combat, up to 9% health per tick
		- Carapace: Increases armor:
			- Skulk - Additional 5 armor per Shell
			- Gorge - Additional 20 armor per Shell
			- Lerk - Additional 20 armor per Shell
			- Fade - Additional 30 armor per Shell
			- Onos - Additional 100 armor per Shell
	- Offensive (Veils):
		- Aura: No longer shows enemies through walls, each veil increases range by 10m
		- Crush: Increases structural damage & damage to Exos by 7% per veil

### Maturity:
	- Now called Sustenance
	- Sustenance now passively decreases, requiring structures to be regularly misted to maintain the benefits
	- Structure passives and actives (Crag, Shift, Shade) scale with with sustenance level
	- For Shells, Spurs & Veils, each mist gives 100% sustenance over 15 seconds.
	- For all other structures, each mist gives 33% sustenance over 5 seconds, and can be stacked up to 3 times
	- After the mist effect has ended, the structure will start losing sustenance immediately
	- Structures start at 0% sustenance
	- Added UI elements to show sustenance levels on structures
	- Unbuilt structures can be misted to gain sustenance
	
### Nutrient Mist:
	- Moved to global Alien Commander ability
	- Single target only
	- Only increases the sustenance of the target structure
	- Lasts for 5 seconds
	- Nutrient Mist increases sustenance, can be stacked up to 3 times.
	- Costs decreased to 1 tRes
	
### Echo:
	- Now requires the individual structure to be targetted first, then the target location
	- The Drifter now casts echo
	- Hives can now be echoed for 50 tRes
	- Echoing all other structures costs 3 tRes
	- Echo now has an effect triggered at the destination when something is being teleported in
	
### Hallucination:
	- Now requires the Offensive Traits research
	
### Enzyme:
	- Now requires the Movement Traits research
	
### Parasite Cloud:
	- New ability on the Drifter
	- The cloud will be shot out from the drifter towards the target location
	- The drifter will move until it has LOS on the target area before casting the parasite cloud
	- As the cloud moves, it will parasite (2/s duration) nearby Marines, enabling the commander to scout ahead
	- Costs is 2 tRes
	- Requires the Defensive Traits research
	- Will last for 15 seconds, and can travel up to 40m
	
### Drifter
	- Drifters can be built from Drifter Eggs placed anywhere on infestation.
	- Drifters take 5 seconds to build
	- Health decreased from 300 to 250
	- Armor decreased from 20 to 0 
	- Will now be healed by the hive
	- Hover height lowered from 1.2 to 1
	- Cost decreased from 8 to 5 tRes
	- Built from the hive, takes 3 seconds
	- Mucous Membrane removed
	- Enzyme radius decreased from 6.5 to 6
	- Hallucination Cloud radius decreased from 8 to 6
	- Hallucination lifetime decreased from 30 to 15 seconds
	
### Crag:
	- Increased move speed from 1.5 to 3
	- Infestation is no longer required to build, will spread automatically (10m)
	- Will not auto-build off infestation
	- Adjusted health from 600/700 to 400/1000
	- Adjusted armor from 200/340 to 200/200
	- Lowered cost from 13 to 10
	- Healing range decreased from 14 to 12
	- Passive healing % decreased from 6 to 4
	- Minimum passive healing decreased from 10 to 8
	- Maximum passive healing decreased from 60 to 30
	- When flourishing, healing effect will be increased by 2x (similar to old heal wave)
	- Heal Wave is disabled
	- Costs 3 supply
	
### Shift:
	- Increased move speed from 1.5 to 3
	- Infestation is no longer required to build, will spread automatically (10m)
	- Will not auto-build off infestation
	- Adjusted health from 750/1100 to 600/1100
	- Adjusted armor from 75/75 to 100/150
	- Lowered cost from 13 to 10
	- Energize range decreased from 17 to 12
	- Passive energize effect only provides 4 energy per second
	- When flourishing, energize effect will be increased by 2x
	- Costs 3 supply
	
### Shade:
	- Increased move speed from 1.5 to 3
	- Infestation is no longer required to build, will spread automatically (10m)
	- Will not auto-build off infestation
	- Cloak/Ink ranges decreased from 17 to 15
	- Adjusted health from 750/1500 to 700/1200
	- Adjusted armor from 0/0 to 50/100
	- Lowered cost from 13 to 10
	- Gains a detection passive above 85% sustenance, that shows aura icons on marines like obs detection
	- Costs 3 supply
	
### Whip:
	- Cost increased from 13 to 15
	- Bombard unlocks above 85% sustenance, and is lost below 85%
	- Costs 5 supply
	
### Shell:
	- Infestation is no longer required to build, will spread automatically (10m)
	- Will not auto-build off infestation
	- Two Shells cost increased from 15 to 25
	- Three Shells cost increased from 15 to 35
	- Costs 1 supply
	
### Spur:
	- Infestation is no longer required to build, will spread automatically (10m)
	- Will not auto-build off infestation
	- Two Spurs cost increased from 15 to 25
	- Three Spurs cost increased from 15 to 35
	- Costs 1 supply
	
### Veil:
	- Infestation is no longer required to build, will spread automatically (10m)
	- Will not auto-build off infestation
	- Two Veils cost increased from 15 to 25
	- Three Veils cost increased from 15 to 35
	- Costs 1 supply
	
### Harvester:
	- Adjusted health from 2000/2300 to 1600/2000
	- Adjusted armor from 200/320 to 100/300
	- Harvester cost increased to 10
	
### Hive:
	- Infestation spreads further (25m up from 20m)
	- Cost unchanged at 40 tRes
	- Healing rate lowered from 1s to 2s
	- Base armor increased from 750 to 1000
	- Matured armor increased from 1400 to 1500
	
### Cyst:
	- Can be built anywhere, cost 3 tRes.  They have 650 HP, and provide a small AOE of infestation
	- Do not require a connection to the hive or any other Cysts.
	- Model size increased by 50%
	- Cost 2 supply
	
### Infested Power Node:
	- Costs 15 tRes
	- Grants 20 supply
	- Takes 10 seconds to build
	- Has 2000 health and 500 armor

### Bonewall:
	- Has 300 health
	
### Biomass:
	- Disabled
	
### Contamination:
	- Disabled
	
### Rupture:
	- Disabled
	
### Focus:
	- Disabled
	
### Researches:
	- Leap research cost increased from 15 to 20
	- Leap research time increased from 40 to 60
	- Leap research requires two hives
	- Xenocide research cost increased from 25 to 30
	- Xenocide research time increased from 60 to 90
	- Xenocide research requires three hives
	- GorgeTunnels research cost decreased from 15 to 10
	- GorgeTunnels research time increased from 40 to 30
	- GorgeTunnels research required to build gorge tunnels.
	- GorgeTunnels research requires one hive
	- BileBomb research cost increased from 15 to 25
	- BileBomb research time increased from 40 to 60
	- BileBomb research requires two hives
	- Umbra research cost unchanged at 20
	- Umbra research time increased from 45 to 60
	- Umbra research requires two hives
	- Spores research cost increased from 20 to 30
	- Spores research time increased from 60 to 90
	- Spores research requires three hives
	- MetabolizeEnergy research time increased from 40 to 30
	- MetabolizeEnergy research requires one hive
	- MetabolizeHealth research cost increased from 20 to 25
	- MetabolizeHealth research time increased from 45 to 60
	- MetabolizeHealth research requires two hives
	- Stab research cost increased from 25 to 30
	- Stab research time increased from 60 to 90
	- Stab research requires three hives
	- Charge research cost increased from 15 to 20
	- Charge research time increased from 40 to 30
	- Charge research requires one hive
	- BoneShield research cost increased from 20 to 25
	- BoneShield research time increased from 40 to 60
	- BoneShield research requires two hives
	- Stomp research cost increased from 25 to 30
	- Stomp research time increased from 60 to 90
	- Stomp research requires three hives
	- First additional trait slot research cost is 25
	- First additional trait slot research time is 60s
	- Final trait slot research cost is 35
	- Final trait slot research time is 90s
	- Offensive trait research cost is 10
	- Offensive trait research time is 30s
	- Defensive trait research cost is 10
	- Defensive trait research time is 30s
	- Movement trait research cost is 10
	- Movement trait research time is 30s