-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\AlienCommander.lua
-- - Dragon

-- Remove the cyst build button
local gAlienMenuButtons =
{
    [kTechId.BuildMenu] = { kTechId.None, kTechId.Harvester, kTechId.DrifterEgg, kTechId.Hive,
                            kTechId.ThreatMarker, kTechId.NeedHealingMarker, kTechId.ExpandingMarker, kTechId.None },
                            
    [kTechId.AdvancedMenu] = { kTechId.Crag, kTechId.Shade, kTechId.Shift, kTechId.Whip,
                               kTechId.Shell, kTechId.Veil, kTechId.Spur, kTechId.None },

    [kTechId.AssistMenu] = { kTechId.HealWave, kTechId.ShadeInk, kTechId.SelectShift, kTechId.SelectDrifter,
                             kTechId.None, kTechId.None, kTechId.BoneWall, kTechId.Contamination }
}

local gAlienMenuIds = {}
do
    for menuId, _ in pairs(gAlienMenuButtons) do
        gAlienMenuIds[#gAlienMenuIds+1] = menuId
    end
end

local function OnUpdateChamberCounts(self)
	local team = self:GetTeam()
	if team then
		self.shellCount = Clamp(team:CountTrackedEntities(kTechId.Shell), 0, 3)
		self.spurCount = Clamp(team:CountTrackedEntities(kTechId.Spur), 0, 3)
		self.veilCount = Clamp(team:CountTrackedEntities(kTechId.Veil), 0, 3)
	end
end

local originalAlienCommanderOnInitialized
originalAlienCommanderOnInitialized = Class_ReplaceMethod("AlienCommander", "OnInitialized",
	function(self)
		originalAlienCommanderOnInitialized(self)
		if Server then
			self:AddTimedCallback(OnUpdateChamberCounts, 0.05)
		end
	end
)

function AlienCommander:GetUpgradeChamberCount(techId)
	if techId == kTechId.Shell then
		return self.shellCount
	elseif techId == kTechId.Spur then
		return self.spurCount
	elseif techId == kTechId.Veil then
		return self.veilCount
	end
end

local CountToResearchId = { }
CountToResearchId[kTechId.Shell] = { [0] = kTechId.Shell, [1] = kTechId.TwoShells, [2] = kTechId.ThreeShells, [3] = kTechId.ThreeShells }
CountToResearchId[kTechId.Spur] = { [0] = kTechId.Spur, [1] = kTechId.TwoSpurs, [2] = kTechId.ThreeSpurs, [3] = kTechId.ThreeSpurs }
CountToResearchId[kTechId.Veil] = { [0] = kTechId.Veil, [1] = kTechId.TwoVeils, [2] = kTechId.ThreeVeils, [3] = kTechId.ThreeVeils }

local function GetTierTech(self, techId)
	return CountToResearchId[techId][self:GetUpgradeChamberCount(techId)]
end

local oldAlienCommanderGetButtonTable
oldAlienCommanderGetButtonTable = Class_ReplaceMethod("AlienCommander", "GetButtonTable",
	function(self)
		gAlienMenuButtons[kTechId.AdvancedMenu][5] = GetTierTech(self, kTechId.Shell)
		gAlienMenuButtons[kTechId.AdvancedMenu][6] = GetTierTech(self, kTechId.Veil)
		gAlienMenuButtons[kTechId.AdvancedMenu][7] = GetTierTech(self, kTechId.Spur)
		return gAlienMenuButtons
    end
)

local oldAlienCommanderGetMenuIds
oldAlienCommanderGetMenuIds = Class_ReplaceMethod("AlienCommander", "GetMenuIds",
	function(self)
		return gAlienMenuIds
    end
)

local oldAlienCommanderGetQuickMenuTechButtons
oldAlienCommanderGetQuickMenuTechButtons = Class_ReplaceMethod("AlienCommander", "GetQuickMenuTechButtons",
	function(self, techId)
		-- Top row always for quick access.
		local alienTechButtons = { kTechId.BuildMenu, kTechId.AdvancedMenu, kTechId.AssistMenu, kTechId.RootMenu }
		local menuButtons = self:GetButtonTable()[techId]

		if not menuButtons then
		
			-- Make sure all slots are initialized so entities can override simply.
			menuButtons = { kTechId.None, kTechId.None, kTechId.None, kTechId.None, kTechId.None, kTechId.None, kTechId.None, kTechId.None }
			
		end
		
		table.copy(menuButtons, alienTechButtons, true)
		
		-- Return buttons and true/false if we are in a quick-access menu.
		return alienTechButtons
    end
)