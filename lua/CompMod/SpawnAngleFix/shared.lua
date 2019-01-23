-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\SpawnAngleFix\shared.lua
-- - Dragon

-- This shouldnt really be done this way, but its an effective test.  With a network message it may not arrive at the same time as the rest of the respawn, 
-- causing some unnatural feeling for the client.  Probably should be a networked field in the player entity.
-- Really there is no reason to set angles on respawn, unless its a specific event - returning to RR, round start to face CC etc.
-- General respawns will have the client updating the view angles on its next frame, making it sorta pointless.  This would require re-working some of the spawn code a bit.
local kOverrideSpawnAnglesMessage =
{
    viewYaw         = "angle",
    viewPitch       = "angle",
}

function BuildOverrideSpawnAnglesMessage( angles )

    local a = { }
    a.viewYaw = angles.yaw
    a.viewPitch = angles.pitch
    return a

end

Shared.RegisterNetworkMessage( "OverrideSpawnAngles", kOverrideSpawnAnglesMessage )

if Server then

	function SpawnPlayerAtPoint(player, origin, angles)

		player:SetOrigin(origin)
		
		if angles then
			Server.SendNetworkMessage(player, "OverrideSpawnAngles", BuildOverrideSpawnAnglesMessage(angles), true)
		end        
		
	end
	
	local originalPlayingTeamRespawnPlayer
	originalPlayingTeamRespawnPlayer = Class_ReplaceMethod("PlayingTeam", "RespawnPlayer",
		function(self, player, origin, angles)
			local success = false
			local initialTechPoint = Shared.GetEntity(self.initialTechPointId)
			
			if origin then
				-- If we were provided valid origin already, pass it along.  Discard angles as we dont care unless its facing the TP for initial join, or RR spawn using fixed points.
				success = Team.RespawnPlayer(self, player, origin)
			elseif initialTechPoint then
			
				-- Compute random spawn location
				local capsuleHeight, capsuleRadius = player:GetTraceCapsule()
				local spawnOrigin = GetRandomSpawnForCapsule(capsuleHeight, capsuleRadius, initialTechPoint:GetOrigin(), 2, 15, EntityFilterAll())
				
				if not spawnOrigin then
					spawnOrigin = initialTechPoint:GetOrigin() + Vector(2, 0.2, 2)
				end
				
				-- Orient player towards tech point
				-- 5 Meters above TP is alot, lets try 1.
				local lookAtPoint = initialTechPoint:GetOrigin() + Vector(0, 1, 0)
				local toTechPoint = GetNormalizedVector(lookAtPoint - spawnOrigin)
				success = Team.RespawnPlayer(self, player, spawnOrigin, Angles(GetPitchFromVector(toTechPoint), GetYawFromVector(toTechPoint), 0))
				
			else
				Print("PlayingTeam:RespawnPlayer(): No initial tech point.")
			end
			
			return success
			
		end
	)
	
	local originalTeamRespawnPlayer
	originalPlayingTeamRespawnPlayer = Class_ReplaceMethod("Team", "RespawnPlayer",
		function(self, player, origin, angles)

			assert(self:GetIsPlayerOnTeam(player), "Player isn't on team!")
			
			if origin == nil then
				-- Only care if origin is invalid.
				-- Randomly choose unobstructed spawn points to respawn the player
				local spawnPoint
				local spawnPoints = Server.readyRoomSpawnList
				local numSpawnPoints = table.maxn(spawnPoints)
				
				if numSpawnPoints > 0 then
				
					local spawnPoint = GetRandomClearSpawnPoint(player, spawnPoints)
					if spawnPoint then
					
						origin = spawnPoint:GetOrigin()
						angles = spawnPoint:GetAngles()
						
					end
					
				end
				
			end
			
			-- Move origin up and drop it to floor to prevent stuck issues with floating errors or slightly misplaced spawns
			if origin then
			
				SpawnPlayerAtPoint(player, origin, angles)
				
				player:ClearEffects()
				
				return true
				
			else
				DebugPrint("Team:RespawnPlayer(player, %s, %s) - Must specify origin.", ToString(origin), ToString(angles))
			end
			
			return false
			
		end
	)

	local originalCommandStructureLogout
	originalCommandStructureLogout = Class_ReplaceMethod("CommandStructure", "Logout",
		function(self)

		    -- Change commander back to player.
		    local commander = self:GetCommander()
		    local returnPlayer

		    self.playerIdStartedLogin = nil
		    self.occupied = false
		    self.commanderId = Entity.invalidId
		    
		    if commander then
		    
		        local previousWeaponMapName = commander.previousWeaponMapName
		        local previousOrigin = commander.lastGroundOrigin
		        local previousAngles = commander.lastGroundAngles
		        local previousHealth = commander.previousHealth
		        local previousArmor = commander.previousArmor
		        local previousMaxArmor = commander.maxArmor
		        local previousAlienEnergy = commander.previousAlienEnergy
		        -- local timeStartedCommanderMode = commander.timeStartedCommanderMode

		        local gamerules = GetGamerules()
		        if gamerules and gamerules.OnCommanderLogout then
		            gamerules:OnCommanderLogout(self, commander)
		        end
		        
		        local returnPlayer = commander:Replace(commander.previousMapName, commander:GetTeamNumber(), true, previousOrigin)    
		        
		        if returnPlayer.OnCommanderStructureLogout then
		            returnPlayer:OnCommanderStructureLogout(self)
		        end
		        
		        returnPlayer:SetActiveWeapon(previousWeaponMapName)

		        SpawnPlayerAtPoint(returnPlayer, previousOrigin, previousAngles)

		        returnPlayer:SetHealth(previousHealth)
		        returnPlayer:SetMaxArmor(previousMaxArmor)
		        returnPlayer:SetArmor(previousArmor)
		        returnPlayer.frozen = false
		        
		        if returnPlayer.TransferParasite then
		            returnPlayer:TransferParasite(commander)
		        end
		        
		        returnPlayer.hasAdrenalineUpgrade = GetHasAdrenalineUpgrade(returnPlayer)
		        
		        -- Restore previous alien energy
		        if previousAlienEnergy and returnPlayer.SetEnergy then
		            returnPlayer:SetEnergy(previousAlienEnergy)            
		        end
		        
		        returnPlayer:UpdateArmorAmount()
		        
		        returnPlayer.oneHive = commander.oneHive
		        returnPlayer.twoHives = commander.twoHives
		        returnPlayer.threeHives = commander.threeHives
		        
		        -- TODO: trigger client side in OnTag
		        self:TriggerEffects(self:isa("Hive") and "hive_logout" or "commandstation_logout")

		    end

		    return returnPlayer
		    
		end
	)

end

if Client then

	-- Pitch is stored client side as +/- 1/2 pi in the 'move'.  'Pitch' from the server is networked as 0-2pi (ish?)
	function CorrectViewPitch(pitch)

		if pitch > math.pi then
			pitch = pitch - (2 * math.pi)
		end
		return pitch

	end

	function OnCommandOverrideSpawnAngles(msg)
		if msg then
			Client.SetYaw(msg.viewYaw)
            Client.SetPitch(CorrectViewPitch(msg.viewPitch))
		end
	end
	
	Client.HookNetworkMessage("OverrideSpawnAngles", OnCommandOverrideSpawnAngles)
	
end