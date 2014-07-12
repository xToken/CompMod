//Dont want to always replace random files, so this.

//Speed up grenades.
//GRENADA!
local oldMarineOnUpdateAnimationInput = Marine.OnUpdateAnimationInput
function Marine:OnUpdateAnimationInput(modelMixin)
	oldMarineOnUpdateAnimationInput(self, modelMixin)
	local activeWeapon = self:GetActiveWeapon()
	local catalystSpeed = 1
	if activeWeapon and activeWeapon.GetCatalystSpeedBase then
		catalystSpeed = activeWeapon:GetCatalystSpeedBase()
	end
    if self.catpackboost then
        catalystSpeed = kCatPackWeaponSpeed * catalystSpeed
    end
    modelMixin:SetAnimationInput("catalyst_speed", catalystSpeed)
end

function GrenadeThrower:GetCatalystSpeedBase()
	return kGrenadeAnimationSpeedIncrease
end