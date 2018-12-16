-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\HallucinationCloud.lua
-- - Dragon

HallucinationCloud.kRadius = kHallucinationCloudRadius

if Server then

	local lifeformTypes = GetUpValue( HallucinationCloud.Perform, "lifeformTypes", { LocateRecurse = true } )
	local GetPlayerNamesByLifeform = GetUpValue( HallucinationCloud.Perform, "GetPlayerNamesByLifeform", { LocateRecurse = true } )
	local GetLowestLifeformPlayerFromTable = GetUpValue( HallucinationCloud.Perform, "GetLowestLifeformPlayerFromTable", { LocateRecurse = true } )
	local AllowedToHallucinate = GetUpValue( HallucinationCloud.Perform, "AllowedToHallucinate", { LocateRecurse = true } )

	function HallucinationCloud:Perform()
			
		-- kill all hallucinations before, to prevent unreasonable spam
		for _, hallucination in ipairs(GetEntitiesForTeam("Hallucination", self:GetTeamNumber())) do
			hallucination.consumed = true
			hallucination:Kill()
		end
		
		-- search for alien in range, cloak them and create a hallucination
		local hallucinatePlayers = {}
		local numHallucinatePlayers = 0
		for _, alien in ipairs(GetEntitiesForTeamWithinRange("Alien", self:GetTeamNumber(), self:GetOrigin(), HallucinationCloud.kRadius)) do
		
			if alien:GetIsAlive() and not alien:isa("Embryo") and not HasMixin(alien, "PlayerHallucination") then
			
				table.insert(hallucinatePlayers, alien)
				numHallucinatePlayers = numHallucinatePlayers + 1
			
			end
			
		end
		
		-- sort by techId, so the higher life forms are prefered
		local function SortByTechId(alienOne, alienTwo)
			return alienOne:GetTechId() > alienTwo:GetTechId()
		end
		
		table.sort(hallucinatePlayers, SortByTechId)
		
		local hallucinationsCreated = 0

		for index, alien in ipairs(hallucinatePlayers) do
		
			if AllowedToHallucinate(alien) then
			
				local newAlienExtents = LookupTechData(alien:GetTechId(), kTechDataMaxExtents)
				local capsuleHeight, capsuleRadius = GetTraceCapsuleFromExtents(newAlienExtents) 
				
				local spawnPoint = GetRandomSpawnForCapsule(newAlienExtents.y, capsuleRadius, alien:GetModelOrigin(), 0.5, 5)
				
				if spawnPoint then

					local hallucinatedPlayer = CreateEntity(alien:GetMapName(), spawnPoint, self:GetTeamNumber())
					
					-- make drifter keep a record of any hallucinations created from its cloud, so they 
					-- die when drifter dies.
					self:RegisterHallucination(hallucinatedPlayer)
					
					if alien:isa("Alien") then
						hallucinatedPlayer:SetVariant(alien:GetVariant())
					end
					hallucinatedPlayer.isHallucination = true
					InitMixin(hallucinatedPlayer, PlayerHallucinationMixin)                
					InitMixin(hallucinatedPlayer, SoftTargetMixin)                
					InitMixin(hallucinatedPlayer, OrdersMixin, { kMoveOrderCompleteDistance = kPlayerMoveOrderCompleteDistance }) 

					hallucinatedPlayer:SetName(alien:GetName())
					hallucinatedPlayer:SetHallucinatedClientIndex(alien:GetClientIndex())
				
					hallucinationsCreated = hallucinationsCreated + 1
				
				end 
			
			end
			
			if hallucinationsCreated >= kMaxHallucinations then
				break
			end    
		
		end
		
		-- if we still haven't created enough hallucinations, fill in the rest with skulks.
		local remaining = kMaxHallucinations - hallucinationsCreated
		if remaining > 0 then
			local extents = LookupTechData(kTechId.Skulk, kTechDataMaxExtents)
			local capsuleHeight, capsuleRadius = GetTraceCapsuleFromExtents(extents)
			local playerNamesByLifeform = GetPlayerNamesByLifeform()
			
			for i=1, remaining do
				local spawnPoint = GetRandomSpawnForCapsule(extents.y, capsuleRadius, self:GetOrigin(), 0.0, HallucinationCloud.kRadius)
				if spawnPoint then
					local hallucination = CreateEntity(Skulk.kMapName, spawnPoint, self:GetTeamNumber())
					
					-- make drifter keep a record of any hallucinations created from its cloud, so they 
					-- die when drifter dies.
					self:RegisterHallucination(hallucination)
					
					hallucination.isHallucination = true
					InitMixin(hallucination, PlayerHallucinationMixin)
					InitMixin(hallucination, SoftTargetMixin)
					InitMixin(hallucination, OrdersMixin, { kMoveOrderCompleteDistance = kPlayerMoveOrderCompleteDistance })
					
					-- use existing player names.  Try to pick skulk names as that would be more believeable (other team tends to notice
					-- who the onos is and when they died.  Would be a dead-giveaway that a skulk is hallucinated if they recognize it as
					-- the onos player.  If no players are skulks, try gorge-player-names.  If no gorges... lerks.  And so on...
					local namePlayer = GetLowestLifeformPlayerFromTable(playerNamesByLifeform)
					if namePlayer then
						hallucination:SetName(namePlayer:GetName())
						hallucination:SetHallucinatedClientIndex(namePlayer:GetClientIndex())
						local client = namePlayer:GetClient()
						if client then
							hallucination:SetVariant(client.variantData.skulkVariant or kSkulkVariant.normal)
						end
					end
				end
			end
		end
		
		for _, resourcePoint in ipairs(GetEntitiesWithinRange("ResourcePoint", self:GetOrigin(), HallucinationCloud.kRadius)) do
		
			if resourcePoint:GetAttached() == nil and GetIsPointOnInfestation(resourcePoint:GetOrigin()) then
			
				local hallucination = CreateEntity(Hallucination.kMapName, resourcePoint:GetOrigin(), self:GetTeamNumber())
				self:RegisterHallucination(hallucination)
				hallucination:SetEmulation(kTechId.HallucinateHarvester)
				hallucination:SetAttached(resourcePoint)
				
			end
		
		end
		
		for _, techPoint in ipairs(GetEntitiesWithinRange("TechPoint", self:GetOrigin(), HallucinationCloud.kRadius)) do
		
			if techPoint:GetAttached() == nil then
			
				local coords = techPoint:GetCoords()
				coords.origin = coords.origin + Vector(0, 2.494, 0)
				local hallucination = CreateEntity(Hallucination.kMapName, techPoint:GetOrigin(), self:GetTeamNumber())
				self:RegisterHallucination(hallucination)
				hallucination:SetEmulation(kTechId.HallucinateHive)
				hallucination:SetAttached(techPoint)
				hallucination:SetCoords(coords)
				
			end
		
		end

	end
	
end