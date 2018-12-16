-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\Drifter.lua
-- - Dragon

Drifter.kHoverHeight = 1

function Drifter:GetTechButtons(techId)
    return { kTechId.Grow, kTechId.Move, kTechId.Patrol, kTechId.FollowAlien,
        kTechId.None, kTechId.None, kTechId.None, kTechId.None }
end