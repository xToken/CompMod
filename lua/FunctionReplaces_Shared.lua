//Dont want to always replace random files, so this.

Script.Load("lua/TunnelExit.lua")

// Comp Mod change, remove egg drops.
function Egg:GetTechButtons(techId)
    local techButtons = { kTechId.SpawnAlien, kTechId.None, kTechId.None, kTechId.None, 
                          kTechId.None, kTechId.None, kTechId.None, kTechId.None }    
    return techButtons
end

// Comp Mod change, remove enzyme bite cone adjustments and increased range from skulk bite.
function BiteLeap:GetMeleeBase()
    // Width of box, height of box
    return 0.7, 1
end

ReplaceLocals(BiteLeap.OnTag, { kEnzymedRange = 1.42 })

function Gore:GetMeleeBase()
    return 1, 1.4
end

function LerkBite:GetMeleeBase()
    return 0.9, 1.2  
end

function StabBlink:GetMeleeBase()
    return .7, 1
end

function SwipeBlink:GetMeleeBase()
    return .7, 1  
end

// Comp Mod change, fade damage type changes
local function DoubleHealthPerArmorForStructures(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
	if target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage(damageType) then
		healthPerArmor = healthPerArmor * (kStructureLightHealthPerArmor / kHealthPointsPerArmor)
		armorFractionUsed = kStructureLightArmorUseFraction
	end
    return damage, armorFractionUsed, healthPerArmor
end

local oldGetDamageByType = GetDamageByType
function GetDamageByType(...)
	local damage, armorUsed, healthUsed = oldGetDamageByType(...)
	kDamageTypeRules[kDamageType.StructuresOnlyLight] = {}
	table.insert(kDamageTypeRules[kDamageType.StructuresOnlyLight], DoubleHealthPerArmorForStructures)
	GetDamageByType = oldGetDamageByType
	//Seems odd, but should just run once to replace.  I hope.
	//If by some strange miracle the fade was the first thing to ever attack something, this would calculate the damage wrong once... im not so concerned.
	return damage, armorUsed, healthUsed
end

// Comp Mod change, add initial bone shield energy cost
function BoneShield:OnProcessMove(input)

    if self.primaryAttacking then
		
        local player = self:GetParent()
        if player then
		        
			if self.firstboneshieldframe then
				player:DeductAbilityEnergy(self:GetEnergyCost())
				self.firstboneshieldframe = false
			end
        
            local energy = player:GetEnergy()
            player:DeductAbilityEnergy(input.time * kBoneShieldEnergyPerSecond)
            
            if player:GetEnergy() == 0 then
                self.primaryAttacking = false
                self.timeLastBoneShield = Shared.GetTime()
            end
        end
    else
	
		self.firstboneshieldframe = true
		
    end

end

// Comp Mod change, bone shield doesnt block all damage.
local kBlockDoers =
{
    "Minigun",
    "Pistol",
    "Rifle",
    "HeavyRifle",
    "Shotgun",
    "Axe",
    "Welder",
    "Sentry",
    "Claw"
}

local function GetHitsBoneShield(self, doer, hitPoint)

    if table.contains(kBlockDoers, doer:GetClassName()) then
    
        local viewDirection = GetNormalizedVectorXZ(self:GetViewCoords().zAxis)
        local zPosition = viewDirection:DotProduct(GetNormalizedVector(hitPoint - self:GetOrigin()))

        return zPosition > -0.1
    
    end
    
    return false

end

function Onos:ModifyDamageTaken(damageTable, attacker, doer, damageType, hitPoint)

    if hitPoint ~= nil and self:GetIsBoneShieldActive() and GetHitsBoneShield(self, doer, hitPoint) then
    
        damageTable.damage = damageTable.damage * kBoneShieldDamageReduction
        self:TriggerEffects("boneshield_blocked", {effecthostcoords = Coords.GetTranslation(hitPoint)} )
        
    end

end

// Comp Mod change, onos != garbage truck - increased from .5
function Onos:GetMaxBackwardSpeedScalar()
    return 1
end

// Comp Mod change, onos != garbage truck - increased from 3.3
function Onos:GetAcceleration()
    return 6.5
end

// Comp Mod change, onos != garbage truck - increased from 0.2
function Onos:GetAirControl()
    return 4
end

// Comp Mod change, onos != garbage truck - increased from 3
function Onos:GetGroundFriction()
    return 6
end

ReplaceLocals(Onos.PlayerCameraCoordsAdjustment, { kOnosHeadMoveAmount = 0 })

local function HasUpgrade(callingEntity, techId)

    if not callingEntity then
        return false
    end

    local techtree = GetTechTree(callingEntity:GetTeamNumber())

    if techtree then
        return callingEntity:GetHasUpgrade(techId) // and techtree:GetIsTechAvailable(techId)
    else
        return false
    end

end

function GetHasCamouflageUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.Camouflage)
end

