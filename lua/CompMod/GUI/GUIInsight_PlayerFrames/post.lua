-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIInsight_PlayerFrames\post.lua
-- - Dragon

local kRed = Color(1, 0, 0, 1)
function GUIInsight_PlayerFrames:UpdateTechColors(team)
    local teamNumber = team.TeamNumber
    local teamColor = PlayerUI_GetTeamColor(teamNumber)
    team.TechColors = {
        [0] = teamColor,
        [kTechId.CragHive] = GetShellLevel(teamNumber) == 0 and kRed or teamColor,
        [kTechId.ShiftHive] = GetSpurLevel(teamNumber) == 0 and kRed or teamColor,
        [kTechId.ShadeHive] = GetVeilLevel(teamNumber) == 0 and kRed or teamColor
    }
end