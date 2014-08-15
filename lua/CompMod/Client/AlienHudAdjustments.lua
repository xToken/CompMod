//Dont want to always replace random files, so this.

function AlienUI_GetMovementSpecialCooldown()

    local cd = 0
    
    local player = Client.GetLocalPlayer()
    if player and player.GetMovementSpecialCooldown then
        cd = player:GetMovementSpecialCooldown()
    end
     
    return cd

end

local function ReplaceUpdateAlienAbilities()

	local oldGUIAlienHUDUpdate = GUIAlienHUD.Update
	function GUIAlienHUD:Update(deltaTime)
		oldGUIAlienHUDUpdate(self, deltaTime)
		
		local hasMovementSpecial = AlienUI_GetHasMovementSpecial()
		if hasMovementSpecial then

			local techId = AlienUI_GetMovementSpecialTechId()
			if techId and techId == kTechId.MetabolizeEnergy then
				local cooldownpercentage = AlienUI_GetMovementSpecialCooldown()
				
				if self.movementSpecialCooldown == nil then
					self.movementSpecialCooldown = GUIDial()
					self.movementSpecialCooldown:Initialize({	BackgroundWidth = 31,
																BackgroundHeight = 31,
																BackgroundAnchorX = GUIItem.Left,
																BackgroundAnchorY = GUIItem.Bottom,
																BackgroundOffset = Vector(19, -19, 0),
																BackgroundTextureName = "ui/alien_command_cooldown.dds",
																BackgroundTextureX1 = 0,
																BackgroundTextureY1 = 0,
																BackgroundTextureX2 = 128,
																BackgroundTextureY2 = 128,
																ForegroundTextureName = "ui/alien_command_cooldown.dds",
																ForegroundTextureWidth = 128,
																ForegroundTextureHeight = 128,
																ForegroundTextureX1 = 128,
																ForegroundTextureY1 = 0,
																ForegroundTextureX2 = 256,
																ForegroundTextureY2 = 128,
																InheritParentAlpha = false })
					self.movementSpecialCooldown:GetLeftSide():SetBlendTechnique(GUIItem.Add)
					self.movementSpecialCooldown:GetRightSide():SetBlendTechnique(GUIItem.Add)
					
					self.movementSpecialIcon:AddChild(self.movementSpecialCooldown:GetBackground())
				end

				self.movementSpecialCooldown:SetIsVisible(cooldownpercentage ~= 0)
				
				if cooldownpercentage ~= 0 then
				
					self.movementSpecialCooldown:SetPercentage(cooldownpercentage)
					self.movementSpecialCooldown:Update()
					
				end
				
			end
			
		end 
		
	end
	
end

AddPostInitOverride("GUIAlienHUD", ReplaceUpdateAlienAbilities)