function GetHasSilenceUpgrade(callingEntity)
    return HasUpgrade(callingEntity, kTechId.Silence)
end

//Comp Mod change, remove double jump to jetpack requirement.
function JetpackMarine:UpdateJetpack(input)
    
    local jumpPressed = (bit.band(input.commands, Move.Jump) ~= 0)
    
    local enoughTimePassed = not self:GetIsOnGround() and self:GetTimeGroundTouched() + 0.3 <= Shared.GetTime() or false

    self:UpdateJetpackMode()
    
    // handle jetpack start, ensure minimum wait time to deal with sound errors
    if not self.jetpacking and (Shared.GetTime() - self.timeJetpackingChanged > 0.2) and jumpPressed and self:GetFuel()> 0 then
    
        self:HandleJetpackStart()
        
        if Server then
            self.jetpackLoop:Start()
        end
        
    end
    
    // handle jetpack stop, ensure minimum flight time to deal with sound errors
    if self.jetpacking and (Shared.GetTime() - self.timeJetpackingChanged) > 0.2 and (self:GetFuel()== 0 or not jumpPressed) then
        self:HandleJetPackEnd()
    end
    
    if Client then
    
        local jetpackLoop = Shared.GetEntity(self.jetpackLoopId)
        if jetpackLoop then
        
            local fuel = self:GetFuel()
            if self:GetIsWebbed() then
                fuel = 0
            end
        
            jetpackLoop:SetParameter("fuel", fuel, 1)
        end
        
    end

end

// Comp Mod change, tweaking jetpack acceleration
// Jetpacking verticle movement will not start until the frame after the jetpack is triggered.
local kFlySpeed = 9
local kFlyFriction = 0.0
local kFlyAcceleration = 28

function JetpackMarine:GetCanJump()
    return not self:GetIsWebbed() and ( self:GetIsOnGround() or (self.timeJetpackingChanged == Shared.GetTime() and self.startedFromGround) or self:GetIsOnLadder() )
end

function JetpackMarine:ModifyVelocity(input, velocity, deltaTime)

    if self:GetIsJetpacking() then
        
        local verticalAccel = 22
        
        if self:GetIsWebbed() then
            verticalAccel = 5
        elseif input.move:GetLength() == 0 then
            verticalAccel = 26
        end
    
        self.onGround = false
        local thrust = math.max(0, -velocity.y) / 6
        velocity.y = math.min(5, velocity.y + verticalAccel * deltaTime * (1 + thrust * 2.5))
 
    end
    
    if not self.onGround then
    
        // do XZ acceleration
        local prevXZSpeed = velocity:GetLengthXZ()
        local maxSpeedTable = { maxSpeed = math.max(kFlySpeed, prevXZSpeed) }
        self:ModifyMaxSpeed(maxSpeedTable)
        local maxSpeed = maxSpeedTable.maxSpeed        
        
        if not self:GetIsJetpacking() then
            maxSpeed = prevXZSpeed
        end
        
        local wishDir = self:GetViewCoords():TransformVector(input.move)
        local acceleration = 0
        wishDir.y = 0
        wishDir:Normalize()
        
        acceleration = kFlyAcceleration
        
        velocity:Add(wishDir * acceleration * self:GetInventorySpeedScalar() * deltaTime)

        if velocity:GetLengthXZ() > maxSpeed then
        
            local yVel = velocity.y
            velocity.y = 0
            velocity:Normalize()
            velocity:Scale(maxSpeed)
            velocity.y = yVel
            
        end 
        
        if self:GetIsJetpacking() then
            velocity:Add(wishDir * kJetpackingAccel * deltaTime)
        end
    
    end

end

function JetpackMarine:ModifyJump(input, velocity, jumpVelocity)

    jumpVelocity.y = jumpVelocity.y * 0.8
    Marine.ModifyJump(self, input, velocity, jumpVelocity)

