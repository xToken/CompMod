//Dont want to always replace random files, so this.

local function SetupPreHealthBars()
	local kOtherTypes 		= GetUpValue( GUIInsight_OtherHealthbars.Update,   "kOtherTypes", 			{ LocateRecurse = true } )
	table.insert(kOtherTypes, "TunnelExit")
end

AddPreInitOverride("GUIInsight_OtherHealthbars", SetupPreHealthBars)

local function SetupPostHealthBars()
	ReplaceLocals(GUIInsight_OtherHealthbars.Update, { otherList = table.array(25) })
end

AddPostInitOverride("GUIInsight_OtherHealthbars", SetupPostHealthBars)