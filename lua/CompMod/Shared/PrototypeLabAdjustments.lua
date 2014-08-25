//Dont want to always replace random files, so this.

local originalPrototypeLabGetItemList
originalPrototypeLabGetItemList = Class_ReplaceMethod("PrototypeLab", "GetItemList",
	function(self, forPlayer)
    
		return { kTechId.Jetpack, kTechId.DualMinigunExosuit, kTechId.DualRailgunExosuit, }
		
	end
)