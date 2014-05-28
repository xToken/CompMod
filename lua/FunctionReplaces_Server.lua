//Dont want to always replace random files, so this.

/*function PlayerHallucinationMixin:OnKill()
   self:TriggerEffects("death_hallucination")
   self:SetBypassRagdoll(true)
end*/

function MucousMembrane:Perform()

	//Not a huge fan of this, but this heals HP based on max armor :S
	for _, unit in ipairs(GetEntitiesWithMixinForTeamWithinRange("Live", self:GetTeamNumber(), self:GetOrigin(), MucousMembrane.kRadius)) do
		// Comp Mod change, this now heals health, but at twice the rate.
		if unit:GetHealth() < unit:GetMaxHealth() then
			local addHealth = Clamp(unit:GetMaxArmor() * MucousMembrane.kThinkTime * 0.5, 2, 10)
			unit:SetHealth(math.min(unit:GetHealth() + addHealth, unit:GetMaxHealth()))
		end
	end

end

function EnzymeCloud:Perform()
        
	// search for aliens in range and buff their speed by 25%  
	for _, alien in ipairs(GetEntitiesForTeamWithinRange("Alien", self:GetTeamNumber(), self:GetOrigin(), EnzymeCloud.kRadius)) do
		alien:TriggerEnzyme(EnzymeCloud.kOnPlayerDuration)
	end
	
	// Comp Mod change, removed Enzyme Speed Boost.
	/*for _, unit in ipairs(GetEntitiesWithMixinForTeamWithinRange("Storm", self:GetTeamNumber(), self:GetOrigin(), EnzymeCloud.kRadius)) do
		unit:SetSpeedBoostDuration(kUnitSpeedBoostDuration)
	end*/

end

function PulseGrenade:OnUpdate(deltaTime)
    
	PredictedProjectile.OnUpdate(self, deltaTime)

	for _, enemy in ipairs( GetEntitiesForTeamWithinRange("Alien", GetEnemyTeamNumber(self:GetTeamNumber()), self:GetOrigin(), kPulseGrenadeAutoDetonateRange) ) do
	
		if enemy:GetIsAlive() then
			self:Detonate()
			break
		end
	
	end

end

local relevantResearchIds = nil
local function GetIsResearchRelevant(techId)

    if not relevantResearchIds then
    
        relevantResearchIds = {}
        relevantResearchIds[kTechId.ShotgunTech] = 2
        relevantResearchIds[kTechId.GrenadeLauncherTech] = 2
        relevantResearchIds[kTechId.AdvancedWeaponry] = 2
        relevantResearchIds[kTechId.FlamethrowerTech] = 2
        relevantResearchIds[kTechId.WelderTech] = 2
        relevantResearchIds[kTechId.GrenadeTech] = 2
        relevantResearchIds[kTechId.MinesTech] = 2
        relevantResearchIds[kTechId.ShotgunTech] = 2
        relevantResearchIds[kTechId.ExosuitTech] = 3
        relevantResearchIds[kTechId.JetpackTech] = 3
        relevantResearchIds[kTechId.DualMinigunTech] = 3
        relevantResearchIds[kTechId.ClawRailgunTech] = 3
        relevantResearchIds[kTechId.DualRailgunTech] = 3
        
        relevantResearchIds[kTechId.DetonationTimeTech] = 2
        relevantResearchIds[kTechId.FlamethrowerRangeTech] = 2
        
        relevantResearchIds[kTechId.Armor1] = 1
        relevantResearchIds[kTechId.Armor2] = 1
        relevantResearchIds[kTechId.Armor3] = 1
        
        relevantResearchIds[kTechId.Weapons1] = 1
        relevantResearchIds[kTechId.Weapons2] = 1
        relevantResearchIds[kTechId.Weapons3] = 1
        
        relevantResearchIds[kTechId.BabblerTech] = 1
		relevantResearchIds[kTechId.MetabolizeEnergy] = 1
		relevantResearchIds[kTechId.Charge] = 1
		relevantResearchIds[kTechId.BileBomb] = 1
		
        relevantResearchIds[kTechId.Leap] = 1
        relevantResearchIds[kTechId.Umbra] = 1
        relevantResearchIds[kTechId.MetabolizeHealth] = 1
		relevantResearchIds[kTechId.BoneShield] = 1
		relevantResearchIds[kTechId.Spores] = 1
        
        relevantResearchIds[kTechId.Stab] = 1
        relevantResearchIds[kTechId.WebTech] = 1
        relevantResearchIds[kTechId.Stomp] = 1
		relevantResearchIds[kTechId.Xenocide] = 1
    
    end
    
    return relevantResearchIds[techId]

