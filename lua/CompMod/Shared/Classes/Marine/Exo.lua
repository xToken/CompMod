-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\Exo.lua
-- - Dragon

local kExoScale = 0.9

local networkVars =
{
    exo_upg1 = "boolean",
	exo_upg2 = "boolean",
}

local originalExoOnInitialized
originalExoOnInitialized = Class_ReplaceMethod("Exo", "OnInitialized",
	function(self)
		originalExoOnInitialized(self)
		self.exo_upg1 = false
		self.exo_upg2 = false
		
		if Server then
			self:AddTimedCallback(Exo.OnTechOrResearchUpdated, 0.1)
		end
		
	end
)

function Exo:OnAdjustModelCoords(modelCoords)
	modelCoords.xAxis = modelCoords.xAxis * kExoScale
	modelCoords.yAxis = modelCoords.yAxis * kExoScale
	modelCoords.zAxis = modelCoords.zAxis * kExoScale
    return modelCoords
end

function Exo:OnTechOrResearchUpdated()
	if GetHasTech(self, kTechId.ExoUpgrade1) then
		self.exo_upg1 = true
	else
		self.exo_upg1 = false
	end
	if GetHasTech(self, kTechId.ExoUpgrade2) then
		self.exo_upg2 = true
	else
		self.exo_upg2 = false
	end
end

function Exo:GetMaxBackwardSpeedScalar()
    return 0.6
end

Shared.LinkClassToMap("Exo", Exo.kMapName, networkVars, true)

-- Actually set these values since locals
ReplaceLocals(Exo.GetMaxSpeed, { kMaxSpeed = kExoMaxSpeed })