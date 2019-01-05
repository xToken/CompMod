-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Marine\Marine\shared.lua
-- - Dragon

Script.Load( "lua/CompMod/Mixins/WalkMixin/shared.lua" )

local networkVars =
{
    utilitySlot3 = "enum kTechId",
	utilitySlot5 = "enum kTechId",
	nanoArmor = "boolean",
    timeNanoArmorHealed = "private compensated  time",
}

AddMixinNetworkVars(WalkMixin, networkVars)
AddMixinNetworkVars(DetectableMixin, networkVars)

local originalMarineOnInitialized
originalMarineOnInitialized = Class_ReplaceMethod("Marine", "OnInitialized",
	function(self)
		originalMarineOnInitialized(self)
		InitMixin(self, WalkMixin)
		InitMixin(self, DetectableMixin)
		self.utilitySlot3 = kTechId.None
		self.utilitySlot5 = kTechId.None
		self.nanoArmor = false
		self.timeNanoArmorHealed = 0
	end
)

function Marine:GetUtilitySlotTechId(slot)
    return slot == 3 and self.utilitySlot3 or self.utilitySlot5
end

function Marine:SensorBlipType()
	return AlienSensorBlip.kMapName
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

local originalMarineGetAirControl
originalMarineGetAirControl = Class_ReplaceMethod("Marine", "GetAirControl",
	function(self)
		return 15 * self:GetSlowSpeedModifier()
	end
)

local originalMarineGetSlowOnLand
originalMarineGetSlowOnLand = Class_ReplaceMethod("Marine", "GetSlowOnLand",
	function(self, impactForce)
		return math.abs(impactForce) > self:GetMaxSpeed()
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

local oldMarineOnProcessMove
oldMarineOnProcessMove = Class_ReplaceMethod("Marine", "OnProcessMove",
	function(self, input)
		oldMarineOnProcessMove(self, input)
		-- check nano armor
        if not self:GetIsInCombat() and self.nanoArmor and self.timeNanoArmorHealed + kNanoArmorHealInterval < Shared.GetTime() then            
            self:SetArmor(self:GetArmor() + kNanoArmorHealInterval * kNanoArmorHealPerSecond, false)
			self.timeNanoArmorHealed = Shared.GetTime()
        end
	end
)

-- Set updated speed
Marine.kWalkMaxSpeed = kMarineWalkMaxSpeed

Shared.LinkClassToMap("Marine", Marine.kMapName, networkVars, true)