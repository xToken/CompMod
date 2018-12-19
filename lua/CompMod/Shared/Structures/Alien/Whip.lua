-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Shared\Whip.lua
-- - Dragon

if Server then

	local originalWhipOnDestroy
	originalWhipOnDestroy = Class_ReplaceMethod("Whip", "OnDestroy",
		function(self)
			local team = self:GetTeam()
			if team then
				team:OnTeamEntityDestroyed(self)
			end
			originalWhipOnDestroy(self)
		end
	)

end