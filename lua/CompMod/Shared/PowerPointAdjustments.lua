-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\PowerPointAdjustments.lua
-- - Dragon

-- Prevent damaging the power nodes
function PowerPoint:GetCanTakeDamageOverride()
    return false
end

function PowerPoint:OnTakeDamage()
end

function PowerPoint:DoDamageLighting()
end

-- Things are always powered.
function PowerConsumerMixin:GetIsPowered() 
    return true
end

-- Prevent minimap blip?
local oldMapBlipMixinGetMapBlipInfo = MapBlipMixin.GetMapBlipInfo
function MapBlipMixin:GetMapBlipInfo()
	if self:isa("PowerPoint") then
		return false, kMinimapBlipType.Undefined, -1, false, false
	end
	return oldMapBlipMixinGetMapBlipInfo(self)
end

-- Prevent unit status?
function PowerPoint:GetShowUnitStatusForOverride()
    return false
end

-- Always socketed/active/use unsockeded model
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