end

ReplaceLocals(PlayingTeam.OnResearchComplete, { GetIsResearchRelevant = GetIsResearchRelevant })

local function SetUserPlayedInGame(self, player)
    
	local owner = Server.GetOwner(player)
	if owner then
	
		local userId = tonumber(owner:GetUserId())
		
		// Could be invalid if we're still connecting to Steam.
		return table.insertunique(self.userIdsInGame, userId)
		
	end
	
	return false
	
end

// Comp Mod change, lower starting Pres to 15 for Aliens.
function PlayingTeam:ResetTeam()

    local initialTechPoint = self:GetInitialTechPoint()
    
    local tower, commandStructure = self:SpawnInitialStructures(initialTechPoint)
    
    self.conceded = false

    return commandStructure
    
end

local oldMarineTeamResetTeam = MarineTeam.ResetTeam
function MarineTeam:ResetTeam()
	local commandStructure = oldMarineTeamResetTeam(self)
	local players = GetEntitiesForTeam("Player", self:GetTeamNumber())
	local initialTechPoint = self:GetInitialTechPoint()
	local gamerules = GetGamerules()
    for p = 1, #players do
        local player = players[p]
        player:OnInitialSpawn(initialTechPoint:GetOrigin())
        player:SetResources(kMarineInitialIndivRes)
		SetUserPlayedInGame(gamerules, player)
    end
	return commandStructure
end

function AlienTeam:ResetTeam()
	local commandStructure = PlayingTeam.ResetTeam(self)
	local players = GetEntitiesForTeam("Player", self:GetTeamNumber())
	local initialTechPoint = self:GetInitialTechPoint()
	local gamerules = GetGamerules()
    for p = 1, #players do
        local player = players[p]
        player:OnInitialSpawn(initialTechPoint:GetOrigin())
        player:SetResources(kAlienInitialIndivRes)
		SetUserPlayedInGame(gamerules, player)
    end
	if commandStructure then
        commandStructure:SetHotGroupNumber(1)
    end 
	return commandStructure
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
		
		// Update frozen state of player based on the game state and player team.
		if team == self.team1 or team == self.team2 then
		
			local devMode = Shared.GetDevMode()
			local inCountdown = self:GetGameState() == kGameState.Countdown
			if not devMode and inCountdown then
				newPlayer.frozen = true
			end
			
			local newPlayerClient = Server.GetOwner(newPlayer)
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
					newPlayer:SetResources(ConditionalValue(team.GetIsAlienTeam and team:GetIsAlienTeam(),kAlienInitialIndivRes ,kMarineInitialIndivRes))
				end
				
			end
			
			if self:GetGameStarted() then
				SetUserPlayedInGame(self, newPlayer)
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

// Changes to handle evolution chamber for each Hive.
local oldHiveOnConstructionComplete = Hive.OnConstructionComplete
function Hive:OnConstructionComplete()
    oldHiveOnConstructionComplete(self)
	self.evochamber = Entity.invalidId
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
	if self:GetEvolutionChamber() ~= Entity.invalidId then
		local evochamber = Shared.GetEntity(self:GetEvolutionChamber())
		local techTree = self:GetTeam():GetTechTree()
		if evochamber then
			if techTree then
				evochamber:PerformAction(techTree:GetTechNode(kTechId.Cancel), evochamber:GetOrigin()) // Trigger research abort :S
			end
			DestroyEntity(evochamber)
		end
	end
end

