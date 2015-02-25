//Dont want to always replace random files, so this.

local debugCystDistance = false
local function ToggleCystDistance(enabled)
    debugCystDistance = enabled ~= "false"
end
Event.Hook("Console_cystdistance", ToggleCystDistance)

function GetCystDistanceToConnectedHive(cyst)
	
	local distance, cysts, hdistance
	local child, parent
	child = cyst
	distance = 0
	cysts = 0
	hdistance = 0
	
	parent = child:GetCystParent()
	
	if parent then
		while not parent:isa("Hive") do
					
			local path = CreateBetweenEntities(child, parent)
			if path then
				distance = distance + GetPointDistance(path)
			end
			
			cysts = cysts + 1
			child = parent
			parent = child:GetCystParent()
			if not parent then
				break
			end
			
		end
		
		if parent:isa("Hive") then
			local path = CreateBetweenEntities(cyst, parent)
			if path then
				hdistance = GetPointDistance(path)
			end
		end			
		
	end
	
	return distance, cysts, hdistance
	
end

function GetCystConstructionTime(cyst)

	if not cyst.cachedbuildTime then
		local distance, cysts, hdistance = GetCystDistanceToConnectedHive(cyst)
		distance = math.min(distance, kMaxCystBuildTimeDistance)
		local dScale = distance / kMaxCystBuildTimeDistance
		if dScale == 0 then
			//Parent might not be updated yet, just return default time for now
			//Shared.Message("Cyst parent not yet valid, or invalid distance returned")
			return kCystBuildTime
		end
		local buildTime = math.max(dScale * kMaxCystBuildTime, kMinCystBuildTime) 
		cyst.cachedbuildTime = buildTime
		if debugCystDistance then
			Shared.Message(string.format("Cyst build time set to %s, distance %s, hive distance %s, cysts %s", buildTime, distance, hdistance, cysts))
		end
	end
	return cyst.cachedbuildTime
	
end

function ConstructMixin:GetTotalConstructionTime()
	if LookupTechData(self:GetTechId(), kTechDataCustomBuildTime, false) then
		local method = LookupTechData(self:GetTechId(), kTechDataCustomBuildTimeFunction, nil)
		if method then
			return method(self)
		end
	end
	return LookupTechData(self:GetTechId(), kTechDataBuildTime, kDefaultBuildTime)
end