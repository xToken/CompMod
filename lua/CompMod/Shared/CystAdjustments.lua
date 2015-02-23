//Dont want to always replace random files, so this.

function GetCystDistanceToConnectedHive(cyst)
	
	local distance = 0
	local child, parent
	child = cyst
	
	for i = 1, 40 do //Max 40 cysts in chain
		parent = child:GetCystParent()
		
		if parent then
			local path = CreateBetweenEntities(child, parent)
			if path then
				distance = distance + GetPointDistance(path)
			end
			if parent:isa("Hive") then
				break
			end
		else
			break
		end
		
		child = parent
	end
	return distance
	
end

function GetCystConstructionTime(cyst)

	if not cyst.cachedbuildTime then
		local distance = GetCystDistanceToConnectedHive(cyst)
		if distance == 0 then
			//Parent might not be updated yet, just return default time for now
			Shared.Message("Cyst parent not yet valid, or invalid distance returned")
			return kCystBuildTime
		end
		local buildTime = Clamp(distance * kCystBuildTimePerMeter, kMinCystBuildTime, kMaxCystBuildTime) 
		cyst.cachedbuildTime = buildTime
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