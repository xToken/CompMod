-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Hive\server.lua
-- - Dragon

local function UpdateHealing(self)

    if GetIsUnitActive(self) then

        if self.timeOfLastHeal == nil or Shared.GetTime() > (self.timeOfLastHeal + Hive.kHealthUpdateTime) then

            -- Heal players and egg, so we can't spot an embryo (evolving alien) easily by shooting
            -- an egg and check for the hive regen to apply.
            local healedEntitiesName = {"Player", "Egg", "Drifter"}
            for _, healedEntityName in ipairs(healedEntitiesName) do
                for index, ent in ipairs(GetEntitiesForTeam(healedEntityName, self:GetTeamNumber())) do

                    if ent:GetIsAlive() and ((ent:GetOrigin() - self:GetOrigin()):GetLength() < Hive.kHealRadius) then
                        -- min healing, affects skulk only
                        ent:AddHealth(math.max(10, ent:GetMaxHealth() * Hive.kHealthPercentage), true )
                    end

                end

                self.timeOfLastHeal = Shared.GetTime()

            end
        end

    end

end

ReplaceLocals(Hive.OnUpdate, { UpdateHealing = UpdateHealing })

function Hive:OnTeleport()
    self:SetDesiredInfestationRadius(0)
end

function Hive:OnTeleportFailed()
    self:SetDesiredInfestationRadius(self:GetInfestationMaxRadius())
end

function Hive:OnTeleportEnd()

    local attachedTechPoint = self:GetAttached()
    if attachedTechPoint then
        attachedTechPoint:SetIsSmashed(true)
    end

    self.startGrown = false
    self:CleanupInfestation()

    local commander = self:GetCommander()

    if commander then

        -- we assume onos extents for now, save lastExtents in commander
        for index = 1, 150 do
            local extents = LookupTechData(kTechId.Onos, kTechDataMaxExtents, nil)
            local randomSpawn = GetRandomSpawnForCapsule(extents.y, extents.x, self:GetOrigin(), 2, 15, EntityFilterAll())
            if randomSpawn then
                commander.lastGroundOrigin = randomSpawn
                break
            end
        end

    end

end

function Hive:HatchEggs()
    local amountEggsForHatch = ScaleWithPlayerCount(kEggsPerHatch, #GetEntitiesForTeam("Player", self:GetTeamNumber()), true)
    local eggCount = 0
    for i = 1, 20 do
        local egg = self:SpawnEgg(true)
        if egg then eggCount = eggCount + 1 end
        if eggCount >= amountEggsForHatch then break end
    end

    if eggCount > 0 then
        self:TriggerEffects("hatch")
        return true
    end

    return false
end