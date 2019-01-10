-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Classes\Player\client.lua
-- - Dragon

local kShowChangelogDelay
local initTime = Shared.GetSystemTimeReal()

local function OnShowChangelog(self)
	if not self.changelog then
        self.changelog = GetGUIManager():CreateGUIScript("CompMod/GUI/GUIProGModChangelog/GUIProGModChangelog")
    end
end

local function OnShowChangelogCallback(self)      
	if self:GetIsLocalPlayer() and not HelpScreen_GetHelpScreen():GetIsBeingDisplayed() and self:isa("ReadyRoomPlayer") and Client.GetOptionInteger("LastProGModBuild", 0) < kCompModBuild then
		Client.SetOptionInteger("LastProGModBuild", kCompModBuild)
		OnShowChangelog(self)
	end
	return false
end

local originalReadyRoomPlayerOnCreate
originalReadyRoomPlayerOnCreate = Class_ReplaceMethod("ReadyRoomPlayer", "OnCreate",
	function(self)
		originalReadyRoomPlayerOnCreate(self)
		self:AddTimedCallback(OnShowChangelogCallback, math.max(kShowChangelogDelay, 4))
	end
)

function ReadyRoomPlayer:SendKeyEvent(key, down)
	if self:GetIsLocalPlayer() and not HelpScreen_GetHelpScreen():GetIsBeingDisplayed() then
		if GetIsBinding(key, "ShowMap") and down then
            OnShowChangelog(self)
            return true
        end
	end
	return Player.SendKeyEvent(self, key, down)
end

function DestroyProGModChangelogGUI()
	local player = Client:GetLocalPlayer()
	if player then
		player.changelog = nil
	end
end

local function OnClientLoaded()
	kShowChangelogDelay = math.min(Shared.GetSystemTimeReal() - initTime, 20)
end

Event.Hook("LoadComplete", OnClientLoaded)