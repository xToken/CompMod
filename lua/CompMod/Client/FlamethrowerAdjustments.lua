//Dont want to always replace random files, so this.

local function SetupFlamethrowerGUI()
	local oldGUIFlamethrowerDisplayInitialize = GUIFlamethrowerDisplay.Initialize
	function GUIFlamethrowerDisplay:Initialize()
		oldGUIFlamethrowerDisplayInitialize(self)
		self.maxClip = kFlamethrowerClipSize
	end
end

AddPreInitOverride("GUIFlamethrowerDisplay", SetupGUIMarineBuymenu)