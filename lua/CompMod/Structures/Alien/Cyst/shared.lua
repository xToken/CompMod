-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Cyst\shared.lua
-- - Dragon

-- CYST
local originalCystOnInitialized
originalCystOnInitialized = Class_ReplaceMethod("Cyst", "OnInitialized",
    function(self)        
        originalCystOnInitialized(self)
        if Server then
            InitMixin(self, SupplyUserMixin)
        end
    end
)

local kCystScale = 1.5

function Cyst:OnAdjustModelCoords(modelCoords)
	modelCoords.xAxis = modelCoords.xAxis * kCystScale
	modelCoords.yAxis = modelCoords.yAxis * kCystScale
	modelCoords.zAxis = modelCoords.zAxis * kCystScale
    return modelCoords
end

function Cyst:DisableSustenance()
	return true
end

function Cyst:GetCanAutoBuild()
    return true
end

function Cyst:GetMatureMaxHealth()
    return kMatureCystHealth
end 

if Server then
  
    function Cyst:OnUpdate(deltaTime)

        PROFILE("Cyst:OnUpdate")
        
        ScriptActor.OnUpdate(self, deltaTime)

        self.connected = true
        
        if not self:GetIsAlive() then
        
            local destructionAllowedTable = { allowed = true }
            if self.GetDestructionAllowed then
                self:GetDestructionAllowed(destructionAllowedTable)
            end
            
            if destructionAllowedTable.allowed then
                DestroyEntity(self)
            end
        
        end
        
    end

end