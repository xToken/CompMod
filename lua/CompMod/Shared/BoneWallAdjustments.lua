//Dont want to always replace random files, so this.

local oldBoneWallOnInitialized = BoneWall.OnInitialized
function BoneWall:OnInitialized()
	oldBoneWallOnInitialized(self)
	if Server then
		local team = self:GetTeam()
		if team then
			local level = math.max(0, team:GetBioMassLevel() - 1)
			local newMaxHealth = kBoneWallHealth + level * kBoneWallHealthPerBioMass
			if newMaxHealth ~= self.maxHealth  then
				self:SetMaxHealth(newMaxHealth)
				self:SetHealth(self.maxHealth)
			end
		end
	end
end

function BoneWall:GetCanBeHealedOverride()
    return false
end