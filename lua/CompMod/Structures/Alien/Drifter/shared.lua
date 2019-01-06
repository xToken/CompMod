-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Drifter\shared.lua
-- - Dragon

Drifter.kHoverHeight = 1

local function GetCommander(teamNum)
    local commanders = GetEntitiesForTeam("Commander", teamNum)
    return commanders[1]
end

local CountToResearchId = { }
CountToResearchId[kTechId.Shell] = { [0] = kTechId.Shell, [1] = kTechId.TwoShells, [2] = kTechId.ThreeShells, [3] = kTechId.ThreeShells }
CountToResearchId[kTechId.Spur] = { [0] = kTechId.Spur, [1] = kTechId.TwoSpurs, [2] = kTechId.ThreeSpurs, [3] = kTechId.ThreeSpurs }
CountToResearchId[kTechId.Veil] = { [0] = kTechId.Veil, [1] = kTechId.TwoVeils, [2] = kTechId.ThreeVeils, [3] = kTechId.ThreeVeils }

local function GetTierTech(drifter, techId)
	local comm = GetCommander(drifter:GetTeamNumber())
	return CountToResearchId[techId][comm:GetUpgradeChamberCount(techId)]
end

local kDrifterStructures = { kTechId.Crag, kTechId.Shade, kTechId.Shift, kTechId.Whip,
                            kTechId.Hive, kTechId.Harvester, kTechId.Cyst, kTechId.Shell, 
                            kTechId.TwoShells, kTechId.ThreeShells, kTechId.Spur, 
                            kTechId.TwoSpurs, kTechId.ThreeSpurs, kTechId.Veil, 
                            kTechId.TwoVeils, kTechId.ThreeVeils }

function Drifter:GetTechButtons(techId)

    local techButtons = { kTechId.EnzymeCloud, kTechId.Hallucinate, kTechId.ParasiteCloud, kTechId.TeleportStructure,
                                kTechId.StructureMenu, kTechId.AdvancedStructureMenu, kTechId.Move, kTechId.Patrol }
    
    if techId == kTechId.StructureMenu then
        techButtons = { kTechId.Crag, kTechId.Shade, kTechId.Shift, kTechId.Whip,
                               kTechId.Hive, kTechId.Harvester, kTechId.Cyst, kTechId.RootMenu }
    end
    if techId == kTechId.AdvancedStructureMenu then
        techButtons = { GetTierTech(self, kTechId.Shell), GetTierTech(self, kTechId.Veil), GetTierTech(self, kTechId.Spur), kTechId.None,
                               kTechId.None, kTechId.None, kTechId.None, kTechId.RootMenu }
    end
    return techButtons

end

function Drifter:ProcessParasiteCloudOrder(techId, position, commander)

    local origin = self:GetOrigin()
    local trace = Shared.TraceRay(
        origin, 
        position, 
        CollisionRep.Damage, 
        PhysicsMask.Bullets, 
        EntityFilterOneAndIsa(self, "Babbler")
    )
    
    local travelVector = trace.endPoint - origin
    local distance = math.min( ParasiteCloud.kMaxRange, travelVector:GetLength() )
    local destination = GetNormalizedVector(travelVector) * distance + origin
    local paraCloud = CreateEntity( ParasiteCloud.kMapName, origin, commander:GetTeamNumber() )

    paraCloud:SetTravelDestination( destination )

    return true

end

function Drifter:PerformActivation(techId, position, normal, commander, targetId)

    local success = false
    local keepProcessing = true

    if techId == kTechId.NutrientMist then

        local team = self:GetTeam()
        local cost = GetCostForTech(techId)
        if cost <= team:GetTeamResources() and targetId then

            self:GiveOrder(techId, targetId, position, nil, not commander.shiftDown, false)
            -- Only 1 Drifter will process this activation.
            keepProcessing = false

        end

        -- return false, team res will be drained once we reached the destination and created the enzyme entity
        success = false

    elseif techId == kTechId.EnzymeCloud or techId == kTechId.Hallucinate or techId == kTechId.MucousMembrane or techId == kTechId.Storm then

        local team = self:GetTeam()
        local cost = GetCostForTech(techId)
        if cost <= team:GetTeamResources() then

            self:GiveOrder(techId, targetId, position + Vector(0, 0.2, 0), nil, not commander.shiftDown, false)
            -- Only 1 Drifter will process this activation.
            keepProcessing = false

        end

        -- return false, team res will be drained once we reached the destination and created the enzyme entity
        success = false

    elseif table.contains(kDrifterStructures, techId) then

    	local team = self:GetTeam()
        local cost = GetCostForTech(techId)
        if cost <= team:GetTeamResources() then
            self:GiveOrder(techId, nil, position, nil, not commander.shiftDown, false)
            keepProcessing = false
        end
        success = false

    elseif techId == kTechId.ParasiteCloud then

        success = self:ProcessParasiteCloudOrder(techId, position+ Vector(0, 2.5, 0), commander)
        keepProcessing = false

    elseif GetIsEchoTeleportTechId(techId) then

        local team = self:GetTeam()
        local cost = GetCostForTech(techId)
        if cost <= team:GetTeamResources() then
            self:GiveOrder(techId, targetId, position, nil, not commander.shiftDown, false)
            keepProcessing = false
        end
        success = false

    else
        return ScriptActor.PerformActivation(self, techId, position, normal, commander)
    end

    return success, keepProcessing

end

