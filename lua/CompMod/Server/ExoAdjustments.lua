// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Server\ExoAdjustments.lua
// - Dragon

//Cap Maximum 'Active' Exos
/*
local function GetActiveExos(player)
	local exos = GetEntitiesForTeam("Exo", player:GetTeamNumber())
	return #exos or 0
end

function Exosuit:GetIsValidRecipient(recipient)
    return not recipient:isa("Exo") and (self.ownerId == Entity.invalidId or self.ownerId == recipient:GetId()) and GetActiveExos(recipient) < kMaximumExosuitsActive
end

local originalMarineAttemptToBuy
originalMarineAttemptToBuy = Class_ReplaceMethod("Marine", "AttemptToBuy",
	function(self, techIds)
		local techId = techIds[1]
		if kIsExoTechId[techId] and GetActiveExos(self) >= kMaximumExosuitsActive then
			//Over cap
			local playerClient = Server.GetOwner(self)
			if playerClient then
				Server.SendNetworkMessage(playerClient, "Chat", BuildChatMessage(true, "Notification", -1, kTeamReadyRoom, kNeutralTeamType, "Too many active exos on this team!"), true)
			end
			return false
		end
		return originalMarineAttemptToBuy(self, techIds)
	end
)
*/