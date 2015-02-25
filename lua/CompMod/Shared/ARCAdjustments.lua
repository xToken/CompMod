//Dont want to always replace random files, so this.

local oldARCOnCreate
oldARCOnCreate = Class_ReplaceMethod("ARC", "OnCreate",
	function(self)
		oldARCOnCreate(self)
		self.speedboost = false
		self.oncooldown = false		
    end
)

local oldARCPerformActivation
oldARCPerformActivation = Class_ReplaceMethod("ARC", "PerformActivation",
	function(self, techId, position, normal, commander)
		if techId == kTechId.ARCSpeedBoost and not self.oncooldown then
			self:TriggerSpeedBoost()
			return true, true
		else
			return oldARCPerformActivation(self, techId, position, normal, commander)
		end  
    end
)

local oldARCGetActivationTechAllowed
oldARCGetActivationTechAllowed = Class_ReplaceMethod("ARC", "GetActivationTechAllowed",
	function(self, techId)
		if techId == kTechId.ARCSpeedBoost then
			return self.deployMode == ARC.kDeployMode.Undeployed and not self.oncooldown
		else
			return oldARCGetActivationTechAllowed(self, techId)
		end
    end
)

local oldARCGetTechButtons
oldARCGetTechButtons = Class_ReplaceMethod("ARC", "GetTechButtons",
	function(self, techId)

		local techButtons = oldARCGetTechButtons(self, techId)
		techButtons[3] = kTechId.ARCSpeedBoost
		return techButtons
		
	end
)

function ARC:HasSpeedBoost()
	return self.speedboost
end

function ARC:SpeedBoostOnCooldown()
	return self.oncooldown
end

local function SpeedBoostOffCooldown(self)
	self.speedboost = false
	self.oncooldown = false
	return false
end

local function DisableSpeedBoost(self)
	self.speedboost = false
	self:AddTimedCallback(SpeedBoostOffCooldown, kARCSpeedBoostCooldown)
	return false
end

function ARC:TriggerSpeedBoost()
	self.speedboost = true
	self.oncooldown = true
	self.speedboosttime = Shared.GetTime()
	self:AddTimedCallback(DisableSpeedBoost, kARCSpeedBoostDuration)
end

function ARC:ModifyMaxSpeed(maxSpeedTable)
	if self.speedboost then
		maxSpeedTable.maxSpeed = ARC.kMoveSpeed * kARCSpeedBoostIncrease
	end
end

Shared.LinkClassToMap("ARC", ARC.kMapName, { speedboost = "boolean", oncooldown = "boolean" }, true)