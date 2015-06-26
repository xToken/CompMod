// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\CystAdjustments.lua
// - Dragon

local function GetClosestHive(origin)
	
	local ents = GetEntitiesForTeam("Hive", kAlienTeamType)
	local hive
    Shared.SortEntitiesByDistance(origin, ents)
	
	for i = 1, #ents do
		if ents and ents[i]:GetIsAlive() and ents[i]:GetIsBuilt() then
			hive = ents[i]
			break
		end
	end
    
    return hive
	
end

local function GetPathingDistance(origin1, origin2)
	local points = PointArray()
    Pathing.GetPathPoints(origin1, origin2, points)
    return points
end

local function GetPathingDistanceToClosestHive(origin)
	local hive = GetClosestHive(origin)
	if hive then
		local path = GetPathingDistance(origin, hive:GetOrigin())
		if path then
			return GetPointDistance(path)
		end
	end
	return 0
end

function GetCystHealthScalar(origin)

	local distance =  Clamp(GetPathingDistanceToClosestHive(origin), kMinCystScalingDistance, kMaxCystScalingDistance)
	if distance == 0 then
		return 1
	end
	return 1 - Clamp(((distance - kMinCystScalingDistance) / kMaxCystScalingDistance), 0, 1)
	
end

local oldCystOnCreate
oldCystOnCreate = Class_ReplaceMethod("Cyst", "OnCreate",
	function(self)
		oldCystOnCreate(self)
		if Server then
			self:AddTimedCallback(Cyst.UpdateMaxMatureHealth, 0.1)     
		end
    end
)

function Cyst:GetMatureMaxHealth()
    return math.max(self.hpscalar * kMatureCystHealth, kMinCystMatureHealth)
end

function Cyst:UpdateMaxMatureHealth()
    self.hpscalar = GetCystHealthScalar(self:GetOrigin())
end

function Cyst:GetMatureMaxArmor()
    return kMatureCystArmor
end

function UpdateEveryCystMaxHP()
	local cysts = GetEntitiesForTeam("Cyst", kAlienTeamType)
	for i = 1, #cysts do
		if cysts[i] and cysts[i]:GetIsAlive() then
			cysts[i]:UpdateMaxMatureHealth()
		end
	end
end

Shared.LinkClassToMap("Cyst", Cyst.kMapName, { hpscalar = "float (0 to 1 by 0.01)" })