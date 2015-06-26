// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\CatPackAdjustments.lua
// - Dragon

//Fix for double catpacks?
function CatPack:OnInitialized()

    DropPack.OnInitialized(self)
    
    self:SetModel(CatPack.kModelName)
    
    InitMixin(self, PickupableMixin, { kRecipientType = {"Marine", "Exo"} })

end

//Fix for catpacks being pickedup while still have catalyst.
local originalMarineGetCanUseCatPack
originalMarineGetCanUseCatPack = Class_ReplaceMethod("Marine", "GetCanUseCatPack",
	function(self)
		local enoughTimePassed = self.timeCatpackboost + kCatPackCooldown < Shared.GetTime()
		return not self.catpackboost and enoughTimePassed
	end
)

local originalExoGetCanUseCatPack
originalExoGetCanUseCatPack = Class_ReplaceMethod("Exo", "GetCanUseCatPack",
	function(self)
		local enoughTimePassed = self.timeCatpackboost + kCatPackCooldown < Shared.GetTime()
		return not self.catpackboost and enoughTimePassed
	end
)