-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\Marine.lua
-- - Dragon

Script.Load( "lua/CompMod/Shared/WalkMixin.lua" )

local networkVars =
{
    utilitySlot4 = "enum kTechId",
	utilitySlot5 = "enum kTechId",
}

AddMixinNetworkVars(WalkMixin, networkVars)

local originalMarineOnInitialized
originalMarineOnInitialized = Class_ReplaceMethod("Marine", "OnInitialized",
	function(self)
		originalMarineOnInitialized(self)
		InitMixin(self, WalkMixin)
		self.utilitySlot4 = kTechId.None
		self.utilitySlot5 = kTechId.None
	end
)

function Marine:GetUtilitySlotTechId(slot)
    return slot == 4 and self.utilitySlot4 or self.utilitySlot5
end

-- Offer overrides to increase ROF (Catalyst ONLY increases reload speeds in vanilla)
local originalMarineOnUpdateAnimationInput
originalMarineOnUpdateAnimationInput = Class_ReplaceMethod("Marine", "OnUpdateAnimationInput",
	function(self, modelMixin)
		PROFILE("Marine:OnUpdateAnimationInput")
    
		Player.OnUpdateAnimationInput(self, modelMixin)
		
		local animationLength = modelMixin:isa("ViewModel") and 0 or 0.5
		
		if not self:GetIsJumping() and self:GetIsSprinting() then
			modelMixin:SetAnimationInput("move", "sprint")
		end

		if self:GetIsStunned() and self:GetRemainingStunTime() > animationLength then
			modelMixin:SetAnimationInput("move", "stun")
		end
		
		local activeWeapon = self:GetActiveWeapon()
		local catalystSpeed = 1
		local attackSpeed = 1
		
		if activeWeapon and activeWeapon.GetCatalystSpeedBase then
			catalystSpeed = activeWeapon:GetCatalystSpeedBase()
		end
		
		if self.catpackboost then
			catalystSpeed = kCatPackWeaponSpeed * catalystSpeed
		end
		
		if activeWeapon and activeWeapon.GetBaseAttackSpeed then
			attackSpeed = activeWeapon:GetBaseAttackSpeed()
		end
		
		modelMixin:SetAnimationInput("attack_speed", attackSpeed)

		modelMixin:SetAnimationInput("catalyst_speed", catalystSpeed)
	end
)

local originalMarineGetArmorAmount
originalMarineGetArmorAmount = Class_ReplaceMethod("Marine", "GetArmorAmount",
	function(self, armorLevels)
		if not armorLevels then
    
			armorLevels = 0
		
			local teamInfo = GetTeamInfoEntity(self:GetTeamNumber())
			if teamInfo then
				armorLevels = teamInfo:GetUpgradeLevel(kTechId.ArmorArmsLab)
			end
		
		end
		
		return Marine.kBaseArmor + armorLevels * Marine.kArmorPerUpgradeLevel
	end
)

local originalMarineGetWeaponLevel
originalMarineGetWeaponLevel = Class_ReplaceMethod("Marine", "GetWeaponLevel",
	function(self)
		local weaponLevel = 0

		local teamInfo = GetTeamInfoEntity(self:GetTeamNumber())
		if teamInfo then
			weaponLevel = teamInfo:GetUpgradeLevel(kTechId.WeaponsArmsLab)
		end
		
		return weaponLevel
	end
)

-- Disable Sprint
function SprintMixin:UpdateSprintingState(input)
	self:UpdateWalkMode(input)
end

local originalMarineGetPlayFootsteps
originalMarineGetPlayFootsteps = Class_ReplaceMethod("Marine", "GetPlayFootsteps",
	function(self)
		return originalMarineGetPlayFootsteps(self) and not self:GetIsWalking()
	end
)

local originalMarineGetInventorySpeedScalar
originalMarineGetInventorySpeedScalar = Class_ReplaceMethod("Marine", "GetInventorySpeedScalar",
	function(self)
		return Clamp(math.cos(self:GetWeaponsWeight()), 0.5, 1)
	end
)

local originalMarineGetMaxSpeed
originalMarineGetMaxSpeed = Class_ReplaceMethod("Marine", "GetMaxSpeed",
	function(self, possible)
		if possible then
			return Marine.kRunMaxSpeed
		end

		local maxSpeed = Marine.kWalkMaxSpeed
		maxSpeed = ConditionalValue(self:GetIsWalking(), kMarineMaxSlowWalkSpeed, maxSpeed)
		
		-- Take into account our weapon inventory and current weapon. Assumes a vanilla marine has a scalar of around .8.
		local inventorySpeedScalar = self:GetInventorySpeedScalar()
		local useModifier = 1

		local activeWeapon = self:GetActiveWeapon()
		if activeWeapon and self.isUsing and activeWeapon:GetMapName() == Builder.kMapName then
			useModifier = 0.5
		end

		if self.catpackboost then
			maxSpeed = maxSpeed + kCatPackMoveAddSpeed
		end
		
		return maxSpeed * self:GetSlowSpeedModifier() * inventorySpeedScalar  * useModifier
	end
)

-- Set updated speed
Marine.kWalkMaxSpeed = kMarineWalkMaxSpeed

Shared.LinkClassToMap("Marine", Marine.kMapName, networkVars, true)