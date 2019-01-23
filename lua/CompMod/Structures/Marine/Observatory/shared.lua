-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Marine\Observatory\shared.lua
-- - Dragon

local originalObservatoryOnInitialized
originalObservatoryOnInitialized = Class_ReplaceMethod("Observatory", "OnInitialized",
    function(self)        
        originalObservatoryOnInitialized(self)
        if Server then
        	InitMixin(self, SupplyUserMixin)
        end
    end
)