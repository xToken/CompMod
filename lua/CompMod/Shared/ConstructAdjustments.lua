// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\ConstructAdjustments.lua
// - Dragon

local function CreateBuildEffect(self)

    if not self.buildMaterial then
        
        local model = self:GetRenderModel()
        if model then
        
            local material = Client.CreateRenderMaterial()
            material:SetMaterial(kBuildMaterial)
            model:AddMaterial(material)
            self.buildMaterial = material
        
        end
        
    end    
    
end

local function RemoveBuildEffect(self)

    if self.buildMaterial then
      
        local model = self:GetRenderModel()  
        local material = self.buildMaterial
        model:RemoveMaterial(material)
        Client.DestroyRenderMaterial(material)
        self.buildMaterial = nil
                    
    end            

end

function ConstructMixin:OnConstructUpdate(deltaTime)
        
    local effectTimeout = Shared.GetTime() - self.timeLastConstruct > 0.65
    self.underConstruction = not self:GetIsBuilt() and not effectTimeout
    
    if not self:GetIsBuilt() and GetIsAlienUnit(self) and self.hasDrifterEnzyme then
		self:Construct(deltaTime)
    end
    
    if self.timeDrifterConstructEnds then
        
        if self.timeDrifterConstructEnds <= Shared.GetTime() then
        
            self.hasDrifterEnzyme = false
            self.timeDrifterConstructEnds = nil
            
        end
        
    end
	
	if Client then
		if GetIsMarineUnit(self) then
			if self.underConstruction then
				CreateBuildEffect(self)
			else
				RemoveBuildEffect(self)
			end
			if self.underConstruction or not self.constructionComplete then
				return kUpdateIntervalLow
			end
		end
    end
	
    if self.underConstruction or not self.constructionComplete then
        return kUpdateIntervalFull
    end
    
    // stop running once we are fully constructed
    return false
    
end