-- Natural Selection 2 Competitive Mod
-- Source located at - https://github.com/xToken/CompMod
-- lua\CompMod\Utilities\TextureReplacer\client.lua
-- - Dragon

local kCompModTextureReplaces = { }
kCompModTextureReplaces["ui/buildmenu.dds"] = "ui/buildmenu_progmod.dds"
kCompModTextureReplaces["ui/inventory_icons.dds"] = "ui/inventory_icons_progmod.dds"

for _, t in pairs(kCompModTextureReplaces) do
	PrecacheAsset(t)
end

local oldGUIItemSetTexture = GUIItem.SetTexture
function GUIItem:SetTexture(fileName)
	if kCompModTextureReplaces[fileName] then
		return oldGUIItemSetTexture(self, kCompModTextureReplaces[fileName])
	end
	return oldGUIItemSetTexture(self, fileName)
end