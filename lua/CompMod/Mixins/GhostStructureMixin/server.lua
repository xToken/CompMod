-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Mixins\GhostStructureMixin\server.lua
-- - Dragon

local function ClearGhostStructure(self)

    self.isGhostStructure = false
    self:TriggerEffects("ghoststructure_destroy")
    local cost = math.round(LookupTechData(self:GetTechId(), kTechDataCostKey, 0) * kRecyclePaybackScalar)
    self:GetTeam():AddTeamResources(cost)
    self:GetTeam():PrintWorldTextForTeamInRange(kWorldTextMessageType.Resources, cost, self:GetOrigin() + kWorldMessageResourceOffset, kResourceMessageRange)
    DestroyEntity(self)
    
end

ReplaceUpValue(GhostStructureMixin.OnUpdate, "ClearGhostStructure", ClearGhostStructure, { LocateRecurse = true } )
ReplaceUpValue(GhostStructureMixin.OnTouchInfestation, "ClearGhostStructure", ClearGhostStructure)
ReplaceUpValue(GhostStructureMixin.OnTakeDamage, "ClearGhostStructure", ClearGhostStructure)