end

local function AddCompModTechChanges()
	// Comp Mod change, add tech crap
	table.insert(kTechData, { 	[kTechDataId] = kTechId.Return,
								[kTechDataDisplayName] = "Return",
								[kTechDataTooltipInfo] = "Returns to previous menu."})
								
	table.insert(kTechData, { 	[kTechDataId] = kTechId.MetabolizeEnergy,           
								[kTechDataCategory] = kTechId.Fade,
								[kTechDataMapName] = Metabolize.kMapName,
								[kTechDataCostKey] = kMetabolizeEnergyResearchCost, 
								[kTechDataResearchTimeKey] = kMetabolizeEnergyResearchTime,        
								[kTechDataDisplayName] = "Metabolize", 
								[kTechDataTooltipInfo] = "Allows fades to regen energy faster."})

	table.insert(kTechData, { 	[kTechDataId] = kTechId.MetabolizeHealth,           
								[kTechDataCategory] = kTechId.Fade,        
								[kTechDataCostKey] = kMetabolizeHealthResearchCost, 
								[kTechDataResearchTimeKey] = kMetabolizeHealthResearchTime,          
								[kTechDataDisplayName] = "Advanced Metabolize", 
								[kTechDataTooltipInfo] = "Allows fades to regen health and energy."})
								
	table.insert(kTechData, { 	[kTechDataId] = kTechId.EvolutionChamber,    
								[kTechDataHint] = "Evolution Chamber", 
								[kTechDataGhostModelClass] = "AlienGhostModel",    
								[kTechDataMapName] = EvolutionChamber.kMapName,                         
								[kTechDataDisplayName] = "Evolution Chamber",  
								[kTechDataCostKey] = 0,         
								[kTechDataBuildTime] = 0, 
								[kTechDataModel] = EvolutionChamber.kModelName,           
								[kTechDataMaxHealth] = 0, 
								[kTechDataMaxArmor] = 0,    
								[kTechDataTooltipInfo] = "Evolution Chamber"})
								
	table.insert(kTechData, { 	[kTechDataId] = kTechId.GorgeTunnelEntrance,
								[kTechDataCategory] = kTechId.Gorge,
								[kTechDataMaxExtents] = Vector(1.2, 1.2, 1.2),
								[kTechDataTooltipInfo] = "GORGE_TUNNEL_TOOLTIP",
								[kTechDataGhostModelClass] = "AlienGhostModel",
								[kTechDataAllowConsumeDrop] = true,
								[kTechDataAllowStacking] = false,
								[kTechDataMaxAmount] = 1,
								[kTechDataMapName] = TunnelEntrance.kMapName,
								[kTechDataDisplayName] = "Gorge Tunnel Entrance",
								[kTechDataCostKey] = kGorgeTunnelCost,
								[kTechDataMaxHealth] = kTunnelEntranceHealth,
								[kTechDataMaxArmor] = kTunnelEntranceArmor,
								[kTechDataBuildTime] = kGorgeTunnelBuildTime,
								[kTechDataModel] = TunnelEntrance.kModelName,
								[kTechDataRequiresInfestation] = false,
								[kTechDataPointValue] = kTunnelEntrancePointValue })
								
	table.insert(kTechData, { 	[kTechDataId] = kTechId.GorgeTunnelExit,
								[kTechDataCategory] = kTechId.Gorge,
								[kTechDataMaxExtents] = Vector(1.2, 1.2, 1.2),
								[kTechDataTooltipInfo] = "GORGE_TUNNEL_TOOLTIP",
								[kTechDataGhostModelClass] = "AlienGhostModel",
								[kTechDataAllowConsumeDrop] = true,
								[kTechDataAllowStacking] = false,
								[kTechDataMaxAmount] = 1,
								[kTechDataMapName] = TunnelExit.kMapName,
								[kTechDataDisplayName] = "Gorge Tunnel Exit",
								[kTechDataCostKey] = kGorgeTunnelCost,
								[kTechDataMaxHealth] = kTunnelEntranceHealth,
								[kTechDataMaxArmor] = kTunnelEntranceArmor,
								[kTechDataBuildTime] = kGorgeTunnelBuildTime,
								[kTechDataModel] = TunnelExit.kModelName,
								[kTechDataRequiresInfestation] = false,
								[kTechDataPointValue] = kTunnelEntrancePointValue })
								
	for index, record in ipairs(kTechData) do 
        if record[kTechDataId] == kTechId.BabblerTech then
			record[kTechDataCostKey] = kBabblersResearchCost	
			record[kTechDataResearchTimeKey] = kBabblersResearchTime
			record[kTechDataDisplayName] = "Babblers"
			record[kTechDataTooltipInfo] = "Allows gorges to create babblers."
		end
		if record[kTechDataId] == kTechId.WebTech then
			record[kTechDataCostKey] = kWebResearchCost	
			record[kTechDataResearchTimeKey] = kWebResearchTime
			record[kTechDataDisplayName] = "Webs"
			record[kTechDataTooltipInfo] = "Allows gorges to create webs."
		end
		if record[kTechDataId] == kTechId.PrototypeLab then
			record[kTechDataMaxArmor] = kPrototypeLabArmor
		end
    end
