-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\MarineTeamInfo.lua
-- - Dragon

Script.Load("lua/TeamInfo.lua")

class 'MarineTeamInfo' (TeamInfo)

MarineTeamInfo.kMapName = "MarineTeamInfo"

local networkVars =
{
    armorArmsLabs = "integer (0 to 3)",
    weaponArmsLabs = "integer (0 to 3)",
}

function MarineTeamInfo:OnCreate()

    TeamInfo.OnCreate(self)
    
    self.armorArmsLabs = 0
    self.weaponArmsLabs = 0
    
end

function MarineTeamInfo:GetUpgradeLevel(techId)
	if techId == kTechId.ArmorArmsLab then
		return self.armorArmsLabs
	elseif techId == kTechId.WeaponsArmsLab then
		return self.weaponArmsLabs
	end
end

if Server then
    
    function MarineTeamInfo:Reset()
    
		TeamInfo.Reset(self) 
		
        self.armorArmsLabs = 0
		self.weaponArmsLabs = 0
        
    end
    
    function MarineTeamInfo:OnUpdate(deltaTime)
    
        TeamInfo.OnUpdate(self, deltaTime)
        
        local team = self:GetTeam()
        if team then
        
            self.armorArmsLabs = Clamp(team:CountTrackedEntities(kTechId.ArmorArmsLab), 0, 3)
            self.weaponArmsLabs = Clamp(team:CountTrackedEntities(kTechId.WeaponsArmsLab), 0, 3)
		end
	end
	
end

Shared.LinkClassToMap("MarineTeamInfo", MarineTeamInfo.kMapName, networkVars)