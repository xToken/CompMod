-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Structures\Marine\PrototypeLab\shared.lua
-- - Dragon

local originalPrototypeLabOnInitialized
originalPrototypeLabOnInitialized = Class_ReplaceMethod("PrototypeLab", "OnInitialized",
    function(self)        
        originalPrototypeLabOnInitialized(self)
        if Server then
            InitMixin(self, SupplyUserMixin)
        end
    end
)

function PrototypeLab:GetTechButtons(techId)
	
	local techButtons = { kTechId.CatPackTech, kTechId.NanoArmor, kTechId.JetpackTech, kTechId.ExoUpgrade1, 
             kTechId.None, kTechId.None, kTechId.None, kTechId.None }
			 
	if GetHasTech(self, kTechId.JetpackTech) then
        techButtons[3] = kTechId.JetpackUpgrade1
    end

	if GetHasTech(self, kTechId.ExoUpgrade1) then
        techButtons[4] = kTechId.ExoUpgrade2
    end
	
    return techButtons
end

function PrototypeLab:GetItemList(forPlayer)

    return { kTechId.Jetpack }
    
end