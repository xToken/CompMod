-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Marine\PowerPoint\server.lua
-- - Dragon

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
