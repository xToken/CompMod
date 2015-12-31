// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Server\ExosuitParasiteAdjustments.lua
// - Dragon

local function StorePrevPlayer(self, exo)

    exo.prevPlayerMapName = self:GetMapName()
    exo.prevPlayerHealth = self:GetHealth()
    exo.prevPlayerMaxArmor = self:GetMaxArmor()
    exo.prevPlayerArmor = self:GetArmor()
    exo.prevIsParasited = self:GetIsParasited()
	exo.prevIsParasitedTime = self.timeParasited
	
end

ReplaceLocals(Marine.GiveExo, { StorePrevPlayer = StorePrevPlayer })

function Exo:PerformEject()

	if self:GetIsAlive() then
	
		// pickupable version
		local exosuit = CreateEntity(Exosuit.kMapName, self:GetOrigin(), self:GetTeamNumber())
		exosuit:SetLayout(self.layout)
		exosuit:SetCoords(self:GetCoords())
		exosuit:SetMaxArmor(self:GetMaxArmor())
		exosuit:SetArmor(self:GetArmor())
		exosuit:SetExoVariant(self:GetExoVariant())
		if self:GetIsParasited() then
			exosuit:SetParasited()
			exosuit.timeParasited = self.timeParasited
		end
		
		local reuseWeapons = self.storedWeaponsIds ~= nil
	
		local marine = self:Replace(self.prevPlayerMapName or Marine.kMapName, self:GetTeamNumber(), false, self:GetOrigin() + Vector(0, 0.2, 0), { preventWeapons = reuseWeapons })
		marine:SetHealth(self.prevPlayerHealth or kMarineHealth)
		marine:SetMaxArmor(self.prevPlayerMaxArmor or kMarineArmor)
		marine:SetArmor(self.prevPlayerArmor or kMarineArmor)
		
		if self.prevIsParasited then
			marine:SetParasited()
			marine.timeParasited = self.prevIsParasitedTime
		else
			marine:RemoveParasite()			
		end
		
		exosuit:SetOwner(marine)
		
		marine.onGround = false
		local initialVelocity = self:GetViewCoords().zAxis
		initialVelocity:Scale(4)
		initialVelocity.y = 9
		marine:SetVelocity(initialVelocity)
		
		if reuseWeapons then
	 
			for _, weaponId in ipairs(self.storedWeaponsIds) do
			
				local weapon = Shared.GetEntity(weaponId)
				if weapon then
					marine:AddWeapon(weapon)
				end
				
			end
		
		end
		
		marine:SetHUDSlotActive(1)
		
		if marine:isa("JetpackMarine") then
			marine:SetFuel(0)
		end
	
	end

	return false

end

function Exosuit:OnUseDeferred()
        
	local player = self.useRecipient 
	self.useRecipient = nil
	
	if player and not player:GetIsDestroyed() and self:GetIsValidRecipient(player) then
	
		local weapons = player:GetWeapons()
		for i = 1, #weapons do            
			weapons[i]:SetParent(nil)            
		end

		local exoPlayer = nil

		if self.layout == "MinigunMinigun" then
			exoPlayer = player:GiveDualExo()            
		elseif self.layout == "RailgunRailgun" then
			exoPlayer = player:GiveDualRailgunExo()
		elseif self.layout == "ClawRailgun" then
			exoPlayer = player:GiveClawRailgunExo()
		else
			exoPlayer = player:GiveExo()
		end  

		if exoPlayer then
					   
			for i = 1, #weapons do
				exoPlayer:StoreWeapon(weapons[i])
			end 

			exoPlayer:SetMaxArmor(self:GetMaxArmor())  
			exoPlayer:SetArmor(self:GetArmor())
			if self:GetIsParasited() then
				exoPlayer:SetParasited()
				exoPlayer.timeParasited = self.timeParasited
			end
			local newAngles = player:GetViewAngles()
			newAngles.pitch = 0
			newAngles.roll = 0
			newAngles.yaw = GetYawFromVector(self:GetCoords().zAxis)
			exoPlayer:SetOffsetAngles(newAngles)
			// the coords of this entity are the same as the players coords when he left the exo, so reuse these coords to prevent getting stuck
			exoPlayer:SetCoords(self:GetCoords())
			
			self:TriggerEffects("pickup")
			DestroyEntity(self)
			
		end
		
	end
	
end