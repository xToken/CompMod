-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\MarineStructureAdjustments.lua
-- - Dragon

local originalMarineTeamOnResetComplete
originalMarineTeamOnResetComplete = Class_ReplaceMethod("MarineTeam", "OnResetComplete",
	function(self)
		originalMarineTeamOnResetComplete(self)
		for index, powerPoint in ientitylist(Shared.GetEntitiesWithClassname("PowerPoint")) do
			-- Always built!
			powerPoint:SetConstructionComplete()
		end
	end
)