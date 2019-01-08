-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\TechData\post.lua
-- - Dragon

kTechDataIDName = "techdataidname"
kTechDataButtonID = "techdatabuttonid"
kTechDataRequiresSecondPlacement = "techdatarequirestwoplacements"
kTechDataDescription = "techdatadescription"
kTechDataUnlockAction = "techdataunlockaction"
kTechDataNotifyPlayers = "techdatanotifyplayers"
kTechDataRequiredTechs = "techdatarequiredtechs"

Script.Load("lua/CompMod/TechData/NewTechData.lua")

local techDataUpdatesBuilt = false
local newTechTable = { }
local updatedTechTable = { }

-- Take all the updated tech IDs kTechData keys, insert into single table for easy checking
local techIdUpdatedKeys = { }
local techIdUpdatedFields = { } -- LUA tables make me sad sometimes
		
local function BuildTechDataUpdates()
	if not techDataUpdatesBuilt then
		newTechTable, updatedTechTable = BuildCompModTechDataUpdates()
		for i = 1, #updatedTechTable do
			local updatedId = updatedTechTable[i][kTechDataId]
			table.insert(techIdUpdatedKeys, updatedId)
			techIdUpdatedFields[updatedId] = updatedTechTable[i]
		end
		techDataUpdatesBuilt = true
	end
end

function ReturnNewTechButtons()
	BuildTechDataUpdates()
	local tButtons = { }
	for i = 1, #newTechTable do
		if newTechTable[i][kTechDataButtonID] then
			tButtons[newTechTable[i][kTechDataId]] = newTechTable[i][kTechDataButtonID]
		end
	end
	for i = 1, #updatedTechTable do
		if updatedTechTable[i][kTechDataButtonID] then
			tButtons[updatedTechTable[i][kTechDataId]] = updatedTechTable[i][kTechDataButtonID]
		end
	end
	return tButtons
end

function IsTechIDUpdated(techId)
	return table.contains(techIdUpdatedKeys, techId)
end

function ReturnUpdatedTechData(techId)
	return techIdUpdatedFields[techId]
end

local function AddCompModTechChanges(techData)
	BuildTechDataUpdates()
	for _, record in ipairs(techData) do
		-- Update any existing techIDs
        if IsTechIDUpdated(record[kTechDataId]) then
			for k, v in pairs(ReturnUpdatedTechData(record[kTechDataId])) do
				record[k] = v
			end
		end
    end
	-- Add new tech IDs
	for _, techTable in ipairs(newTechTable) do
		table.insert(techData, techTable)
	end
end

-- You dumbass, the BuildTechData is global...
local oldBuildTechData = BuildTechData
function BuildTechData()
	local techData = oldBuildTechData()
	AddCompModTechChanges(techData)
	return techData
end