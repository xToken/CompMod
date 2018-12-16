-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\MarineCommander.lua
-- - Dragon

local networkVars =
{
    aarmslab = "private integer (0 to 3)",
    warmslab = "private integer (0 to 3)",
}

local function OnUpdateArmsLabs(self)
	local team = self:GetTeam()
	if team then
		self.warmslab = Clamp(team:CountTrackedEntities(kTechId.WeaponsArmsLab), 0 ,3)
		self.aarmslab = Clamp(team:CountTrackedEntities(kTechId.ArmorArmsLab), 0 ,3)
	end
end

local originalMarineCommanderOnInitialized
originalMarineCommanderOnInitialized = Class_ReplaceMethod("MarineCommander", "OnInitialized",
	function(self)
		originalMarineCommanderOnInitialized(self)
		self.aarmslab = 0
		self.warmslab = 0
		if Server then
			self:AddTimedCallback(OnUpdateArmsLabs, 0.05)
		end
	end
)

function MarineCommander:GetTrackedStructures(techId)
    if techId == kTechId.WeaponsArmsLab then
		return self.warmslab
	elseif techId == kTechId.ArmorArmsLab then
		return self.aarmslab
	end
	return 0
end

Shared.LinkClassToMap( "MarineCommander", MarineCommander.kMapName, networkVars )