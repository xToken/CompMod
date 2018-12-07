-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
-- lua\CompMod\Shared\InfestationAdjustments.lua
-- - Dragon

Script.Load( "lua/CompMod/Elixer_Utility.lua" )
Elixer.UseVersion( 1.8 )

-- InfestationMixing enhancements
function InfestationMixin:CleanupInfestation()

    for i = 1, #self.infestationPatches do
    
        local infestation = self.infestationPatches[i]
        infestation:Uninitialize()
    
    end
	
    self.infestationPatches = {}
    self.infestationGenerated = false

end