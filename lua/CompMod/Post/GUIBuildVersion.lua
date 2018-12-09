-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Client\GUIBuildVersion.lua
-- - Dragon

local originalFeedbackInit
originalFeedbackInit = Class_ReplaceMethod("GUIFeedback", "Initialize",
function(self)
	originalFeedbackInit(self)
	self.buildText:SetText(self.buildText:GetText() .. " (" .. "CompMod" .. " v"  .. kCompModVersion .. "." .. kCompModBuild .. ")")
end)