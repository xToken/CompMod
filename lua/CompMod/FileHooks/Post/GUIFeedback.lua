-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\FileHooks\Post\GUIFeedback.lua
-- - Dragon

local originalFeedbackInit
originalFeedbackInit = Class_ReplaceMethod("GUIFeedback", "Initialize",
function(self)
	originalFeedbackInit(self)
	self.buildText:SetText(self.buildText:GetText() .. " (" .. "Prog-Mod" .. " v"  .. kCompModVersion .. "." .. kCompModBuild .. ")")
end)