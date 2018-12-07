-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\MarineStructureAdjustments.lua
-- - Dragon

function PowerPoint:GetCanTakeDamageOverride()
    return false
end

function PowerConsumerMixin:GetIsPowered() 
    return true
end

if Server then
	local kUnsocketedSocketModelName = GetUpValue( PowerPoint.SetInternalPowerState, "kUnsocketedSocketModelName" )
	local kUnsocketedAnimationGraph
	
	local originalPowerPointOnCreate
	originalPowerPointOnCreate = Class_ReplaceMethod("PowerPoint", "OnCreate",
		function(self)
			originalPowerPointOnCreate(self)
			self:SetInternalPowerState(PowerPoint.kPowerState.socketed)
			self:SetConstructionComplete()
			self:SetLightMode(kLightMode.Normal)
			self:SetPoweringState(true)
			self:SetModel(kUnsocketedSocketModelName, kUnsocketedAnimationGraph)
		end
	)

	local originalPowerPointReset
	originalPowerPointReset = Class_ReplaceMethod("PowerPoint", "Reset",
		function(self)
			originalPowerPointReset(self)
			self:SetInternalPowerState(PowerPoint.kPowerState.socketed)
			self:SetConstructionComplete()
			self:SetLightMode(kLightMode.Normal)
			self:SetPoweringState(true)
			self:SetModel(kUnsocketedSocketModelName, kUnsocketedAnimationGraph)
		end
	)

end