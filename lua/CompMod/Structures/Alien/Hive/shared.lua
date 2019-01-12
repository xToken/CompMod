-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Hive\shared.lua
-- - Dragon

Hive.kHealthUpdateTime = 1
Hive.kHealthPercentage = .06

function Hive:GetTechButtons()

    local techButtons = { kTechId.ShiftHatch, kTechId.None, kTechId.AdditionalTraitSlot1, kTechId.LifeFormMenu,
                          kTechId.MovementTraits, kTechId.OffensiveTraits, kTechId.DefensiveTraits, kTechId.None }

    if GetHasTech(self, kTechId.AdditionalTraitSlot1) then
    
        techButtons[3] = kTechId.AdditionalTraitSlot2
    
    end
    
    return techButtons
    
end

local kDrifterSpawnOffset = 2.0
function Hive:OverrideCreateManufactureEntity(techId)

    if techId == kTechId.Drifter then
    
        local mapName = LookupTechData(techId, kTechDataMapName)
        local origin = self:GetOrigin() + Vector(GetSign(math.random() - 0.5) * kDrifterSpawnOffset, 0, GetSign( math.random() - 0.5) * kDrifterSpawnOffset)
        entity = CreateEntity(mapName, origin, self:GetTeamNumber())
        entity:SetOwner(self:GetIssuedCommander())
        
        if entity.ProcessRallyOrder then
            entity:ProcessRallyOrder(self)
        end

        return entity
        
    end
    
end

local networkVars = { }

AddMixinNetworkVars(OrdersMixin, networkVars)

local originalHiveOnCreate
originalHiveOnCreate = Class_ReplaceMethod("Hive", "OnCreate",
	function(self)
		originalHiveOnCreate(self)
		InitMixin(self, OrdersMixin, { kMoveOrderCompleteDistance = kAIMoveOrderCompleteDistance })
	end
)

Shared.LinkClassToMap("Hive", Hive.kMapName, networkVars)