end

local oldLookupTechId = LookupTechId
local oldLookupTechData = LookupTechData
function LookupTechId(...)
	local techId = oldLookupTechId(...)
	AddCompModTechChanges()
	LookupTechId = oldLookupTechId
	return techId
end

function LookupTechData(...)
	local data = oldLookupTechData(...)
	AddCompModTechChanges()
	LookupTechData = oldLookupTechData
	return data
end

TeamInfo.kRelevantTechIdsAlien =
{
    
    kTechId.GorgeTunnelTech,
    
    kTechId.CragHive,
    kTechId.UpgradeToCragHive,
    kTechId.Shell,
    kTechId.TwoShells,
    kTechId.ThreeShells,
    
    kTechId.ShadeHive,
    kTechId.UpgradeToShadeHive,
    kTechId.Veil,
    kTechId.TwoVeils,
    kTechId.ThreeVeils,
    
    kTechId.ShiftHive,
    kTechId.UpgradeToShiftHive,
    kTechId.Spur,
    kTechId.TwoSpurs,
    kTechId.ThreeSpurs,
    
    kTechId.ResearchBioMassOne,
    kTechId.ResearchBioMassTwo,
    
    kTechId.BabblerTech,
	
	kTechId.MetabolizeEnergy,
	
	kTechId.Charge,
	
	kTechId.BileBomb,
	
	kTechId.Leap,
	
	kTechId.Umbra,
	
	kTechId.MetabolizeHealth,
	
	kTechId.BoneShield,
	
	kTechId.Spores,
	
	kTechId.Stab,
	
	kTechId.WebTech,
	
	kTechId.Stomp,
	
	kTechId.Xenocide	
}

local oldBoneWallOnInitialized = BoneWall.OnInitialized
function BoneWall:OnInitialized()
	oldBoneWallOnInitialized(self)
	if Server then
		local team = self:GetTeam()
		if team then
			local level = math.max(0, team:GetBioMassLevel() - 1)
			local newMaxHealth = kBoneWallHealth + level * kBoneWallHealthPerBioMass
			if newMaxHealth ~= self.maxHealth  then
				self:SetMaxHealth(newMaxHealth)
				self:SetHealth(self.maxHealth)
			end
		end
	end
end

function BoneWall:GetCanBeHealedOverride()
    return false
end

// Comp Mod change, allow targetting of arcs.
function ARC:GetTechButtons(techId)

    return  { kTechId.Stop, kTechId.Attack, kTechId.None, kTechId.None,
              kTechId.ARCDeploy, kTechId.ARCUndeploy, kTechId.None, kTechId.None }
              
end

function ARC:OnOverrideOrder(order)
	if order:GetType() == kTechId.Default then
		if self.deployMode == ARC.kDeployMode.Deployed then
			order:SetType(kTechId.Attack)
		else
			order:SetType(kTechId.Move)
		end
	end
end

function ARC:OnOrderGiven(order)
	if order ~= nil and (order:GetType() == kTechId.Attack or order:GetType() == kTechId.SetTarget) then
		local target = Shared.GetEntity(order:GetParam())
		if target then
			local dist = (self:GetOrigin() - target:GetOrigin()):GetLength()
			local valid = true
			if not HasMixin(target, "Live") or not target:GetIsAlive() then
				valid = false
			end
			if not GetAreEnemies(self, target) then        
				valid = false
			end
			if not target.GetReceivesStructuralDamage or not target:GetReceivesStructuralDamage() then        
				valid = false
			end
			if dist and valid and dist >= ARC.kMinFireRange and dist <= ARC.kFireRange then
				self.targetedEntity = order:GetParam()
				self.orderedEntity = order:GetParam()
			end
		end
    end
