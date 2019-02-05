-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Alien\Drifter\shared.lua
-- - Dragon

Drifter.kHoverHeight = 1

local originalDrifterOnCreate
originalDrifterOnCreate = Class_ReplaceMethod("Drifter", "OnCreate",
    function(self)
        originalDrifterOnCreate(self)
        InitMixin(self, BuildingMixin)
    end
)

local function GetCommander(teamNum)
    local commanders = GetEntitiesForTeam("Commander", teamNum)
    return commanders[1]
end

local CountToResearchId = { }
CountToResearchId[kTechId.Shell] = { [0] = kTechId.Shell, [1] = kTechId.Shell2, [2] = kTechId.Shell3, [3] = kTechId.Shell3 }
CountToResearchId[kTechId.Spur] = { [0] = kTechId.Spur, [1] = kTechId.Spur2, [2] = kTechId.Spur3, [3] = kTechId.Spur3 }
CountToResearchId[kTechId.Veil] = { [0] = kTechId.Veil, [1] = kTechId.Veil2, [2] = kTechId.Veil3, [3] = kTechId.Veil3 }

local function GetTierTech(drifter, techId)
	local comm = GetCommander(drifter:GetTeamNumber())
    if comm and CountToResearchId[techId] then
	   return CountToResearchId[techId][comm:GetUpgradeChamberCount(techId)]
    end
end

kDrifterStructures = { kTechId.Crag, kTechId.Shade, kTechId.Shift, kTechId.Whip,
                            kTechId.Hive, kTechId.Harvester, kTechId.Cyst, kTechId.Shell, 
                            kTechId.Shell2, kTechId.Shell3, kTechId.Spur, 
                            kTechId.Spur2, kTechId.Spur3, kTechId.Veil, 
                            kTechId.Veil2, kTechId.Veil3, kTechId.Cyst, kTechId.InfestedNode }

function Drifter:GetTechButtons(techId)

    local techButtons = { kTechId.EnzymeCloud, kTechId.Hallucinate, kTechId.ParasiteCloud, kTechId.TeleportStructure,
                                kTechId.StructureMenu, kTechId.AdvancedStructureMenu, kTechId.Move, kTechId.Patrol }
    
    if techId == kTechId.StructureMenu then
        techButtons = { kTechId.Crag, kTechId.Shade, kTechId.Shift, kTechId.Whip,
                               kTechId.Hive, kTechId.Harvester, kTechId.Cyst, kTechId.RootMenu }
    end
    if techId == kTechId.AdvancedStructureMenu then
        techButtons = { GetTierTech(self, kTechId.Shell), GetTierTech(self, kTechId.Veil), GetTierTech(self, kTechId.Spur), kTechId.InfestedNode,
                               kTechId.None, kTechId.None, kTechId.None, kTechId.RootMenu }
    end
    return techButtons

end

function Drifter:PerformActivation(techId, position, normal, commander, targetId)

    local success = false
    local keepProcessing = true

    if techId == kTechId.EnzymeCloud or techId == kTechId.Hallucinate or techId == kTechId.MucousMembrane or techId == kTechId.Storm then

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

        local team = self:GetTeam()
        local cost = GetCostForTech(techId)
        if cost <= team:GetTeamResources() then
            self:GiveOrder(techId, nil, position + Vector(0, 2.5, 0), nil, not commander.shiftDown, false)
            -- Only 1 Drifter will process this activation.
            keepProcessing = false
        end
        success = false --self:ProcessParasiteCloudOrder(techId, position+ Vector(0, 2.5, 0), commander)

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

function Drifter:ProcessParasiteCloudOrder(moveSpeed, deltaTime)

    local currentOrder = self:GetCurrentOrder()
    if currentOrder then

        local targetPos = currentOrder:GetLocation()
        local commander = GetCommander(self:GetTeamNumber())
        local team = self:GetTeam()
        local cost = GetCostForTech(kTechId.ParasiteCloud)
        local origin = self:GetOrigin()
        local trace = Shared.TraceRay(origin, targetPos, CollisionRep.Move, PhysicsMask.Bullets, EntityFilterAll())

        -- check if we can SEE the destination      
        if trace.fraction == 1 then

            local travelVector = targetPos - origin
            local distance = math.min( ParasiteCloud.kMaxRange, travelVector:GetLength() )
            local destination = GetNormalizedVector(travelVector) * distance + origin
            local paraCloud = CreateEntity( ParasiteCloud.kMapName, origin, commander:GetTeamNumber() )

            paraCloud:SetTravelDestination( destination )

            self:CompletedCurrentOrder()
            self:TriggerUncloak()
        else
            -- move to target otherwise
            if self:MoveToTarget(PhysicsMask.AIMovement, targetPos, moveSpeed, deltaTime) then
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
            if cost <= team:GetTeamResources() then
                local legalBuildPosition, position, _, errorString = GetIsBuildLegal(techId, teleportPos, math.random() * 2 * math.pi, kStructureSnapRadius, commander)
                if legalBuildPosition and teleportEnt:GetCanTeleport() then
                    teleportEnt:TriggerTeleport(kEchoTeleportTime, self:GetId(), position, cost)
                    if HasMixin(teleportEnt, "Orders") then
                        teleportEnt:ClearCurrentOrder()
                    end
                    team:AddTeamResources(-cost)
                    if commander then
                        Shared.PlayPrivateSound(commander, Shift.kShiftEchoSound2D, nil, 1.0, self:GetOrigin())   
                    end
                    success = true
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
        local tierTechId = GetTierTech(self, techId)
        local range = 3

        if (targetPos - self:GetOrigin()):GetLengthXZ() < range then

            --local commander = GetCommander(self:GetTeamNumber())
            local team = self:GetTeam()
		    local cost = GetCostForTech(techId)
            local success = false
		    if team then
                local techTree = team:GetTechTree()
                local techNode = techTree:GetTechNode(techId)
                local techNode2 = techTree:GetTechNode(tierTechId)
    	    	if cost <= team:GetTeamResources() then
    	    		local trace = GetCommanderPickTarget(self, targetPos + Vector(0, 2, 0), true, true, LookupTechData(techId, kTechDataCollideWithWorldOnly, false))
                    if techNode:GetAvailable() and (not techNode2 or techNode2:GetAvailable()) and trace and trace.fraction < 1 then
    	                success = self:AttemptToBuild(techId, trace.endPoint, trace.normal, math.random() * 2 * math.pi, true, nil, self)
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
            if GetIsEchoTeleportTechId(currentOrder:GetType()) then
                self:ProcessTeleportOrder(drifterMoveSpeed, deltaTime)
            end
            if currentOrder:GetType() == kTechId.ParasiteCloud then
                self:ProcessParasiteCloudOrder(drifterMoveSpeed, deltaTime)
            end
	    end
	end
end

-- For NSL Mod
function GetOldDrifterOnUpdateHook()
    return oldDrifterOnUpdate
end

if Server then

    function Drifter:GetTechTree()

        local techTree

        local team = self:GetTeam()
        if team and team:isa("PlayingTeam") then
            techTree = team:GetTechTree()
        end
        
        return techTree

    end


end