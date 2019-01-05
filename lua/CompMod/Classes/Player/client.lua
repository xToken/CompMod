-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Player\client.lua
-- - Dragon

Script.Load("lua/CompMod/Utilities/CustomBindings/client.lua")

local originalPlayerGetAuxWeaponClip
originalPlayerGetAuxWeaponClip = Class_ReplaceMethod("Player", "GetAuxWeaponClip",
	function(self)
		local weapon = self:GetActiveWeapon()
		if weapon then
			if weapon:isa("ClipWeapon") then
				return weapon:GetAuxClip()
			elseif weapon:isa("LayMines") then
				return weapon:GetDeployedMines()
			end
		end
		return 0
	end
)

local originalPlayerGetShowHealthFor
originalPlayerGetShowHealthFor = Class_ReplaceMethod("Player", "GetShowHealthFor",
	function(self, player)
		local gameInfo = GetGameInfoEntity()
        if gameInfo and not gameInfo:GetTournamentMode() then
			return originalPlayerGetShowHealthFor(self, player)
		end
		return ( player:isa("Spectator") or player:isa("Commander") or ( not GetAreEnemies(self, player) and self:GetIsAlive() ) ) and self:GetTeamType() ~= kNeutralTeamType
	end
)

local oldPlayerUI_ShowsUnitStatusInfo = PlayerUI_ShowsUnitStatusInfo
function PlayerUI_ShowsUnitStatusInfo(player, unit)
	if player:isa("Commander") and player.healthBarsToggle then
		return not GetAreEnemies(player, unit)
	end
	return oldPlayerUI_ShowsUnitStatusInfo(player, unit)
end

function Player:OnShowHealthBars(toggle)
	if not self.healthBarsToggle then self.healthBarsToggle = false end
	if toggle then
    	self.healthBarsToggle = not self.healthBarsToggle
    end
end

local originalPlayerSendKeyEvent
originalPlayerSendKeyEvent = Class_ReplaceMethod("Player", "SendKeyEvent",
	function(self, key, down)
		local handled = originalPlayerSendKeyEvent(self, key, down)
		if handled then return handled end
		if not ChatUI_EnteringChatMessage() and not MainMenu_GetIsOpened() then
			if GetIsBinding(key, "ToggleHealthBars") and self:isa("Commander") then
	            self:OnShowHealthBars(down)
	        end
		end
	end
)

RegisterCustomBinding("ToggleHealthBars", nil, "input", "Toggle Health Bars", "H", true)

function PlayerUI_GetExoRepairAvailable()

    local player = Client.GetLocalPlayer()

    if player and player:GetIsPlaying() and player:isa("Exo") and player.GetRepairAllowed then

        return player:GetRepairAllowed(), player:GetFuel() >= kExoRepairMinFuel, player.repairActive

    end

    return false, false, false

end

function PlayerUI_GetExoThrustersAvailable()

    local player = Client.GetLocalPlayer()

    if player and player:GetIsPlaying() and player:isa("Exo") and player.GetIsThrusterAllowed then

        return player:GetIsThrusterAllowed(), player:GetFuel() >= kExoThrusterMinFuel, player.thrustersActive

    end

    return false, false, false

end

function PlayerUI_GetExoShieldAvailable()

    local player = Client.GetLocalPlayer()

    if player and player:GetIsPlaying() and player:isa("Exo") and player.GetShieldAllowed then

        return player:GetShieldAllowed(), player:GetFuel() >= kExoShieldMinFuel, player.shieldActive

    end

    return false, false, false

end