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
        if gameInfo and (not gameInfo.GetTournamentMode or not gameInfo:GetTournamentMode()) then
			return originalPlayerGetShowHealthFor(self, player)
		end
		return ( player:isa("Spectator") or player:isa("Commander") or ( not GetAreEnemies(self, player) and self:GetIsAlive() ) ) and self:GetTeamType() ~= kNeutralTeamType
	end
)

function Player:GetCommHealthBarsShown()
    return self.commHealthBars and self.commHealthBars or false
end

local oldPlayerUI_GetStatusInfoForUnit = PlayerUI_GetStatusInfoForUnit
function PlayerUI_GetStatusInfoForUnit(player, unit)
	local unitState = oldPlayerUI_GetStatusInfoForUnit(player, unit)
	if unitState then
		if HasMixin(unit, "Maturity") then
			unitState.CatalystRemaining = math.max((unit.timeCatalystEnds and unit.timeCatalystEnds or 0) - Shared.GetTime(), 0)
			unitState.CatalystScalar = unit.GetSustenanceScalar and unit:GetSustenanceScalar() or 1
		end
		local visibleToPlayer = true
        local isPlayer = unit:isa("Player")
        local areEnemies = GetAreEnemies(player, unit)
    
        if HasMixin(unit, "Cloakable") and areEnemies then

            if unit:GetIsCloaked() or (isPlayer and unit:GetCloakFraction() > 0.2) then
                visibleToPlayer = false
            end

        end

        -- Don't show tech points or nozzles if they are attached
        if visibleToPlayer and (unit:GetMapName() == TechPoint.kMapName or unit:GetMapName() == ResourcePoint.kPointMapName) and unit.GetAttached and (unit:GetAttached() ~= nil) then
            visibleToPlayer = false
        end
		unitState.CommHealthBarsToggle = not isPlayer and player:GetCommHealthBarsShown() and not areEnemies and visibleToPlayer and not unit:isa("Weapon")
	end

	return unitState
end

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

function PlayerUI_GetHasOnosRage()

    local player = Client.GetLocalPlayer()

    if player and player:GetIsPlaying() and player:isa("Onos") then

        return true

    end

    return false

end

function PlayerUI_GetOnosRageAmount()

    local player = Client.GetLocalPlayer()

    if player and player:GetIsPlaying() and player:isa("Onos") then

        return player:GetRage()

    end

    return 0

end