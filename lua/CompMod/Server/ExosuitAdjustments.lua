//Dont want to always replace random files, so this.

local originalExoWeaponHolderSetWeapons = ExoWeaponHolder.SetWeapons
function ExoWeaponHolder:SetWeapons(weaponMapNameLeft, weaponMapNameRight)
	originalExoWeaponHolderSetWeapons(self, weaponMapNameLeft, weaponMapNameRight)
	//Meh not a huge fan of this.
	self.weaponSetupName = string.gsub(self.weaponSetupName, "exowelder", "claw")
	//Reset view model
	if self:GetIsActive() then
		local player = self:GetParent()
		player:SetViewModel(self:GetViewModelName(), self)
	end
end

local oldPowerPointOnWeldOverride = PowerPoint.OnWeldOverride
function PowerPoint:OnWeldOverride(entity, elapsedTime)
	if entity:isa("ExoWelder") then
		//Add Delta
		local amount = (kWelderPowerRepairRate * elapsedTime) - (kBuilderPowerRepairRate * elapsedTime)
		welded = (self:AddHealth(amount) > 0)                   
	end
	oldPowerPointOnWeldOverride(self, entity, elapsedTime)
end