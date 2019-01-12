-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Alien\AlienCommander\shared.lua
-- - Dragon

-- Remove the cyst build button
local gAlienMenuButtons =
{
    [kTechId.BuildMenu] = { kTechId.Cyst, kTechId.Harvester, kTechId.DrifterEgg, kTechId.Hive,
                            kTechId.ThreatMarker, kTechId.NeedHealingMarker, kTechId.ExpandingMarker, kTechId.None },
                            
    [kTechId.AdvancedMenu] = { kTechId.Crag, kTechId.Shade, kTechId.Shift, kTechId.Whip,
                               kTechId.Shell, kTechId.Veil, kTechId.Spur, kTechId.None },

    [kTechId.AssistMenu] = { kTechId.HealWave, kTechId.ShadeInk, kTechId.ShiftEnergize, kTechId.SelectDrifter,
                             kTechId.NutrientMist, kTechId.EnzymeCloud, kTechId.BoneWall, kTechId.Hallucinate }
}

local gAlienMenuIds = {}
do
    for menuId, _ in pairs(gAlienMenuButtons) do
        gAlienMenuIds[#gAlienMenuIds+1] = menuId
    end
end

local gTeleportClassnames
function GetEchoTeleportTechIdForClassname(classname)

    if not gTeleportClassnames then
    
        gTeleportClassnames = {}
        gTeleportClassnames["Hydra"] = kTechId.TeleportHydra
        gTeleportClassnames["Whip"] = kTechId.TeleportWhip
        gTeleportClassnames["TunnelEntrance"] = kTechId.TeleportTunnel
        gTeleportClassnames["Crag"] = kTechId.TeleportCrag
        gTeleportClassnames["Shade"] = kTechId.TeleportShade
        gTeleportClassnames["Shift"] = kTechId.TeleportShift
        gTeleportClassnames["Veil"] = kTechId.TeleportVeil
        gTeleportClassnames["Spur"] = kTechId.TeleportSpur
        gTeleportClassnames["Shell"] = kTechId.TeleportShell
        gTeleportClassnames["Hive"] = kTechId.TeleportHive
        gTeleportClassnames["Egg"] = kTechId.TeleportEgg
        gTeleportClassnames["Harvester"] = kTechId.TeleportHarvester
    end
    
    return gTeleportClassnames[classname]

end

function GetIsEchoTeleportTechId(techId)

return techId == kTechId.TeleportHydra or
       techId == kTechId.TeleportWhip or
       techId == kTechId.TeleportTunnel or
       techId == kTechId.TeleportCrag or
       techId == kTechId.TeleportShade or
       techId == kTechId.TeleportShift or
       techId == kTechId.TeleportVeil or
       techId == kTechId.TeleportSpur or
       techId == kTechId.TeleportShell or
       techId == kTechId.TeleportHive or
       techId == kTechId.TeleportEgg or
       techId == kTechId.TeleportHarvester

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

local GetNearest = GetUpValue( AlienCommander.GetTechAllowed, "GetNearest" )

local oldAlienCommanderGetTechAllowed = AlienCommander.GetTechAllowed
function AlienCommander:GetTechAllowed(techId, techNode)
  local allowed, canAfford = oldAlienCommanderGetTechAllowed(self, techId, techNode)
  if techId == kTechId.ShiftEnergize then
      allowed = GetNearest(self, "Shift") ~= nil
  end
  return allowed, canAfford
end

function AlienCommander:GetUpgradeChamberCount(techId)
	if techId == kTechId.Shell then
		return self.shellCount
	elseif techId == kTechId.Spur then
		return self.spurCount
	elseif techId == kTechId.Veil then
		return self.veilCount
	end
end

local oldAlienCommanderGetButtonTable
oldAlienCommanderGetButtonTable = Class_ReplaceMethod("AlienCommander", "GetButtonTable",
	function(self)
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