// Comp Mod change, alien tech tree
function AlienTeam:InitTechTree()

    PlayingTeam.InitTechTree(self)
    
    // Add special alien menus
    self.techTree:AddMenu(kTechId.MarkersMenu)
    self.techTree:AddMenu(kTechId.UpgradesMenu)
    self.techTree:AddMenu(kTechId.ShadePhantomMenu)
    self.techTree:AddMenu(kTechId.ShadePhantomStructuresMenu)
    self.techTree:AddMenu(kTechId.ShiftEcho, kTechId.ShiftHive)
    self.techTree:AddMenu(kTechId.LifeFormMenu)
    self.techTree:AddMenu(kTechId.SkulkMenu)
    self.techTree:AddMenu(kTechId.GorgeMenu)
    self.techTree:AddMenu(kTechId.LerkMenu)
    self.techTree:AddMenu(kTechId.FadeMenu)
    self.techTree:AddMenu(kTechId.OnosMenu)
    self.techTree:AddMenu(kTechId.Return)
	
    self.techTree:AddOrder(kTechId.Grow)
    self.techTree:AddAction(kTechId.FollowAlien)    
    
    self.techTree:AddPassive(kTechId.Infestation)
    self.techTree:AddPassive(kTechId.SpawnAlien)
    self.techTree:AddPassive(kTechId.CollectResources, kTechId.Harvester)
    
    // Add markers (orders)
    self.techTree:AddSpecial(kTechId.ThreatMarker, kTechId.None, kTechId.None, true)
    self.techTree:AddSpecial(kTechId.LargeThreatMarker, kTechId.None, kTechId.None, true)
    self.techTree:AddSpecial(kTechId.NeedHealingMarker, kTechId.None, kTechId.None, true)
    self.techTree:AddSpecial(kTechId.WeakMarker, kTechId.None, kTechId.None, true)
    self.techTree:AddSpecial(kTechId.ExpandingMarker, kTechId.None, kTechId.None, true)
    
    // bio mass levels (required to unlock new abilities)
    self.techTree:AddSpecial(kTechId.BioMassOne)
    self.techTree:AddSpecial(kTechId.BioMassTwo)
    self.techTree:AddSpecial(kTechId.BioMassThree)
    self.techTree:AddSpecial(kTechId.BioMassFour)
    self.techTree:AddSpecial(kTechId.BioMassFive)
    self.techTree:AddSpecial(kTechId.BioMassSix)
    self.techTree:AddSpecial(kTechId.BioMassSeven)
    self.techTree:AddSpecial(kTechId.BioMassEight)
    self.techTree:AddSpecial(kTechId.BioMassNine)
    
    // Commander abilities
    self.techTree:AddBuildNode(kTechId.Cyst)
    self.techTree:AddBuildNode(kTechId.NutrientMist)
    self.techTree:AddBuildNode(kTechId.Rupture, kTechId.BioMassTwo)
    self.techTree:AddBuildNode(kTechId.BoneWall, kTechId.BioMassThree)
    self.techTree:AddBuildNode(kTechId.Contamination, kTechId.BioMassNine)
    self.techTree:AddAction(kTechId.SelectDrifter)
    self.techTree:AddAction(kTechId.SelectHallucinations, kTechId.ShadeHive)
    self.techTree:AddAction(kTechId.SelectShift, kTechId.ShiftHive)
    
    // Drifter triggered abilities
    self.techTree:AddTargetedActivation(kTechId.EnzymeCloud,      kTechId.ShiftHive,      kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.Hallucinate,      kTechId.ShadeHive,      kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.MucousMembrane,   kTechId.CragHive,      kTechId.None)    
    //self.techTree:AddTargetedActivation(kTechId.Storm,            kTechId.ShiftHive,       kTechId.None)
    self.techTree:AddActivation(kTechId.DestroyHallucination)
    
    // Drifter passive abilities
    self.techTree:AddPassive(kTechId.DrifterCamouflage)
    self.techTree:AddPassive(kTechId.DrifterCelerity)
    self.techTree:AddPassive(kTechId.DrifterRegeneration)
           
    // Hive types
    self.techTree:AddBuildNode(kTechId.Hive,                    kTechId.None,           kTechId.None)
    self.techTree:AddPassive(kTechId.HiveHeal)
    self.techTree:AddBuildNode(kTechId.CragHive,                kTechId.Hive,                kTechId.None)
    self.techTree:AddBuildNode(kTechId.ShadeHive,               kTechId.Hive,                kTechId.None)
    self.techTree:AddBuildNode(kTechId.ShiftHive,               kTechId.Hive,                kTechId.None)
    
    self.techTree:AddTechInheritance(kTechId.Hive, kTechId.CragHive)
    self.techTree:AddTechInheritance(kTechId.Hive, kTechId.ShiftHive)
    self.techTree:AddTechInheritance(kTechId.Hive, kTechId.ShadeHive)
    
    self.techTree:AddUpgradeNode(kTechId.ResearchBioMassOne)
    self.techTree:AddUpgradeNode(kTechId.ResearchBioMassTwo)
    self.techTree:AddUpgradeNode(kTechId.ResearchBioMassThree)
    self.techTree:AddUpgradeNode(kTechId.ResearchBioMassFour)

    self.techTree:AddUpgradeNode(kTechId.UpgradeToCragHive,     kTechId.Hive,                kTechId.None)
    self.techTree:AddUpgradeNode(kTechId.UpgradeToShadeHive,    kTechId.Hive,                kTechId.None)
    self.techTree:AddUpgradeNode(kTechId.UpgradeToShiftHive,    kTechId.Hive,                kTechId.None)
    
    self.techTree:AddBuildNode(kTechId.Harvester)
    self.techTree:AddBuildNode(kTechId.DrifterEgg)
    self.techTree:AddBuildNode(kTechId.Drifter, kTechId.None, kTechId.None, true)

    // Whips
    self.techTree:AddBuildNode(kTechId.Whip,                      kTechId.None,                kTechId.None)
    self.techTree:AddUpgradeNode(kTechId.EvolveBombard,             kTechId.None,                kTechId.None)

    self.techTree:AddPassive(kTechId.WhipBombard)
    self.techTree:AddPassive(kTechId.Slap)
    self.techTree:AddActivation(kTechId.WhipUnroot)
    self.techTree:AddActivation(kTechId.WhipRoot)
    
    // Tier 1 lifeforms
    self.techTree:AddAction(kTechId.Skulk,                     kTechId.None,                kTechId.None)
    self.techTree:AddAction(kTechId.Gorge,                     kTechId.None,                kTechId.None)
    self.techTree:AddAction(kTechId.Lerk,                      kTechId.None,                kTechId.None)
    self.techTree:AddAction(kTechId.Fade,                      kTechId.None,                kTechId.None)
    self.techTree:AddAction(kTechId.Onos,                      kTechId.None,                kTechId.None)
    self.techTree:AddBuyNode(kTechId.Egg,                      kTechId.None,                kTechId.None)
    
    self.techTree:AddUpgradeNode(kTechId.GorgeEgg, kTechId.BioMassTwo)
    self.techTree:AddUpgradeNode(kTechId.LerkEgg, kTechId.BioMassTwo)
    self.techTree:AddUpgradeNode(kTechId.FadeEgg, kTechId.BioMassNine)
    self.techTree:AddUpgradeNode(kTechId.OnosEgg, kTechId.BioMassNine)
    
    // Special alien structures. These tech nodes are modified at run-time, depending when they are built, so don't modify prereqs.
    self.techTree:AddBuildNode(kTechId.Crag,                      kTechId.Hive,          kTechId.None)
    self.techTree:AddBuildNode(kTechId.Shift,                     kTechId.Hive,          kTechId.None)
    self.techTree:AddBuildNode(kTechId.Shade,                     kTechId.Hive,          kTechId.None)
    
    // Alien upgrade structure
    self.techTree:AddBuildNode(kTechId.Shell, kTechId.CragHive)
    self.techTree:AddSpecial(kTechId.TwoShells, kTechId.Shell)
    self.techTree:AddSpecial(kTechId.ThreeShells, kTechId.TwoShells)
    
    self.techTree:AddBuildNode(kTechId.Veil, kTechId.ShadeHive)
    self.techTree:AddSpecial(kTechId.TwoVeils, kTechId.Veil)
    self.techTree:AddSpecial(kTechId.ThreeVeils, kTechId.TwoVeils)
    
    self.techTree:AddBuildNode(kTechId.Spur, kTechId.ShiftHive)  
    self.techTree:AddSpecial(kTechId.TwoSpurs, kTechId.Spur)
    self.techTree:AddSpecial(kTechId.ThreeSpurs, kTechId.TwoSpurs)
    
    // personal upgrades (all alien types)
    self.techTree:AddBuyNode(kTechId.Carapace, kTechId.Shell, kTechId.None, kTechId.AllAliens)    
    self.techTree:AddBuyNode(kTechId.Regeneration, kTechId.Shell, kTechId.None, kTechId.AllAliens)
	
    self.techTree:AddBuyNode(kTechId.Aura, kTechId.Veil, kTechId.None, kTechId.AllAliens)
    self.techTree:AddBuyNode(kTechId.Silence, kTechId.Veil, kTechId.None, kTechId.AllAliens)
	self.techTree:AddBuyNode(kTechId.Camouflage, kTechId.Veil, kTechId.None, kTechId.AllAliens)
		
    self.techTree:AddBuyNode(kTechId.Celerity, kTechId.Spur, kTechId.None, kTechId.AllAliens)  
    self.techTree:AddBuyNode(kTechId.Adrenaline, kTechId.Spur, kTechId.None, kTechId.AllAliens)  

    // Crag
    self.techTree:AddPassive(kTechId.CragHeal)
    self.techTree:AddActivation(kTechId.HealWave,                kTechId.CragHive,          kTechId.None)

    // Shift    
    self.techTree:AddActivation(kTechId.ShiftHatch,               kTechId.None,         kTechId.None) 
    self.techTree:AddPassive(kTechId.ShiftEnergize,               kTechId.None,         kTechId.None)
    
    self.techTree:AddTargetedActivation(kTechId.TeleportHydra,       kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportWhip,        kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportTunnel,      kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportCrag,        kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportShade,       kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportShift,       kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportVeil,        kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportSpur,        kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportShell,       kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportHive,        kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportEgg,         kTechId.ShiftHive,         kTechId.None)
    self.techTree:AddTargetedActivation(kTechId.TeleportHarvester,   kTechId.ShiftHive,         kTechId.None)

    // Shade
    self.techTree:AddPassive(kTechId.ShadeDisorient)
    self.techTree:AddPassive(kTechId.ShadeCloak)
    self.techTree:AddActivation(kTechId.ShadeInk,                 kTechId.ShadeHive,         kTechId.None) 
    
    self.techTree:AddSpecial(kTechId.TwoHives)
    self.techTree:AddSpecial(kTechId.ThreeHives)
    
    self.techTree:AddSpecial(kTechId.TwoWhips)
    self.techTree:AddSpecial(kTechId.TwoShifts)
    self.techTree:AddSpecial(kTechId.TwoShades)
    self.techTree:AddSpecial(kTechId.TwoCrags)
    
    // abilities unlocked by bio mass: 
    
    // skulk researches
    self.techTree:AddResearchNode(kTechId.Leap,              kTechId.BioMassFour, kTechId.None, kTechId.AllAliens) 
    self.techTree:AddResearchNode(kTechId.Xenocide,          kTechId.BioMassNine, kTechId.None, kTechId.AllAliens)
    
    // gorge researches
    self.techTree:AddBuyNode(kTechId.BabblerAbility,        kTechId.BabblerTech)
	self.techTree:AddBuyNode(kTechId.BabblerEgg,            	kTechId.BabblerTech)
	self.techTree:AddResearchNode(kTechId.BabblerTech,            	kTechId.BioMassOne, kTechId.None, kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.BileBomb,              kTechId.BioMassThree, kTechId.None, kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.WebTech,                   kTechId.BioMassSeven, kTechId.None, kTechId.AllAliens)
    
    // lerk researches
    self.techTree:AddResearchNode(kTechId.Umbra,               kTechId.BioMassFour, kTechId.None, kTechId.AllAliens) 
    self.techTree:AddResearchNode(kTechId.Spores,              kTechId.BioMassSix, kTechId.None, kTechId.AllAliens)
    
    // fade researches 
    self.techTree:AddResearchNode(kTechId.MetabolizeEnergy,        kTechId.BioMassThree, kTechId.None, kTechId.AllAliens) 
    self.techTree:AddResearchNode(kTechId.MetabolizeHealth,            kTechId.BioMassFive, kTechId.MetabolizeEnergy, kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.Stab,              kTechId.BioMassSeven, kTechId.None, kTechId.AllAliens)
    
    // onos researches
    self.techTree:AddResearchNode(kTechId.Charge,            kTechId.BioMassTwo, kTechId.None, kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.BoneShield,        kTechId.BioMassFive, kTechId.None, kTechId.AllAliens)
    self.techTree:AddResearchNode(kTechId.Stomp,             kTechId.BioMassEight, kTechId.None, kTechId.AllAliens)    

    // gorge structures
    self.techTree:AddBuildNode(kTechId.GorgeTunnelEntrance)
	self.techTree:AddBuildNode(kTechId.GorgeTunnelExit)
    self.techTree:AddBuildNode(kTechId.Hydra)
    self.techTree:AddBuildNode(kTechId.Clog)

    self.techTree:SetComplete()
    
