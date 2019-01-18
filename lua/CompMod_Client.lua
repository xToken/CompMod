-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod_Client.lua
-- - Dragon

-- Loads Client VM changes

-- Load shared defs
Script.Load("lua/CompMod_Shared.lua")

-- Load client specific changes
Script.Load("lua/CompMod/Utilities/CustomBindings/client.lua")
Script.Load("lua/CompMod/Utilities/CustomGamestrings/client.lua")
Script.Load("lua/CompMod/Utilities/TextureReplacer/client.lua")

Script.Load("lua/CompMod/Classes/Alien/Alien/client.lua")
Script.Load("lua/CompMod/Classes/Alien/AlienCommander/client.lua")
Script.Load("lua/CompMod/Classes/Commander/client.lua")
Script.Load("lua/CompMod/Classes/Marine/Marine/client.lua")
Script.Load("lua/CompMod/Classes/Player/client.lua")
Script.Load("lua/CompMod/Classes/ReadyRoomPlayer/client.lua")

Script.Load("lua/CompMod/Mixins/MaturityMixin/client.lua")
Script.Load("lua/CompMod/Mixins/WalkMixin/client.lua")

Script.Load("lua/CompMod/Structures/Alien/Crag/client.lua")
Script.Load("lua/CompMod/Structures/Alien/Harvester/client.lua")
Script.Load("lua/CompMod/Structures/Alien/Hive/client.lua")
Script.Load("lua/CompMod/Structures/Alien/Shade/client.lua")
Script.Load("lua/CompMod/Structures/Alien/Shell/client.lua")
Script.Load("lua/CompMod/Structures/Alien/Shift/client.lua")
Script.Load("lua/CompMod/Structures/Alien/Spur/client.lua")
Script.Load("lua/CompMod/Structures/Alien/Veil/client.lua")
Script.Load("lua/CompMod/Structures/Marine/RoboticsFactory/client.lua")
--Script.Load("lua/CompMod/Structures/Marine/PowerPoint/client.lua")

Script.Load("lua/CompMod/TechTreeButtons/client.lua")