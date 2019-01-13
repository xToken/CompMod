-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua/CompMod_Server.lua
-- - Dragon

-- Loads Server VM changes

-- Load shared defs
Script.Load("lua/CompMod_Shared.lua")

-- Load server side adjustments
Script.Load("lua/CompMod/Utilities/GameReporter/server.lua")

Script.Load("lua/CompMod/AlienUpgradeManager/server.lua")
Script.Load("lua/CompMod/NS2Utility/server.lua")

Script.Load("lua/CompMod/Classes/Alien/Alien/server.lua")
Script.Load("lua/CompMod/Classes/Alien/AlienCommander/server.lua")
Script.Load("lua/CompMod/Classes/Alien/Embryo/server.lua")
Script.Load("lua/CompMod/Classes/Commander/server.lua")
Script.Load("lua/CompMod/Classes/Marine/Exo/server.lua")
Script.Load("lua/CompMod/Classes/Marine/JetpackMarine/server.lua")
Script.Load("lua/CompMod/Classes/Marine/Marine/server.lua")
Script.Load("lua/CompMod/Classes/Marine/MarineCommander/server.lua")
Script.Load("lua/CompMod/Classes/Marine/MarineSpectator/server.lua")
Script.Load("lua/CompMod/Classes/Player/server.lua")

Script.Load("lua/CompMod/Mixins/CatalystMixin/server.lua")
Script.Load("lua/CompMod/Mixins/ConstructMixin/server.lua")
Script.Load("lua/CompMod/Mixins/GhostStructureMixin/server.lua")
Script.Load("lua/CompMod/Mixins/MaturityMixin/server.lua")
Script.Load("lua/CompMod/Mixins/OrdersMixin/server.lua")
Script.Load("lua/CompMod/Mixins/TeleportMixin/server.lua")

Script.Load("lua/CompMod/Structures/Alien/Crag/server.lua")
Script.Load("lua/CompMod/Structures/Alien/Harvester/server.lua")
Script.Load("lua/CompMod/Structures/Alien/Hive/server.lua")
Script.Load("lua/CompMod/Structures/Alien/Hydra/server.lua")
Script.Load("lua/CompMod/Structures/Alien/Shade/server.lua")
Script.Load("lua/CompMod/Structures/Alien/Shell/server.lua")
Script.Load("lua/CompMod/Structures/Alien/Shift/server.lua")
Script.Load("lua/CompMod/Structures/Alien/Spur/server.lua")
Script.Load("lua/CompMod/Structures/Alien/Veil/server.lua")
Script.Load("lua/CompMod/Structures/Alien/Whip/server.lua")
Script.Load("lua/CompMod/Structures/Marine/ARC/server.lua")
Script.Load("lua/CompMod/Structures/Marine/ArmsLab/server.lua")
Script.Load("lua/CompMod/Structures/Marine/PowerPoint/server.lua")

Script.Load("lua/CompMod/Teams/AlienTeam/server.lua")
Script.Load("lua/CompMod/Teams/MarineTeam/server.lua")
Script.Load("lua/CompMod/Teams/PlayingTeam/server.lua")

Script.Load("lua/CompMod/Weapons/Weapon/server.lua")