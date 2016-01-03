// Natural Selection 2 Competitive Mod
// Source located at - https://github.com/xToken/CompMod
// Detailed breakdown of changes at https://docs.google.com/document/d/1YOnjJz6_GhioysLaWiRfc17xnrmw6AEJIb6gq7TX3Qg/edit?pli=1
// lua\CompMod\Shared\MinimapAdjustments.lua
// - Dragon

local oldMapBlipMixinGetMapBlipInfo = MapBlipMixin.GetMapBlipInfo
function MapBlipMixin:GetMapBlipInfo()
	local success, blipType, blipTeam, isAttacked, isParasited = oldMapBlipMixinGetMapBlipInfo(self)
	if self:isa("Embryo") then
		//Fucking seriously NS2??????????????????
		blipType = kMinimapBlipType["Egg"]
	end
	return success, blipType, blipTeam, isAttacked, isParasited
end