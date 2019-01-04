-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Weapons\Marine\Mine\shared.lua
-- - Dragon

local kClientOwnedMines = { }

if Server then

	local Detonate = GetUpValue(Mine.OnInitialized, "Detonate", { LocateRecurse = true } )

	local function Arm(self)

		if not self.armed then

			self:AddTimedCallback(function() Detonate(self, Arm) end, kMineArmingTime)
		
			self:TriggerEffects("mine_arm")
			
			self.armed = true

		end
		
	end
	
	function GetClientDeployedMines(clientId)
		return kClientOwnedMines[clientId] and #kClientOwnedMines[clientId] or 0
	end
	
	function Mine:GetSendDeathMessageOverride()
        return not self.armed
    end
	
	function Mine:GetDestroyOnKill()
		return not self.active
    end

	function Mine:OnKill(attacker, doer, point, direction)
		
		if self.active then
			Arm(self)
		end
        
        ScriptActor.OnKill(self, attacker, doer, point, direction)
        
    end
		
	local function UpdateMarineLayMinesWeapons(marine, count)
		if marine and marine:isa("Marine") then
			for i = 0, marine:GetNumChildren() - 1 do
				local child = marine:GetChildAtIndex(i)
				if child:GetMapName() == LayMines.kMapName then
					child:SetDeployedMines(count)
				end
			end
		end
	end
	
	function Mine:OnDestroy()
	
		--[[local id = self:GetId()
		if kClientOwnedMines[self.owningId] then
			for i = 1, #kClientOwnedMines[self.owningId] do
				if kClientOwnedMines[self.owningId][i] == id then
					table.remove(kClientOwnedMines[self.owningId], i)
					UpdateMarineLayMinesWeapons(self:GetOwner(), #kClientOwnedMines[self.owningId])
				end
			end
		end]]
		
    end
	
	ReplaceUpValue(Mine.OnInitialized, "Arm", Arm, { LocateRecurse = true } )
	
	local function CheckOverMineLimit(self)
		local player = self:GetOwner()
		local success = false
		-- Keep the mine spam in check yo!
		if player then
			local owner = Server.GetOwner(player)
			if owner then
				local clientId = owner:GetUserId()
				if kClientOwnedMines[clientId] == nil then
					kClientOwnedMines[clientId] = { }
				end
				if #kClientOwnedMines[clientId] >= kMinesPerPlayerLimit then
					-- Grab oldest Mine
					local mine = Shared.GetEntity(kClientOwnedMines[clientId][1])
					-- Make sure its a mine, if the game is reset/whatever entityIDs can be reused.
					if mine and mine:isa("Mine") then
						-- This removes it from the table
						DestroyEntity(mine)
					else
						-- Some shenanigans are going on... just remove.
						table.remove(kClientOwnedMines[clientId], 1)
					end
					success = true
				else
					-- Under limit
					success = true
				end
				self.owningId = clientId
				table.insert(kClientOwnedMines[clientId], self:GetId())
				UpdateMarineLayMinesWeapons(player, #kClientOwnedMines[clientId])
			end
		end
		if not success then
			DestroyEntity(self)
		end
	end
	
	local originalMineOnInitialized
	originalMineOnInitialized = Class_ReplaceMethod("Mine", "OnInitialized",
		function(self)
			originalMineOnInitialized(self)
			--self:AddTimedCallback(CheckOverMineLimit, 0.1)
		end
	)
	
end