end

// Changes to handle the evolution chamber assigned to each hive.
function Hive:GetEvolutionChamber()
	return self.evochamber
end

function Hive:GetTechButtons(techId)

    local techButtons = { kTechId.ShiftHatch, kTechId.None, kTechId.None, kTechId.None,
                          kTechId.None, kTechId.None, kTechId.None, kTechId.None }

    if self:GetTechId() == kTechId.Hive then
    
        techButtons[5] = ConditionalValue(GetHiveTypeResearchAllowed(self, kTechId.UpgradeToCragHive), kTechId.UpgradeToCragHive, kTechId.None)
        techButtons[6] = ConditionalValue(GetHiveTypeResearchAllowed(self, kTechId.UpgradeToShadeHive), kTechId.UpgradeToShadeHive, kTechId.None)
        techButtons[7] = ConditionalValue(GetHiveTypeResearchAllowed(self, kTechId.UpgradeToShiftHive), kTechId.UpgradeToShiftHive, kTechId.None)
    
    end
	
	if self:GetEvolutionChamber() ~= Entity.invalidId then
		techButtons[4] = kTechId.LifeFormMenu
	end
    
    if self.bioMassLevel <= 1 then
        techButtons[2] = kTechId.ResearchBioMassOne
    elseif self.bioMassLevel <= 2 then
        techButtons[2] = kTechId.ResearchBioMassTwo
	else
		
    end
    
    return techButtons
    
end

Shared.LinkClassToMap("Hive", nil, {evochamber = "entityid"})

function BabblerEggAbility:IsAllowed(player)
	return GetHasTech(player, kTechId.BabblerTech)
end

//Babblers cant be healed
function Babbler:GetCanBeHealedOverride()
    return false
end

function WebsAbility:IsAllowed(player)
	return GetHasTech(player, kTechId.WebTech)
end

//Speed up grenades.
//GRENADA!
local oldMarineOnUpdateAnimationInput = Marine.OnUpdateAnimationInput
function Marine:OnUpdateAnimationInput(modelMixin)
	oldMarineOnUpdateAnimationInput(self, modelMixin)
	local activeWeapon = self:GetActiveWeapon()
	local catalystSpeed = 1
	if activeWeapon and (activeWeapon:GetMapName() == PulseGrenadeThrower.kMapName or activeWeapon:GetMapName() == ClusterGrenadeThrower.kMapName or activeWeapon:GetMapName() == GasGrenadeThrower.kMapName) then
		catalystSpeed = 2.75 //SUPA SPEED!
	end
    if self.catpackboost then
        catalystSpeed = kCatPackWeaponSpeed * catalystSpeed
    end
    modelMixin:SetAnimationInput("catalyst_speed", catalystSpeed)
end

local oldBuildClassToGrid = BuildClassToGrid
function BuildClassToGrid()
	local ClassToGrid = oldBuildClassToGrid()
	ClassToGrid["TunnelExit"] = { 3, 8 }
	return ClassToGrid
end

// Add healing per second cap to aliens.
function Alien:ModifyHeal(healTable)
	if self.lasthealingtable == nil then
		self.lasthealingtable = {time = 0, healing = 0}
	end
	
	local curtime = Shared.GetTime()
	
	if curtime < self.lasthealingtable.time + kAlienHealRateTimeLimit then
		//Check current max limit
		if self.lasthealingtable.healing >= kAlienHealRateLimit then
			//Were over the limit, reduce.
			healTable.health = healTable.health * kAlienHealRateOverLimitReduction
		elseif self.lasthealingtable.healing >= (self:GetBaseHealth() * kAlienHealRatePercentLimit) then	//Check current % limit
			//Were over the limit, reduce.
			healTable.health = healTable.health * kAlienHealRateOverLimitReduction
		end
		//Add to current limit
		self.lasthealingtable.healing = self.lasthealingtable.healing + healTable.health
	else
		//Not under limit, clear table
		self.lasthealingtable.time = curtime
		self.lasthealingtable.healing = healTable.health
	end
	
end