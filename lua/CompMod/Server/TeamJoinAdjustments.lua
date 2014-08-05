//Dont want to always replace random files, so this.

local function SetUserPlayedInGame(self, player)
    
	local owner = Server.GetOwner(player)
	if owner then
	
		local userId = tonumber(owner:GetUserId())
		
		// Could be invalid if we're still connecting to Steam.
		return table.insertunique(self.userIdsInGame, userId)
		
	end
	
	return false
	
end

// Returns bool for success and bool if we've played in the game already.
local function GetUserPlayedInGame(self, player)

	local success = false
	local played = false
	
	local owner = Server.GetOwner(player)
	if owner then
	
		local userId = tonumber(owner:GetUserId())
		
		// Could be invalid if we're still connecting to Steam
		played = table.find(self.userIdsInGame, userId) ~= nil
		success = true
		
	end
	
	return success, played
	
end

function NS2Gamerules:JoinTeam(player, newTeamNumber, force)
    
	local success = false
	local oldPlayerWasSpectating = false
	if player then
	
		local ownerClient = Server.GetOwner(player)
		oldPlayerWasSpectating = ownerClient ~= nil and ownerClient:GetSpectatingPlayer() ~= nil
		
	end
	
	// Join new team
	if player and player:GetTeamNumber() ~= newTeamNumber or force then        
		
		if player:isa("Commander") then
			OnCommanderLogOut(player)
		end        
		
		if not Shared.GetCheatsEnabled() and self:GetGameStarted() and newTeamNumber ~= kTeamReadyRoom then
			player.spawnBlockTime = Shared.GetTime() + kSuicideDelay
		end
	
		local team = self:GetTeam(newTeamNumber)
		local oldTeam = self:GetTeam(player:GetTeamNumber())
		
		// Remove the player from the old queue if they happen to be in one
		if oldTeam ~= nil then
			oldTeam:RemovePlayerFromRespawnQueue(player)
		end
		
		// Spawn immediately if going to ready room, game hasn't started, cheats on, or game started recently
		if newTeamNumber == kTeamReadyRoom or self:GetCanSpawnImmediately() or force then
		
			success, newPlayer = team:ReplaceRespawnPlayer(player, nil, nil)
			
			local teamTechPoint = team.GetInitialTechPoint and team:GetInitialTechPoint()
			if teamTechPoint then
				newPlayer:OnInitialSpawn(teamTechPoint:GetOrigin())
			end
			
		else
		
			// Destroy the existing player and create a spectator in their place.
			newPlayer = player:Replace(team:GetSpectatorMapName(), newTeamNumber)
			
			// Queue up the spectator for respawn.
			team:PutPlayerInRespawnQueue(newPlayer)
			
			success = true
			
		end
		
		local newPlayerClient = Server.GetOwner(newPlayer)
		
		// Update frozen state of player based on the game state and player team.
		if team == self.team1 or team == self.team2 then
		
			local devMode = Shared.GetDevMode()
			local inCountdown = self:GetGameState() == kGameState.Countdown
			if not devMode and inCountdown then
				newPlayer.frozen = true
			end
			
			local clientUserId = newPlayerClient and newPlayerClient:GetUserId() or 0
			local disconnectedPlayerRes = self.disconnectedPlayerResources[clientUserId]
			if disconnectedPlayerRes then
			
				newPlayer:SetResources(disconnectedPlayerRes)
				self.disconnectedPlayerResources[clientUserId] = nil
				
			elseif not player:isa("Commander") then
			
				// Give new players starting resources. Mark players as "having played" the game (so they don't get starting res if
				// they join a team again, etc.) Also, don't award initial resources to any client marked as blockPersonalResources (previous Commanders).
				local success, played = GetUserPlayedInGame(self, newPlayer)
				if success and not played and not newPlayerClient.blockPersonalResources then
					newPlayer:SetResources(ConditionalValue(team == self.team2, kAlienInitialIndivRes ,kMarineInitialIndivRes))
				end
				
			end

			if self:GetGameStarted() then
				SetUserPlayedInGame(self, newPlayer)
				
				local gameLength = Shared.GetTime() - self:GetGameStartTime()
				if team == self.team2 and gameLength <= kResBlockTimer and player:GetPersonalResources() == 20 then
					newPlayer:SetResources(kAlienInitialIndivRes)
				end
				
			end
			
		else
		
			// Ready room or spectator players should never be frozen
			newPlayer.frozen = false
			
		end
		
		newPlayer:TriggerEffects("join_team")
		
		if success then
		
			self.sponitor:OnJoinTeam(newPlayer, team)
			
			if oldPlayerWasSpectating then
				newPlayerClient:SetSpectatingPlayer(nil)
			end
			
			if newPlayer.OnJoinTeam then
				newPlayer:OnJoinTeam()
			end    
			
			Server.SendNetworkMessage(newPlayerClient, "SetClientTeamNumber", { teamNumber = newPlayer:GetTeamNumber() }, true)
			
		end

		return success, newPlayer
		
	end
	
	// Return old player
	return success, player
	
end