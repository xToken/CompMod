-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Client\Player.lua
-- - Dragon

local originalPlayerGetAuxWeaponClip
originalPlayerGetAuxWeaponClip = Class_ReplaceMethod("Player", "GetAuxWeaponClip",
	function(self)
		local weapon = self:GetActiveWeapon()
		if weapon then
			if weapon:isa("ClipWeapon") then
				return weapon:GetAuxClip()
			elseif weapon:isa("LayMines") then
				return weapon:GetDeployedMines()
			end
		end
		return 0
	end
)