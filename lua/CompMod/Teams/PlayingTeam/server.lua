-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Teams\PlayingTeam\server.lua
-- - Dragon

-- FHJKDSHFKJLSDFHDKJLSHFKJLD WHYYYYYYYYYYYY
PlayingTeam.kResearchDisplayTime = 15

-- Entity Constructed tracking
local function ClearEntityTrackingTables(self)
	self.trackedTeamEntities = { }
end

local originalPlayingTeamTeamInitialize
originalPlayingTeamTeamInitialize = Class_ReplaceMethod("PlayingTeam", "Initialize",
	function(self, teamName, teamNumber)
		originalPlayingTeamTeamInitialize(self, teamName, teamNumber)
		ClearEntityTrackingTables(self)
	end
)

local originalPlayingTeamOnInitialized
originalPlayingTeamOnInitialized = Class_ReplaceMethod("PlayingTeam", "OnInitialized",
	function(self)
		originalPlayingTeamOnInitialized(self)
		ClearEntityTrackingTables(self)
	end
)

function PlayingTeam:OnTrackedEntityChange(techId, newCount)
	local comm = self:GetCommander()
	if comm then
		-- Tell the comm immediately
		comm:TrackedEntityUpdate(techId, newCount)
	end
end

function PlayingTeam:OnTeamEntityCreated(newEnt)
	local techId = newEnt:GetTechId()
	if self:TrackEntity(techId) then
		if not self.trackedTeamEntities[techId] then
			self.trackedTeamEntities[techId] = 0
		end
		self.trackedTeamEntities[techId] = self.trackedTeamEntities[techId] + 1
		self:OnTrackedEntityChange(techId, self.trackedTeamEntities[techId])
	end
end

function PlayingTeam:OnTeamEntityUpdated(oldTechId, newTechId, ent)
	if self:TrackEntity(oldTechId) then
		if not self.trackedTeamEntities[oldTechId] then
			self.trackedTeamEntities[oldTechId] = 0
		end
		self.trackedTeamEntities[oldTechId] = math.max(self.trackedTeamEntities[oldTechId] - 1, 0)
		self:OnTrackedEntityChange(oldTechId, self.trackedTeamEntities[oldTechId])
	end
	if self:TrackEntity(newTechId) then
		if not self.trackedTeamEntities[newTechId] then
			self.trackedTeamEntities[newTechId] = 0
		end
		self.trackedTeamEntities[newTechId] = self.trackedTeamEntities[newTechId] + 1
		self:OnTrackedEntityChange(newTechId, self.trackedTeamEntities[newTechId])
	end
end

function PlayingTeam:TrackEntity(techId)
	return false
end

function PlayingTeam:OnTeamEntityDestroyed(ent)
	if ent then
		local techId = ent:GetTechId()
		if self:TrackEntity(techId) then
			if not self.trackedTeamEntities[techId] then
				self.trackedTeamEntities[techId] = 0
			end
			self.trackedTeamEntities[techId] = math.max(self.trackedTeamEntities[techId] - 1, 0)
			self:OnTrackedEntityChange(techId, self.trackedTeamEntities[techId])
		end
	end
end

function PlayingTeam:CountTrackedEntities(techId)
	return self.trackedTeamEntities[techId] and self.trackedTeamEntities[techId] or 0
end

-- Research/Tech Event system
local function InformResearch(player)
	player:AddTimedCallback(player.TechOrResearchUpdated, 0.1)
end

function PlayingTeam:OnResearchCompleted(techId)
	-- TELL THE PEOPLE!
	self:ForEachPlayer(InformResearch)
	-- and the structures
	local ents = GetEntitiesWithMixinForTeam("Live", self:GetTeamNumber())
	for i = 1, #ents do
		if ents[i].OnTechOrResearchUpdated then
			ents[i]:AddTimedCallback(ents[i].OnTechOrResearchUpdated, 0.1)
		end
	end
end

-- Another hidden set of 'relevant' IDs ://///
local function NewGetIsResearchRelevant(techId)
	if LookupTechData(techId, kTechDataNotifyPlayers, false) then
		return 1
	end
	return nil
end

ReplaceUpValue(PlayingTeam.OnResearchComplete, "GetIsResearchRelevant", NewGetIsResearchRelevant)

local originalPlayingTeamOnResearchComplete
originalPlayingTeamOnResearchComplete = Class_ReplaceMethod("PlayingTeam", "OnResearchComplete",
	function(self, structure, researchId)
		originalPlayingTeamOnResearchComplete(self, structure, researchId)
		self:OnResearchCompleted(researchId)
	end
)

local originalPlayingTeamTechAdded
originalPlayingTeamTechAdded = Class_ReplaceMethod("PlayingTeam", "TechAdded",
	function(self, entity)
		originalPlayingTeamTechAdded(self, entity)
		self:ForEachPlayer(InformResearch)
	end
)

local originalPlayingTeamTechRemoved
originalPlayingTeamTechRemoved = Class_ReplaceMethod("PlayingTeam", "TechRemoved",
	function(self, entity)
		originalPlayingTeamTechRemoved(self, entity)
		self:ForEachPlayer(InformResearch)
	end
)