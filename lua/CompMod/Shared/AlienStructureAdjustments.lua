// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\AlienStructureAdjustments.lua
// - Dragon

local structuresWithInfestation = { "Crag", "Shift", "Shade", "Spur", "Veil", "Shell", "Harvester", "Whip"}
local structureInfestRangeLookup = { kStructureInfestationRadius, kStructureInfestationRadius, kStructureInfestationRadius, kStructureInfestationRadius, 
									kStructureInfestationRadius, kStructureInfestationRadius, kHarvesterInfestationRadius, kStructureInfestationRadius}
local structureMaxInfestRangeLookup = { kStructureInfestationRadius, kStructureInfestationRadius, kStructureInfestationRadius, kStructureInfestationRadius,
									kStructureInfestationRadius, kStructureInfestationRadius, kHarvesterInfestationRadius, kStructureInfestationRadius}
local oldStructureInit = { }

local networkVars = { }
AddMixinNetworkVars(InfestationMixin, networkVars)

for i = 1, #structuresWithInfestation do
	oldStructureInit[structuresWithInfestation[i]] = Class_ReplaceMethod(structuresWithInfestation[i], "OnInitialized",
		function(self)
			oldStructureInit[structuresWithInfestation[i]](self)
			InitMixin(self, InfestationMixin)
		end
	)
	_G[structuresWithInfestation[i]]["GetInfestationRadius"] = function(self)
		return structureInfestRangeLookup[i]
	end
	_G[structuresWithInfestation[i]]["GetInfestationMaxRadius"] = function(self)
		return structureMaxInfestRangeLookup[i]
	end
	Shared.LinkClassToMap(structuresWithInfestation[i], string.lower(structuresWithInfestation[i]), networkVars)
end