end	
				
function Fade:GetTierOneTechId()
    return kTechId.MetabolizeEnergy
end

function Fade:GetTierTwoTechId()
    return kTechId.MetabolizeHealth
end

function ARC:AcquireTarget()
    
    local finalTarget = nil
	
	if self.orderedEntity ~= Entity.invalidId and self.orderedEntity ~= nil then
		finalTarget = Shared.GetEntity(self.orderedEntity)
	end
	if finalTarget == nil or not self:ValidateTargetPosition(finalTarget:GetOrigin()) or not self:GetCanFireAtTarget(finalTarget, finalTarget:GetOrigin()) then
		finalTarget = self.targetSelector:AcquireTarget()
	end   
    
    if finalTarget ~= nil and self:ValidateTargetPosition(finalTarget:GetOrigin()) then
    
        self:SetMode(ARC.kMode.Targeting)
        self.targetPosition = finalTarget:GetOrigin()
        self.targetedEntity = finalTarget:GetId()
        
    else
    
        self:SetMode(ARC.kMode.Stationary)
        self.targetPosition = nil
		self.orderedEntity = Entity.invalidId
        self.targetedEntity = Entity.invalidId
        
    end
    
end

// Comp Mod change, decrease weapon time on ground.
// Set to true for being a world weapon, false for when it's carried by a player
Class_ReplaceMethod("Weapon", "SetWeaponWorldState",
function(self, state, preventExpiration)

    if state ~= self.weaponWorldState then
    
        if state then
        
            self:SetPhysicsType(PhysicsType.DynamicServer)
            
            // So it doesn't affect player movement and so collide callback is called
            self:SetPhysicsGroup(PhysicsGroup.DroppedWeaponGroup)
            self:SetPhysicsGroupFilterMask(PhysicsMask.DroppedWeaponFilter)
            
            if self.physicsModel then
                self.physicsModel:SetCCDEnabled(true)
            end
            
            if not preventExpiration then
            
                self.weaponWorldStateTime = Shared.GetTime()
                
                local function DestroyWorldWeapon()
                
                    // We need to make sure this callback is still valid. It is possible
                    // for this weapon to be dropped and picked up before this callback fires off
                    // and then be dropped again, in which case this callback should be ignored and
                    // the next callback will destroy the weapon.
                    
                    // $AU: i would suggest to not use TimedCallbacks here. I noticed sometimes weapons won't disappear (not commander dropped, marine dropped),
                    // and also the callback table gets blown up when you spam drop/pickup constantly.
                    
                    local enoughTimePassed = (Shared.GetTime() - self.weaponWorldStateTime) >= kWeaponStayTime
                    if self:GetWeaponWorldState() and enoughTimePassed then
                        DestroyEntity(self)
                    end
                    
                end
                
                self:AddTimedCallback(DestroyWorldWeapon, kWeaponStayTime)
                
            end
            
            self:SetIsVisible(true)
            
        else
        
            self:SetPhysicsType(PhysicsType.None)
            self:SetPhysicsGroup(PhysicsGroup.WeaponGroup)
            self:SetPhysicsGroupFilterMask(PhysicsMask.None)
            
            if self.physicsModel then
                self.physicsModel:SetCCDEnabled(false)
            end
            
        end
        
        self.hitGround = false
        
        self.weaponWorldState = state
        
    end
    
end)