function Drifter:ProcessMistOrder(moveSpeed, deltaTime)

    local currentOrder = self:GetCurrentOrder()
    local targetEnt = Shared.GetEntity(currentOrder:GetParam())

    if currentOrder then

        if not targetEnt then
            return self:ClearOrders()
        end

        local targetPos = currentOrder:GetLocation()
        local commander = GetCommander(self:GetTeamNumber())
        local team = self:GetTeam()
        local cost = GetCostForTech(kTechId.NutrientMist)
        local techId = targetEnt and targetEnt:GetTechId() or kTechId.None
        local range = 3

        -- check if we can reach the destinaiton
        if targetEnt and (targetEnt:GetOrigin() - self:GetOrigin()):GetLengthXZ() < range then
            -- Dont allow stacking more than 30s of catalyst
            if HasMixin(targetEnt, "Catalyst") then
                if targetEnt.timeUntilCatalystEnd + kNutrientMistDuration < kNutrientMistMaxStackTime and not targetEnt:isa("Player") then
                    targetEnt:TriggerCatalyst(kNutrientMistDuration, self:GetId())
                    commander:TriggerEffects("comm_nutrient_mist")
                    team:AddTeamResources(-cost)
                else
                    -- dont trigger
                    commander:TriggerInvalidSound()
                end
            end
            self:CompletedCurrentOrder()
            self:TriggerUncloak()
        else
            -- move to target otherwise
            if self:MoveToTarget(PhysicsMask.AIMovement, targetEnt:GetOrigin(), moveSpeed, deltaTime) then
                self:ClearOrders()
            end

        end

    end

end

function Drifter:ProcessTeleportOrder(moveSpeed, deltaTime)

    local currentOrder = self:GetCurrentOrder()

    if currentOrder then

        local teleportPos = currentOrder:GetLocation()
        local teleportEnt = Shared.GetEntity(currentOrder:GetParam())
        local techId = currentOrder:GetType()
        local range = 3
        local targetPos = teleportEnt:GetOrigin()

        if not teleportEnt then
            self:ClearOrders()
            return false
        end

        if (targetPos - self:GetOrigin()):GetLengthXZ() < range then

            local commander = GetCommander(self:GetTeamNumber())
            local team = self:GetTeam()
            local cost = GetCostForTech(techId)
            local success = false
            if commander then
                if cost <= team:GetTeamResources() then
                    local legalBuildPosition, position, _, errorString = GetIsBuildLegal(techId, teleportPos, math.random() * 2 * math.pi, kStructureSnapRadius, commander)
                    if legalBuildPosition and teleportEnt:GetCanTeleport() then
                        teleportEnt:TriggerTeleport(kEchoTeleportTime, self:GetId(), position, cost)
                        if HasMixin(teleportEnt, "Orders") then
                            teleportEnt:ClearCurrentOrder()
                        end
                        team:AddTeamResources(-cost)
                        Shared.PlayPrivateSound(commander, Shift.kShiftEchoSound2D, nil, 1.0, self:GetOrigin())   
                        success = true
                    end
                end
            end

            self:CompletedCurrentOrder()

        else

            -- move to target otherwise
            if self:MoveToTarget(PhysicsMask.AIMovement, targetPos, moveSpeed, deltaTime) then
                self:ClearOrders()
            end

        end

    end

end

function Drifter:ProcessBuildOrder(moveSpeed, deltaTime)

    local currentOrder = self:GetCurrentOrder()

    if currentOrder then

        local targetPos = currentOrder:GetLocation()
        local techId = currentOrder:GetType()
        local range = 3

        if (targetPos - self:GetOrigin()):GetLengthXZ() < range then

            local commander = GetCommander(self:GetTeamNumber())
            local team = self:GetTeam()
		    local cost = GetCostForTech(techId)
            local success = false
		    if commander then
		    	if cost <= team:GetTeamResources() then
		    		local trace = GetCommanderPickTarget(commander, targetPos + Vector(0, 2, 0), true, true, LookupTechData(techId, kTechDataCollideWithWorldOnly, false))
                    if trace and trace.fraction < 1 then
    	                success = commander:AttemptToBuild(techId, trace.endPoint, trace.normal, math.random() * 2 * math.pi, true, nil, self)
    		            if success then
    		            	team:AddTeamResources(-cost)
    		            end
                    end
	        	end
	        end
            self:CompletedCurrentOrder()

        else

            -- move to target otherwise
            if self:MoveToTarget(PhysicsMask.AIMovement, targetPos, moveSpeed, deltaTime) then
                self:ClearOrders()
            end

        end

    end

end

local oldDrifterOnUpdate = Drifter.OnUpdate
function Drifter:OnUpdate(deltaTime)
	oldDrifterOnUpdate(self, deltaTime)
	if Server then
		if not self:GetIsAlive() then
	        return
	    end
	    local maxSpeedTable = { maxSpeed = Drifter.kMoveSpeed }
        self:ModifyMaxSpeed(maxSpeedTable)
        local drifterMoveSpeed = maxSpeedTable.maxSpeed
	    local currentOrder = self:GetCurrentOrder()
	    if currentOrder then
	    	if table.contains(kDrifterStructures, currentOrder:GetType()) then
	    		self:ProcessBuildOrder(drifterMoveSpeed, deltaTime)
	    	end
	    	if currentOrder:GetType() == kTechId.NutrientMist then
	    		self:ProcessMistOrder(drifterMoveSpeed, deltaTime)
	    	end
            if GetIsEchoTeleportTechId(currentOrder:GetType()) then
                self:ProcessTeleportOrder(drifterMoveSpeed, deltaTime)
            end
	    end
	end
end