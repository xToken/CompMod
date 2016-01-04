// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\MarineStructureAdjustments.lua
// - Dragon

Script.Load("lua/CompMod/NewTech/EnergyMixin.lua")

local structuresRequiringPower = { "Armory", "ArmsLab", "Observatory", "InfantryPortal", "RoboticsFactory", "PhaseGate", "Extractor", "PrototypeLab"}
local oldStructureInit = { }

local networkVars = { }
AddMixinNetworkVars(EnergyMixin, networkVars)

for i = 1, #structuresRequiringPower do
	oldStructureInit[structuresRequiringPower[i]] = Class_ReplaceMethod(structuresRequiringPower[i], "OnInitialized",
		function(self)
			oldStructureInit[structuresRequiringPower[i]](self)
			InitMixin(self, EnergyMixin)
		end
	)
	_G[structuresRequiringPower[i]]["GetCanUpdateEnergy"] = function(self)
		return (self.powered or self.powerSurge) and self:GetIsBuilt()
	end
	Shared.LinkClassToMap(structuresRequiringPower[i], string.lower(structuresRequiringPower[i]), networkVars)
end

if Server then

    local function Deploy(self)
        self:TriggerEffects("deploy")
    end

	function PowerConsumerMixin:SetPowerOn()
    
        if not self.powered then
        
            self.powered = true
            
			if not self.GetEnergy or self:GetEnergy() == 0 then
			
				if self.OnPowerOn then
					self:OnPowerOn()
				end
				
				if self.updateDeployOnPower then
				
					Deploy(self)
					self.updateDeployOnPower = false
					
				end
            end
			
        end
        
    end
    
    function PowerConsumerMixin:SetPowerOff()
    
        if self.powered then
        
            self.powered = false
            
			if not self.GetEnergy or self:GetEnergy() == 0 then
			
				if self.OnPowerOff then
					self:OnPowerOff()
				end
				
            end
			
        end
        
    end
	
end

function PowerConsumerMixin:GetIsPowered()
	if not self.powered and not self.powerSurge then
		if self.GetEnergy then
			return self:GetEnergy() > 0
		end
	end
    return self.powered or self.powerSurge
end