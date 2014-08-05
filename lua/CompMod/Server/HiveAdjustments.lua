//Dont want to always replace random files, so this.

// Changes to handle evolution chamber for each Hive.
local oldHiveOnConstructionComplete = Hive.OnConstructionComplete
function Hive:OnConstructionComplete()
    oldHiveOnConstructionComplete(self)
	local evochamber = CreateEntityForTeam(kTechId.EvolutionChamber, self:GetOrigin(), self:GetTeamNumber(), nil)
	if evochamber then
		local origin = evochamber:GetOrigin()
		origin.y = origin.y - 3.9
		evochamber:SetOrigin(origin)
		self:SetEvolutionChamber(evochamber:GetId())
	end
end

function Hive:SetEvolutionChamber(chamberId)
	self.evochamber = chamberId
end

local oldHiveOnKill = Hive.OnKill
function Hive:OnKill(attacker, doer, point, direction)
	oldHiveOnKill(self, attacker, doer, point, direction)
	if self:GetEvolutionChamber() ~= Entity.invalidId and self:GetIsBuilt() then
		local evochamber = Shared.GetEntity(self:GetEvolutionChamber())
		local techTree = self:GetTeam():GetTechTree()
		if evochamber and evochamber:isa("EvolutionChamber") then
			if techTree then
				evochamber:PerformAction(techTree:GetTechNode(kTechId.Cancel), evochamber:GetOrigin()) // Trigger research abort :S
			end
			DestroyEntity(evochamber)
		end
	end
end