//Dont want to always replace random files, so this.

//Fix commander abilities not triggering right away
local originalCommanderAbilityOnInitialized
originalCommanderAbilityOnInitialized = Class_ReplaceMethod("CommanderAbility", "OnInitialized",
	function(self)
		originalCommanderAbilityOnInitialized(self)
		if self:GetType() == CommanderAbility.kType.Repeat then
			self:Perform()
		end	
	end
)