//Dont want to always replace random files, so this.

local debugCystDistance = false
local function ToggleCystDistance(enabled)
    debugCystDistance = enabled ~= "false"
end
Event.Hook("Console_cystdistance", ToggleCystDistance)

function GetClosestHive(origin)
	
	local ents = GetEntitiesForTeam("Hive", kAlienTeamType)
    Shared.SortEntitiesByDistance(origin, ents)
    
    return ents[1]
	
end

function GetPathingDistance(origin1, origin2)
	local points = PointArray()
    Pathing.GetPathPoints(origin1, origin2, points)
    return points
end

function GetPathingDistanceToClosestHive(origin)
	local hive = GetClosestHive(origin)
	if hive then
		local path = GetPathingDistance(origin, hive:GetOrigin())
		if path then
			return GetPointDistance(path)
		end
	end
	return 0
end

function GetCystConstructionTime(origin)

	local distance =  math.min(GetPathingDistanceToClosestHive(origin), kMaxCystBuildTimeDistance)
	if distance == 0 then
		return kCystBuildTime
	end
	local buildTime = math.max((distance / kMaxCystBuildTimeDistance) * kMaxCystBuildTime, kMinCystBuildTime) 
	if debugCystDistance then
		Shared.Message(string.format("Cyst build time set to %s, distance %s", buildTime, distance))
	end
	return buildTime
	
end

function ConstructMixin:GetTotalConstructionTime()
	if LookupTechData(self:GetTechId(), kTechDataCustomBuildTime, false) then
		local method = LookupTechData(self:GetTechId(), kTechDataCustomBuildTimeFunction, nil)
		if method and not self.cachedbuildTime then
			self.cachedbuildTime = method(self:GetOrigin())
		end
		return self.cachedbuildTime
	end
	return LookupTechData(self:GetTechId(), kTechDataBuildTime, kDefaultBuildTime)
end