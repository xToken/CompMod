-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\GUI\GUIAlienHUD\post.lua
-- - Dragon

local kBackgroundSize
local kBackgroundOffset
local kPadding

local kBarWidth
local kBarHeight

local kBarActiveColor = Color(1, 1, 1, 1)
local kBarInactiveColor = Color(0.6, 0, 0, 1)

local kBackgroundPadding

local kNumBars = 20

local function UpdateItemsGUIScale(self)
    kBackgroundOffset = GUIScale(Vector(0, -50, 0))
    kPadding = math.max(1, math.round( GUIScale(3) ))

    kBarWidth = math.round( GUIScale(8) )
    kBarHeight = GUIScale(10)

    kBackgroundPadding = GUIScale(4)
end

local originalGUIAlienHUDInitialize
originalGUIAlienHUDInitialize = Class_ReplaceMethod("GUIAlienHUD", "Initialize",
	function(self)
		originalGUIAlienHUDInitialize(self)

		UpdateItemsGUIScale(self)
		
		self.rageMeter = GetGUIManager():CreateGraphicItem()
	    self.bars = {}
	    
	    local backgroundSize = Vector(kNumBars * kBarWidth + (kNumBars - 1) * kPadding + 2 * kBackgroundPadding, 2 * kBackgroundPadding + kBarHeight, 0)
	    
	    self.rageMeter:SetAnchor(GUIItem.Middle, GUIItem.Bottom)
	    self.rageMeter:SetSize(backgroundSize)
	    self.rageMeter:SetPosition(-backgroundSize * 0.5 + kBackgroundOffset)
	    self.rageMeter:SetColor(kAlienTeamColorFloat)
	    self.rageMeter:SetIsVisible(false)
	    self.resourceBackground:AddChild(self.rageMeter)
	    
	    self.rageAmount = 0
	    self.hasRage = false
	    
	    for i = 1, kNumBars do
	    
	        local pos = Vector((i - 1) * (kPadding + kBarWidth) + kBackgroundPadding, -kBarHeight * 0.5, 0)
	        local bar = GetGUIManager():CreateGraphicItem()
	        bar:SetPosition(pos)
	        bar:SetIsVisible(false)
	        bar:SetColor(kBarActiveColor)
	        bar:SetAnchor(GUIItem.Left, GUIItem.Center)
	        bar:SetSize(Vector(kBarWidth, kBarHeight, 0))
	    
	        self.rageMeter:AddChild(bar)
	        
	        table.insert(self.bars, bar)
	    
	    end

	end
)

local originalGUIAlienHUDReset
originalGUIAlienHUDReset = Class_ReplaceMethod("GUIAlienHUD", "Reset",
	function(self)
		originalGUIAlienHUDReset(self)

		UpdateItemsGUIScale(self)
		
		if self.rageMeter then
			local backgroundSize = Vector(kNumBars * kBarWidth + (kNumBars - 1) * kPadding + 2 * kBackgroundPadding, 2 * kBackgroundPadding + kBarHeight, 0)
		    self.rageMeter:SetSize(backgroundSize)
		    self.rageMeter:SetPosition(-backgroundSize * 0.5 + kBackgroundOffset)
			self.rageMeter:SetIsVisible(false)
			self.hasRage = false
		end
	end
)

local originalGUIAlienHUDUpdate
originalGUIAlienHUDUpdate = Class_ReplaceMethod("GUIAlienHUD", "Update",
	function(self, deltaTime)
		originalGUIAlienHUDUpdate(self, deltaTime)

		local hasRage = PlayerUI_GetHasOnosRage()

		if self.hasRage ~= hasRage then

			for i=1, #self.bars do
		        self.bars[i]:SetIsVisible(hasRage)
		    end
		    self.rageMeter:SetIsVisible(hasRage)
		    self.hasRage = hasRage

		end
		
		if self.hasRage then
		    
		    self.rageAmount = PlayerUI_GetOnosRageAmount()

		    for i = 1, kNumBars do
		        local rageFraction = i / kNumBars
		        self.bars[i]:SetColor(rageFraction >= self.rageAmount + 0.01 and kBarActiveColor or kBarInactiveColor )
		    end
			
		end
	end
)