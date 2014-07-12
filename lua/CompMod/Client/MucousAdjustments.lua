//Dont want to always replace random files, so this.

Alien.kMucousViewMaterialName = "cinematics/vfx_materials/mucousshield_view.material"
Alien.kMucousThirdpersonMaterialName = "cinematics/vfx_materials/mucousshield.material"
Shared.PrecacheSurfaceShader("cinematics/vfx_materials/mucousshield.surface_shader")
Shared.PrecacheSurfaceShader("cinematics/vfx_materials/mucousshield_view.surface_shader")

local kMucousEffectInterval = 1

local function UpdateMucousEffects(self, isLocal)

    if self.mucousClient ~= self.mucousShield then

        if isLocal then
        
            local viewModel= nil        
            if self:GetViewModelEntity() then
                viewModel = self:GetViewModelEntity():GetRenderModel()  
            end
                
            if viewModel then
   
                if self.mucousShield then
                    self.mucousViewMaterial = AddMaterial(viewModel, Alien.kMucousViewMaterialName)
                else
                
                    if RemoveMaterial(viewModel, self.mucousViewMaterial) then
                        self.mucousViewMaterial = nil
                    end
  
                end
            
            end
        
        end
        
        local thirdpersonModel = self:GetRenderModel()
        if thirdpersonModel then
        
            if self.mucousShield then
                self.mucousMaterial = AddMaterial(thirdpersonModel, Alien.kMucousThirdpersonMaterialName)
            else
            
                if RemoveMaterial(thirdpersonModel, self.mucousMaterial) then
                    self.mucousMaterial = nil
                end

            end
        
        end
        
        self.mucousClient = self.mucousShield
        
    end

    // update cinemtics
    if self.mucousShield then

        if not self.lastMucousEffect or self.lastMucousEffect + kMucousEffectInterval < Shared.GetTime() then
        
			//Uh?
            //self:TriggerEffects("enzymed")
            self.lastMucousEffect = Shared.GetTime()
        
        end

    end 

end

local originalAlienUpdateClientEffects
originalAlienUpdateClientEffects = Class_ReplaceMethod("Alien", "UpdateClientEffects",
	function(self, deltaTime, isLocal)
		originalAlienUpdateClientEffects(self, deltaTime, isLocal)
		UpdateMucousEffects(self, isLocal)
	end
)

function PlayerUI_GetHasMucousShield()

	local player = Client.GetLocalPlayer()
    if player and player.GetHasMucousShield then
        return player:GetHasMucousShield()   
    end
    return false
	
end

function PlayerUI_GetMucousShieldHP()

	local player = Client.GetLocalPlayer()
    if player and player.GetMuscousShieldAmount then
    
        local health = math.ceil(player:GetMuscousShieldAmount())
        return health
        
    end
    
    return 0
	
end

local kShieldTextYOffset = 75
local kShieldTextXOffset = -30
local kShieldTextColor = Color(0, 1, 0.2, 1)
local kShieldFontName = "fonts/Stamp_medium.fnt"

local function CreateMucousText(self)
	self.mucousText = GUIManager:CreateTextItem()
    self.mucousText:SetFontName(kShieldFontName)
    self.mucousText:SetAnchor(GUIItem.Middle, GUIItem.Center)
    self.mucousText:SetPosition(Vector(GUIScale(kShieldTextXOffset), GUIScale(kShieldTextYOffset), 0))
    self.mucousText:SetTextAlignmentX(GUIItem.Align_Center)
    self.mucousText:SetTextAlignmentY(GUIItem.Align_Center)
    self.mucousText:SetColor(kShieldTextColor)
    self.mucousText:SetInheritsParentAlpha(true)
    self.lastmucousstate = false
	
	if self.healthBall then
		self.healthBall:GetBackground():AddChild(self.mucousText)
	end
end

local function UpdateMucousAmount(self)
	if self.mucousText then
		local shieldHP = PlayerUI_GetMucousShieldHP()
		local hasShield = PlayerUI_GetHasMucousShield()
		if not hasShield and self.lastmucousstate then
			self.mucousText:SetText(tostring(0))
			self.mucousText:SetIsVisible(false)
			self.lastmucousstate = false
		end
		if hasShield then
			local displayshieldHP = math.floor(shieldHP)
			if shieldHP > 0 and displayshieldHP == 0 then
				displayshieldHP = 1
			end
			self.mucousText:SetText("Shield: " .. tostring(displayshieldHP))
			if not self.lastmucousstate then
				self.mucousText:SetIsVisible(true)
				self.lastmucousstate = true
			end
		end
	else
		//Create the damn thing?
		CreateMucousText(self)
	end
end
	
local function SetupGUIAlienHUD(script)
	
	CreateMucousText(script)
	
	local oldGUIAlienHUDUpdate = GUIAlienHUD.Update
	function GUIAlienHUD:Update(deltaTime)
		oldGUIAlienHUDUpdate(self, deltaTime)
		UpdateMucousAmount(self)
	end
	
end

AddPostInitOverride("GUIAlienHUD", SetupGUIAlienHUD)