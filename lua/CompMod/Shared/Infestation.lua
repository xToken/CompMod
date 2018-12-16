-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\Infestation.lua
-- - Dragon

-- InfestationMixing enhancements
function InfestationMixin:CleanupInfestation()

    for i = 1, #self.infestationPatches do
    
        local infestation = self.infestationPatches[i]
        infestation:Uninitialize()
    
    end
	
    self.infestationPatches = {}
    self.infestationGenerated = false

end