-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Server\Hive.lua
-- - Dragon

local function UpdateHealing(self)

    if GetIsUnitActive(self) then

        if self.timeOfLastHeal == nil or Shared.GetTime() > (self.timeOfLastHeal + Hive.kHealthUpdateTime) then

            -- Heal players and egg, so we can't spot an embryo (evolving alien) easily by shooting
            -- an egg and check for the hive regen to apply.
            local healedEntitiesName = {"Player", "Egg"}
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