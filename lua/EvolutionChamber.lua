//
// lua\EvolutionChamber.lua
//

Script.Load("lua/Mixins/ClientModelMixin.lua")
Script.Load("lua/SelectableMixin.lua")
Script.Load("lua/TeamMixin.lua")
Script.Load("lua/EntityChangeMixin.lua")
Script.Load("lua/ResearchMixin.lua")
Script.Load("lua/ScriptActor.lua")

class 'EvolutionChamber' (ScriptActor)

EvolutionChamber.kMapName = "evolutionchamber"

EvolutionChamber.kModelName = PrecacheAsset("models/alien/crag/crag.model")
EvolutionChamber.kAnimationGraph = PrecacheAsset("models/alien/crag/crag.animation_graph")

local networkVars = { }

AddMixinNetworkVars(BaseModelMixin, networkVars)
AddMixinNetworkVars(ClientModelMixin, networkVars)
AddMixinNetworkVars(TeamMixin, networkVars)
AddMixinNetworkVars(ResearchMixin, networkVars)
AddMixinNetworkVars(SelectableMixin, networkVars)

function EvolutionChamber:OnCreate()

    ScriptActor.OnCreate(self)
    
    InitMixin(self, BaseModelMixin)
    InitMixin(self, ClientModelMixin)
    InitMixin(self, TeamMixin)
    InitMixin(self, SelectableMixin)
    InitMixin(self, EntityChangeMixin)
    InitMixin(self, ResearchMixin)
    
    self:SetUpdates(true)
    self:SetLagCompensated(false)
    
end

function EvolutionChamber:OnInitialized()

    ScriptActor.OnInitialized(self)
    
    self:SetModel(EvolutionChamber.kModelName, EvolutionChamber.kAnimationGraph)
    
end

function EvolutionChamber:SetIncludeRelevancyMask(includeMask)

    includeMask = bit.bor(includeMask, kRelevantToTeam2Commander)    
    ScriptActor.SetIncludeRelevancyMask(self, includeMask)    

end

local kUpgradeButtons =
{							 
	[kTechId.SkulkMenu] = { kTechId.Leap, kTechId.Xenocide, kTechId.None, kTechId.None,
								kTechId.None, kTechId.None, kTechId.None, kTechId.None },
							 
	[kTechId.GorgeMenu] = { kTechId.BabblerTech, kTechId.BileBomb, kTechId.WebTech, kTechId.None,
								 kTechId.None, kTechId.None, kTechId.None, kTechId.None },
								 
	[kTechId.LerkMenu] = { kTechId.Umbra, kTechId.Spores, kTechId.None, kTechId.None,
								 kTechId.None, kTechId.None, kTechId.None, kTechId.None },
								 
	[kTechId.FadeMenu] = { kTechId.MetabolizeEnergy, kTechId.MetabolizeHealth, kTechId.Stab, kTechId.None,
								 kTechId.None, kTechId.None, kTechId.None, kTechId.None },
								 
	[kTechId.OnosMenu] = { kTechId.Charge, kTechId.BoneShield, kTechId.Stomp, kTechId.None,
								 kTechId.None, kTechId.None, kTechId.None, kTechId.None }
}

function EvolutionChamber:GetTechButtons(techId)

    local techButtons = { kTechId.SkulkMenu, kTechId.GorgeMenu, kTechId.LerkMenu, kTechId.FadeMenu,
								kTechId.OnosMenu, kTechId.None, kTechId.None, kTechId.None }
						  
	if kUpgradeButtons[techId] ~= nil then
		techButtons = kUpgradeButtons[techId]
	end
	
	if techButtons[1] ~= kTechId.SkulkMenu then
		if self:GetIsResearching() then
			techButtons[7] = kTechId.Return
		else
			techButtons[7] = kTechId.None
			techButtons[8] = kTechId.Return
		end
	end
	
	if self:GetIsResearching() then
		techButtons[8] = kTechId.Cancel
    end
	
    return techButtons
    
end

function EvolutionChamber:OnAdjustModelCoords(modelCoords)
    local coords = modelCoords
	local scale = 0.33
    if scale then
        coords.xAxis = coords.xAxis * scale
        coords.yAxis = coords.yAxis * scale
        coords.zAxis = coords.zAxis * scale
    end
    return coords
end

Shared.LinkClassToMap("EvolutionChamber", EvolutionChamber.kMapName, networkVars)