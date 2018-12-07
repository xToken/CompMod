-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Server\AlienTeamAdjustments.lua
-- - Dragon

-- Block spawning of cysts on round start
local function CreateNothing()
end

ReplaceLocals(AlienTeam.SpawnInitialStructures, { CreateCysts = CreateNothing })