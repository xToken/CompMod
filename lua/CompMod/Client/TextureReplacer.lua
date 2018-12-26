-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Client\TextureReplacer.lua
-- - Dragon

local kCompModTextureReplaces = { }
kCompModTextureReplaces["ui/buildmenu.dds"] = "ui/buildmenu_compmod.dds"

local oldGUIItemSetTexture = GUIItem.SetTexture
function GUIItem:SetTexture(fileName)
	if kCompModTextureReplaces[fileName] then
		return oldGUIItemSetTexture(self, kCompModTextureReplaces[fileName])
	end
	return oldGUIItemSetTexture(self, fileName)
end