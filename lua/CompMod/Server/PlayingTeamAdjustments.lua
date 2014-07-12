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

local relevantResearchIds = nil
local function GetIsResearchRelevant(techId)

    if not relevantResearchIds then
    
        relevantResearchIds = {}
        relevantResearchIds[kTechId.ShotgunTech] = 2
        relevantResearchIds[kTechId.GrenadeLauncherTech] = 2
        relevantResearchIds[kTechId.AdvancedWeaponry] = 2
        relevantResearchIds[kTechId.FlamethrowerTech] = 2
		relevantResearchIds[kTechId.HeavyMachineGunTech] = 2
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