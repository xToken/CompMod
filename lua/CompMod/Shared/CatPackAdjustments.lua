//Dont want to always replace random files, so this.

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