//Enhanced Weapon Cleanup
local lastWeaponScan = 0
local kWeaponScanRate = 30
local function ScanForOldWeapons()
	PROFILE("ScanForOldWeapons")
	if lastWeaponScan + kWeaponScanRate < Shared.GetTime() then
		for _, entity in ientitylist(Shared.GetEntitiesWithClassname("Weapon")) do
			if entity.weaponWorldStateTime ~= nil and entity.GetWeaponWorldState then
				local enoughTimePassed = (Shared.GetTime() - entity.weaponWorldStateTime) >= kWeaponStayTime
				if entity:GetWeaponWorldState() and enoughTimePassed then
					DestroyEntity(entity)
				end
			end
		end
		lastWeaponScan = Shared.GetTime()
	end
end

Event.Hook("UpdateServer", ScanForOldWeapons)

//Fixes for whips below.
function EntityFilterTwoAndIsa(entity1, entity2, classname)
    return function (test) return test == entity1 or test == entity2 or test:isa(classname) end
end

local toEntity = Vector()
function GetCanSeeEntity(seeingEntity, targetEntity, considerObstacles)

    PROFILE("NS2Utility:GetCanSeeEntity")
    
    local seen = false
    
    // See if line is in our view cone
    if targetEntity:GetIsVisible() then
    
        local targetOrigin = HasMixin(targetEntity, "Target") and targetEntity:GetEngagementPoint() or targetEntity:GetOrigin()
        local eyePos = GetEntityEyePos(seeingEntity)
        
        // Not all seeing entity types have a FOV.
        // So default to within FOV.
        local withinFOV = true
        
        // Anything that has the GetFov method supports FOV checking.
        if seeingEntity.GetFov ~= nil then
        
            // Reuse vector
            toEntity.x = targetOrigin.x - eyePos.x
            toEntity.y = targetOrigin.y - eyePos.y
            toEntity.z = targetOrigin.z - eyePos.z
            
            // Normalize vector        
            local toEntityLength = math.sqrt(toEntity.x * toEntity.x + toEntity.y * toEntity.y + toEntity.z * toEntity.z)
            if toEntityLength > kEpsilon then
            
                toEntity.x = toEntity.x / toEntityLength
                toEntity.y = toEntity.y / toEntityLength
                toEntity.z = toEntity.z / toEntityLength
                
            end
            
            local seeingEntityAngles = GetEntityViewAngles(seeingEntity)
            local normViewVec = seeingEntityAngles:GetCoords().zAxis        
            local dotProduct = Math.DotProduct(toEntity, normViewVec)
            local fov = seeingEntity:GetFov()
            
            // players have separate fov for marking enemies as sighted
            if seeingEntity.GetMinimapFov then
                fov = seeingEntity:GetMinimapFov(targetEntity)
            end
            
            local halfFov = math.rad(fov / 2)
            local s = math.acos(dotProduct)
            withinFOV = s < halfFov
            
        end
        
        if withinFOV then
        
            local filter = EntityFilterAllButIsa("Door") // EntityFilterAll()
            if considerObstacles then
				// Weapons dont block FOV
                filter = EntityFilterTwoAndIsa(seeingEntity, targetEntity, "Weapon")
            end
        
            // See if there's something blocking our view of the entity.
            local trace = Shared.TraceRay(eyePos, targetOrigin, CollisionRep.LOS, PhysicsMask.All, filter)
            
            if trace.fraction == 1 then
                seen = true
            end
			
        end
		
    end
    
    return seen
    
