// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Client\HealthBarsAdjustments.lua
// - Dragon

local function SetupPreHealthBars()
	local kOtherTypes 		= GetUpValue( GUIInsight_OtherHealthbars.Update,   "kOtherTypes", 			{ LocateRecurse = true } )
	table.insert(kOtherTypes, "TunnelExit")
end

AddPreInitOverride("GUIInsight_OtherHealthbars", SetupPreHealthBars)

local function SetupPostHealthBars()
	ReplaceLocals(GUIInsight_OtherHealthbars.Update, { otherList = table.array(25) })
end

AddPostInitOverride("GUIInsight_OtherHealthbars", SetupPostHealthBars)