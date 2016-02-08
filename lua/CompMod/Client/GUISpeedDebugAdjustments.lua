// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Client\GUISpeedDebugAdjustments.lua
// - Dragon

local function ModifyGUISpeedDebug()
	local originalGUISpeedDebugUpdate
	originalGUISpeedDebugUpdate = Class_ReplaceMethod("GUISpeedDebug", "Update",
	function(self, deltaTime)
		originalGUISpeedDebugUpdate(self, deltaTime)
		local player = Client.GetLocalPlayer()
		if player then
			if player:isa("Fade") then
				self.airAccel:SetText("model offset amount: " .. ToString(player.modelOffset))
			end
		end
	end)
end

AddPreInitOverride("GUISpeedDebug", ModifyGUISpeedDebug)