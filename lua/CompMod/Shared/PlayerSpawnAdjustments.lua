// Natural Selection 2
// lua\PlayerSpawnAdjustments.lua
// - Dragon

Script.Load("lua/Class.lua")

//This shouldnt really be done this way, but its an effective test.  With a network message it may not arrive at the same time as the rest of the respawn, 
//causing some unnatural feeling for the client.  Probably should be a networked field in the player entity.
//Really there is probably no reason to set angles on respawn, unless its a specific event - returning to RR, round start to face CC etc.
//General respawns will have the client updating the view angles on its next frame, making it sorta pointless.  This would require re-working some of the spawn code a bit.
local kOverrideSpawnAnglesMessage =
{
    viewYaw         = "angle",
    viewPitch       = "angle",
}

function BuildOverrideSpawnAnglesMessage( angles )

    local a = {}
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
			
			if origin ~= nil and angles ~= nil then
				success = Team.RespawnPlayer(self, player, origin, angles)
			elseif initialTechPoint ~= nil then
			
				// Compute random spawn location
				local capsuleHeight, capsuleRadius = player:GetTraceCapsule()
				local spawnOrigin = GetRandomSpawnForCapsule(capsuleHeight, capsuleRadius, initialTechPoint:GetOrigin(), 2, 15, EntityFilterAll())
				
				if not spawnOrigin then
					spawnOrigin = initialTechPoint:GetOrigin() + Vector(2, 0.2, 2)
				end
				
				// Orient player towards tech point
				// 5 Meters above TP is alot, lets try 2.
				local lookAtPoint = initialTechPoint:GetOrigin() + Vector(0, 1, 0)
				local toTechPoint = GetNormalizedVector(lookAtPoint - spawnOrigin)
				success = Team.RespawnPlayer(self, player, spawnOrigin, Angles(GetPitchFromVector(toTechPoint), GetYawFromVector(toTechPoint), 0))
				
			else
				Print("PlayingTeam:RespawnPlayer(): No initial tech point.")
			end
			
			return success
			
		end
	)
	
	local function SpawnPlayer(self)

		if self.queuedPlayerId ~= Entity.invalidId then
		
			local queuedPlayer = Shared.GetEntity(self.queuedPlayerId)
			local team = queuedPlayer:GetTeam()
			
			// Spawn player on top of IP
			local spawnOrigin = self:GetAttachPointOrigin("spawn_point")
			
			//Marine specs have no model, so no angles.  Need view angles here i guess.
			local success, player = team:ReplaceRespawnPlayer(queuedPlayer, spawnOrigin, queuedPlayer:GetViewAngles())
			if success then
			
				player:SetCameraDistance(0)
				
				if HasMixin( player, "Controller" ) and HasMixin( player, "AFKMixin" ) then
					
					if player:GetAFKTime() > self:GetSpawnTime() - 1 then
						
						player:DisableGroundMove(0.1)
						player:SetVelocity( Vector( GetSign( math.random() - 0.5) * 2.25, 3, GetSign( math.random() - 0.5 ) * 2.25 ) )
						
					end
					
				end
				
				self.queuedPlayerId = Entity.invalidId
				self.queuedPlayerStartTime = nil
				
				player:ProcessRallyOrder(self)

				self:TriggerEffects("infantry_portal_spawn")            
				
				return true
				
			else
				Print("Warning: Infantry Portal failed to spawn the player")
			end
			
		end
		
		return false

	end
	
	local function StopSpinning(self)

		self:TriggerEffects("infantry_portal_stop_spin")
		self.timeSpinUpStarted = nil
		
	end
	
	local originalInfantryPortalFinishSpawn
	originalInfantryPortalFinishSpawn = Class_ReplaceMethod("InfantryPortal", "FinishSpawn",
		function(self)
			SpawnPlayer(self)
			StopSpinning(self)
			self.timeSpinUpStarted = nil		
		end
	)
	
	// Grab player out of respawn queue unless player passed in (for test framework)
	function Egg:SpawnPlayer(player)

		PROFILE("Egg:SpawnPlayer")

		local queuedPlayer = player
		
		if not queuedPlayer or self.queuedPlayerId ~= nil then
			queuedPlayer = Shared.GetEntity(self.queuedPlayerId)
		end
		
		if queuedPlayer ~= nil then
		
			local queuedPlayer = player
			if not queuedPlayer then
				queuedPlayer = Shared.GetEntity(self.queuedPlayerId)
			end
		
			// Spawn player on top of egg
			local spawnOrigin = Vector(self:GetOrigin())
			// Move down to the ground.
			local _, normal = GetSurfaceAndNormalUnderEntity(self)
			if normal.y < 1 then
				spawnOrigin.y = spawnOrigin.y - (self:GetExtents().y / 2) + 1
			else
				spawnOrigin.y = spawnOrigin.y - (self:GetExtents().y / 2)
			end

			local gestationClass = self:GetClassToGestate()
			
			// We must clear out queuedPlayerId BEFORE calling ReplaceRespawnPlayer
			// as this will trigger OnEntityChange() which would requeue this player.
			self.queuedPlayerId = nil
			
			local team = queuedPlayer:GetTeam()
			local success, player = team:ReplaceRespawnPlayer(queuedPlayer, spawnOrigin, queuedPlayer:GetViewAngles(), gestationClass)                
			player:SetCameraDistance(0)
			player:SetHatched()
			// It is important that the player was spawned at the spot we specified.
			assert(player:GetOrigin() == spawnOrigin)
			
			if success then
			
				self:TriggerEffects("egg_death")
				DestroyEntity(self) 
				
				return true, player
				
			end
				
		end
		
		return false, nil

	end

end

if Client then

	//Pitch is stored client side as +/- 1/2 pi in the 'move'.  'Pitch' from the server is networked as 0-2pi (ish?)
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
	
	local kFlashyViewAngleDebugging = false
	local oldCameraHolderMixinSetViewAngles = CameraHolderMixin.SetViewAngles
	function CameraHolderMixin:SetViewAngles(viewAngles)
		oldCameraHolderMixinSetViewAngles(self, viewAngles)
		if kFlashyViewAngleDebugging then
			if self.printViewAngles == nil or self.printViewAngles < Shared.GetTime() then
				Print(string.format("Player has pitch %s.", ToString(self.viewPitch)))
				local cs = Script.CallStack()
				if not string.match(cs, "OnProcessIntermediate") then
					//We reset when OnProcessMove calls this.
					Print("Called from OnProcessMove")
					self.printViewAngles = Shared.GetTime() + 1
				else
					Print("Called from OnProcessIntermediate")
				end
			end
		end
	end
	
	local function OnCommandDebugViewAngles()
		kFlashyViewAngleDebugging = not kFlashyViewAngleDebugging 
	end

	Event.Hook("Console_showviewangles", OnCommandDebugViewAngles)
	
end