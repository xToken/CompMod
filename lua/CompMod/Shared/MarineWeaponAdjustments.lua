// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\MarineWeaponAdjustments.lua
// - Dragon

//Fix for ghost firing when releasing E.
function Builder:OnDraw(player, previousWeaponMapName)

    Weapon.OnDraw(self, player, previousWeaponMapName)
    self.building = true
    // Attach weapon to parent's hand
    self:SetAttachPoint(Weapon.kHumanAttachPoint)
    
end

function Builder:OnUpdateAnimationInput(modelMixin)

    PROFILE("Builder:OnUpdateAnimationInput")
    
    local activity = "none"
    if self.building then
        activity = "primary"
    end
    
    modelMixin:SetAnimationInput("activity", activity)
    modelMixin:SetAnimationInput("welder", false)
    self:SetPoseParam("welder", 0)
    
end

//Hacky fix for reload bugs.
local kRifleReloadWindow = 1.5
local kRifleCatalystReloadWindow = 1
local function FillClip(self)

    // Stick the bullets in the clip back into our pool so that we don't lose
    // bullets. Not realistic, but more enjoyable
    self.ammo = self.ammo + self.clip
    
    // Transfer bullets from our ammo pool to the weapon's clip
    self.clip = math.min(self.ammo, self:GetClipSize())
    self.ammo = math.min(self.ammo - self.clip, self:GetMaxAmmo())
    
end

local function CheckForSuccessfulReload(self)

	//Check if started another reload
	if self.reloadStart + self.reloadTime < Shared.GetTime() and self.reloading and not self.reloaded then
		FillClip(self)
		self.reloading = false
		self.reloaded = false
	end
end

function Rifle:OnReload(player)

    if self:CanReload() then
    
        self:TriggerEffects("reload")
        self.reloading = true
		self.reloadTime = kRifleReloadWindow
		if player.catpackboost then
			self.reloadTime = kRifleCatalystReloadWindow
		end
		self.reloadStart = Shared.GetTime()
		self:AddTimedCallback(CheckForSuccessfulReload, self.reloadTime + 0.1)
        
    end
    
end