// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Client\GrenadeAdjustments.lua
// - Dragon

Script.Load("lua/Hud/GUIEvent.lua")

local function SetupActionIcons()
	local kIconOffsets = GetUpValue( GUIActionIcon.ShowIcon,   "kIconOffsets")
	kIconOffsets["GasGrenadeThrower"] = 4
	kIconOffsets["ClusterGrenadeThrower"] = 4
	kIconOffsets["PulseGrenadeThrower"] = 4
end

AddPostInitOverride("GUIActionIcon", SetupActionIcons)

local function SetupPickupOffset()
	local kPickupTextureYOffsets = GetUpValue( GUIPickups.Update,   "kPickupTextureYOffsets", 			{ LocateRecurse = true } )
	kPickupTextureYOffsets["GasGrenadeThrower"] = 6
	kPickupTextureYOffsets["ClusterGrenadeThrower"] = 6
	kPickupTextureYOffsets["PulseGrenadeThrower"] = 6
end

AddPostInitOverride("GUIPickups", SetupPickupOffset)

local OtherNades = 
{
[kTechId.ClusterGrenade] = { kTechId.GasGrenade, kTechId.PulseGrenade },
[kTechId.GasGrenade] = { kTechId.ClusterGrenade, kTechId.PulseGrenade },
[kTechId.PulseGrenade] = { kTechId.ClusterGrenade, kTechId.GasGrenade }
}

local kGrenades =
{
    kTechId.ClusterGrenade,
    kTechId.GasGrenade,
    kTechId.PulseGrenade
}

function MarineBuy_GetEquipment()
    
    local inventory = {}
    local player = Client.GetLocalPlayer()
    local items = GetChildEntities( player, "ScriptActor" )
    
    for index, item in ipairs(items) do
    
        local techId = item:GetTechId()
        
        if techId ~= kTechId.Pistol and techId ~= kTechId.Axe and techId ~= kTechId.Rifle then
        //can't buy above, so skip
            
            local itemName = GetDisplayNameForTechId(techId)    //simple validity check
            if itemName then
                inventory[techId] = true
            end
			
			if OtherNades[techId] then
				//Block all other nade types
				for i = 1, #OtherNades[techId] do
					inventory[OtherNades[techId][i]] = true
				end
				//Block this type only if you are full.
				if item.GetRemainingGrenades and item:GetRemainingGrenades() < kMaxHandGrenades then
					//Need to manually specify false :/
					inventory[techId] = nil
				end
			end
			
        end

    end
    
    if player:isa("JetpackMarine") then
        inventory[kTechId.Jetpack] = true
    //elseif player:isa("Exo") then
        //Exo's are inheriently handled by how the BuyMenus are organized
    end
    
    return inventory
    
end

function PlayerUI_GetHasItem(techId)

    local hasItem = false
    local isaGrenade = table.contains(kGrenades, techId)

    if techId and techId ~= kTechId.None then
    
        local player = Client.GetLocalPlayer()
        if player then
        
            local items = GetChildEntities(player, "ScriptActor")

            for index, item in ipairs(items) do
			
				if isaGrenade and table.contains(kGrenades, item:GetTechId()) then
					
					if item:GetTechId() == techId and item.GetRemainingGrenades and item:GetRemainingGrenades() < kMaxHandGrenades then
						//Have grenades, but missing some
						break
					end
				
					hasItem = true
                    break
				
				elseif item:GetTechId() == techId then
                
                    hasItem = true
                    break
					
				end

            end
        
        end
    
    end
    
    return hasItem

end

local function GetMaxDistanceFor(player)
    
	if player:isa("AlienCommander") then
		return 63
	end

	return 33

end

local function GetIsObscurred(viewer, target)

	local targetOrigin = HasMixin(target, "Target") and target:GetEngagementPoint() or target:GetOrigin()
	local eyePos = GetEntityEyePos(viewer)

	local trace = Shared.TraceRay(eyePos, targetOrigin, CollisionRep.LOS, PhysicsMask.All, EntityFilterAll())
	
	if trace.fraction == 1 then
		return false
	end
		
	return true    

end

//HiveVision for Nades
function HiveVisionMixin:OnUpdate(deltaTime)

	PROFILE("HiveVisionMixin:OnUpdate")
	
	// Determine if the entity should be visible on hive sight
	local visible = HasMixin(self, "ParasiteAble") and self:GetIsParasited()
	local player = Client.GetLocalPlayer()
	local now = Shared.GetTime()
	
	if Client.GetLocalClientTeamNumber() == kSpectatorIndex
		  and self:isa("Alien") 
		  and Client.GetOutlinePlayers()
		  and not self.hiveSightVisible then

		local model = self:GetRenderModel()
		if model ~= nil then
		
			HiveVision_AddModel( model )
			   
			self.hiveSightVisible = true    
			self.timeHiveVisionChanged = now
			
		end
	
	end
	
	// check the distance here as well. seems that the render mask is not correct for newly created models or models which get destroyed in the same frame
	local playerCanSeeHiveVision = player ~= nil and (player:GetOrigin() - self:GetOrigin()):GetLength() <= GetMaxDistanceFor(player) and (player:isa("Alien") or player:isa("AlienCommander") or player:isa("AlienSpectator"))

	if not visible and playerCanSeeHiveVision and self:isa("Player") then
	
		// Make friendly players always show up - even if not obscured     
		visible = player ~= self and GetAreFriends(self, player)
		
	end
	
	if self:isa("Grenade") then
		//Grenades always visible
		visible = true
	end
	
	if visible and not playerCanSeeHiveVision then
		visible = false
	end
	
	// Update the visibility status.
	if visible ~= self.hiveSightVisible and self.timeHiveVisionChanged + 1 < now then
	
		local model = self:GetRenderModel()
		if model ~= nil then
		
			if visible then
				HiveVision_AddModel( model )
				//DebugPrint("%s add model", self:GetClassName())
			else
				HiveVision_RemoveModel( model )
				//DebugPrint("%s remove model", self:GetClassName())
			end 
			   
			self.hiveSightVisible = visible    
			self.timeHiveVisionChanged = now
			
		end
		
	end
		
end