end

function AiAttacksMixin:OnTag(tagName)

    PROFILE("AiAttacksMixin:OnTag")

    if self.currentAttack then
    
        // note that all the OnStart and OnHit is only called if the target or location is valid
        
        if tagName == "start" then
        
            if self.currentAttack:IsValid()  then
            
                // uncloak 
                if HasMixin(self, "Cloakable") then
                    self:TriggerUncloak() 
                end
                
                // pay for any energy
                if HasMixin(self, "Energy") then
                    self:SetEnergy(self:GetEnergy() - self.currentAttack.energyCost)
                end
				
				// The animation is already started by the attack starting, sooooooooo wtf.
                /*if self.OnAiAttackStart then
                    self:OnAiAttackStart(self.currentAttack)
                end*/
                
                self.currentAttack:OnStart()
                
            end
            
        end
        
        if tagName == "hit" then
        
            if self.currentAttack:IsValid() then
            
                if self.OnAiAttackHit then
                    self:OnAiAttackHit(self.currentAttack)
                end
                
                self.currentAttack:OnHit()
                
            else
            
                // notify that the target wasn't valid at the hit
                if self.OnAiAttackHitFail then
                    self:OnAiAttackHitFail(self.currentAttack)
                end
                
            end
            
        end
        
        if tagName == "end" then
        
            self:UpdateNextAiAttackTime()
            
			// AI attack mixin handles ending of attacks also, easier to override here.
			// Not all anims might have end tags.
            /*if self.OnAiAttackEnd then
                self:OnAiAttackEnd(self.currentAttack)
            end*/
            
            self.currentAttack:OnEnd()
            
        end
        
    end
    
end